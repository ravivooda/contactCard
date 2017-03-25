#!/usr/bin/python

from flask import Flask, request, session, g
from functools import wraps
from helpers import env_constants
import unidecode

import db,logic

####################################################################################################
#                                                                                                  #
#                                          DECORATORS                                              #
#                                                                                                  #
####################################################################################################
class public(object):
    def __init__(self, setup_session = False):
        self.setup_session = setup_session

    def __call__(self, f):
        @wraps(f)
        def decorated_function(*args, **kwds):
            result = f(*args,**kwds)
            if result and result['success'] and self.setup_session:
                session['user_id'] = result.get('user_id')
            return result
        return decorated_function

class loggedin(object):
    def __init__(self, f):
        self.f = f
        
    def __call__(self, *args):
        if session.get('user_id') is None:
            return {'success': False, 'error': env_constants.NOT_LOGGED_IN_ERROR, 'should_logout': True}
        return self.f(*args)

class with_args(object):
    def __init__(self,must_args=[],test_args=[]):
        self.test_args = test_args
        self.must_args = must_args
        
    def __call__(self, f):
        @wraps(f)
        def decorated_function(*args, **kwds):
            missing_params = []

            # Checking for the MUST have parameters
            for arg in self.must_args:
                if not request.args.get(arg) and not request.form.get(arg):
                    missing_params.append(arg)

            # Checking for the ATLEAST ONE have parameters
            for arg_arr in self.test_args:
                found = False
                for arg in arg_arr:
                    if request.args.get(arg) or request.form.get(arg):
                        found = True;
                        break;
                if not found:
                    missing_params.append(arg_arr)

            if len(missing_params) > 0:
                print missing_params
                return {'success': False, 
                        'error': env_constants.INVALID_REQUEST_ERROR,
                        'missing_parameters': missing_params}
            return f(*args, **kwds)
        return decorated_function
        

####################################################################################################
#                                                                                                  #
#                                         PUBLIC API                                               #
#                                                                                                  #
####################################################################################################
@public()
# for now user_name, display_name, email, password are required
@with_args(['email', 'password'])
def signup():
    email = request.args.get('email')
    password = request.args.get('password')
    user,error = logic.signup(email,password)
    if error:
        return {'success': False, 'error': error}
    session['user_id'] = user['user_id']
    return {'success': True, 'my_info':user}

@public()
@with_args(['password', 'email'])
def login():
    email = request.values.get('email')
    password = request.values.get('password')
    user_info, error = logic.login(email,password)
    if error:
        return {'success': False, 'error': error}
    session['user_id'] = user_info['user_id']
    return {'success':True, 'my_info': user_info}

####################################################################################################
#                                                                                                  #
#                                      LOGGED IN API                                               #
#                                                                                                  #
####################################################################################################
@loggedin
@with_args(['user_id'])
def get_user():
    user = logic.get_user(user_id)
    if not user:
        return {'success':False,'error':'No such user exists'}
    return {'success':True, 'user': user}


@loggedin
def logout():
    session.clear()
    return {'success':True}

@loggedin
@with_args(['data'])
def create_card():
    data = request.values['data']
    user_id = session['user_id']
    print("Create Card : " + data)
    card_id, error = logic.create_card(data, user_id)
    if error:
        return {'success': False, 'error': error}
    return {'success': True, 'card_id': card_id}

@loggedin
def my_cards():
    user_id = session['user_id']
    cards, error = logic.get_cards(user_id)
    if error:
        return {'success': False, 'error':error}
    for card in cards:
        card['value'] = card['value'].decode("ascii", "replace")
        # card['value'] = unidecode.unidecode(card['value'].decode())
    # cards = [unidecode.unidecode(card) for card in cards]
    return {'success':True, 'cards':cards}

@loggedin
@with_args(['card_id', 'data'])
def edit_card():
    data = request.values['data']
    user_id = session['user_id']
    card_id = request.values['card_id']
    card_id, error = logic.edit_card(card_id, data, user_id)
    if error:
        return {'success': False, 'error': error}
    return {'success': True, 'card_id': card_id}

@loggedin
@with_args(['contact_ids',])
def contact_updates():
    contact_ids = request.values['contact_ids'].split(",")
    user_id = session['user_id']
    cards_info, error = logic.contact_updates(contact_ids, user_id)
    if error:
        return report_error(error)
    return {'success': True, 'contacts_data': cards_info}
    

def report_error(error):
    return {'success': False, 'error': error}
