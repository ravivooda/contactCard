#!/usr/bin/python

import db
from helpers import py_helpers, env_constants

def get_user(user_id):
    query = "SELECT * FROM users WHERE user_id = %s LIMIT 1" % user_id
    return db.read_one(query)

def signup(email,password):
    # Check for existing user
    query = "SELECT * FROM users WHERE email = '%s' LIMIT 1" % (email, )
    existing_user = db.read_one(query)
    if existing_user:
        return None, ["This email is already registered with us. If you forgot your password, please reset it.",]

    #Okay great! Register now
    password = py_helpers.hash_password(password)
    query = "INSERT INTO users (t_create,t_update,email,password) VALUES(null,null,%s,%s)"
    new_id = db.write(query,(email,password))
    if not new_id:
        return None, [env_constants.MYSQL_WRITING_ERROR,]

    query = "SELECT user_id,email,t_create,t_update FROM users WHERE user_id = %s LIMIT 1" % new_id
    user_info = db.read_one(query)
    return user_info, None

def login(email,password):
    query = "SELECT * FROM users WHERE email = '%s' LIMIT 1" % (email)
    user_info = db.read_one(query)
    if not user_info:
        return None, ["No such user exists. Get an account now!"]
    if not py_helpers.check_password(password, user_info['password']):
        return None, ["Sorry, password doesn't match. I want to allow you! Trust me. Maybe try FORGOT PASSWORD?"]
    del user_info['password']
    return user_info, None

def create_card(data, user_id):
    # Validity of creating card
    if not user_id:
        return None, [env_constants.NOT_LOGGED_IN_ERROR,]

    if not data:
        return None, [env_constants.INVALID_REQUEST_ERROR,]

    query = "INSERT INTO cards (t_create,t_update,value,user_id) VALUES(null,null,%s,%s)"
    card_id = db.write(query,(data, user_id))
    if not card_id:
        return None, [env_constants.MYSQL_WRITING_ERROR,]

    return card_id, None

if __name__ == "__main__":
    pass
