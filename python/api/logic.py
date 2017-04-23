#!/usr/bin/python

import db, notification
from helpers import py_helpers, env_constants
import logging

def get_user(user_id):
    query = "SELECT * FROM users WHERE user_id = '%s' LIMIT 1"
    return db.read_one(query, (user_id,))

def signup(email,password):
    # Check for existing user
    query = "SELECT * FROM users WHERE email = '%s' LIMIT 1"
    existing_user = db.read_one(query,(email,))
    if existing_user:
        return None, ["This email is already registered with us. If you forgot your password, please reset it.",]

    #Okay great! Register now
    password = py_helpers.hash_password(password)
    query = "INSERT INTO users (t_create,t_update,email,password) VALUES(null,null,%s,%s)"
    new_id = db.write(query,(email,password))
    if not new_id:
        return None, [env_constants.MYSQL_WRITING_ERROR,]

    query = "SELECT user_id,email,t_create,t_update FROM users WHERE user_id = '%s' LIMIT 1"
    user_info = db.read_one(query,(new_id,))
    return user_info, None

def login(email, password):
    query = "SELECT * FROM users WHERE email = %s LIMIT 1"
    user_info = db.read_one(query,(email,))
    if not user_info:
        return None, ["No such user exists. Get an account now!"]
    if not py_helpers.check_password(password, user_info['password']):
        return None, ["Sorry, password doesn't match. I want to allow you! Trust me. Maybe try FORGOT PASSWORD?"]
    del user_info['password']
    return user_info, None

def notify_update(user_ids, message):
    if not user_ids or not message:
        return False, "Invalid params"
    notification.send_update(user_ids, message)
    return True, None

def register_device(user_id,device_id,device_type):
    if not user_id or not device_id or not device_type:
        return False, "Expected params cannot be empty"
    notification.register_device(user_id, device_id, device_type)
    return True, None

def unregister_device(user_id,device_id,device_type):
    notification.unregister_device(user_id,device_id,device_type)
    return True, None

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

def get_cards(user_id):
    if not user_id:
        return None, [env_constants.NOT_LOGGED_IN_ERROR,]

    query = "SELECT contact_id, t_create, t_update, value, user_id FROM cards WHERE user_id = %s"
    cards = db.read(query, (user_id,))
    if not cards:
        return None, [env_constants.MYSQL_WRITING_ERROR,]
    # Encoding value
    # cards['value'] = cards['value'].encode('utf-8')
    return cards, None

def edit_card(card_id, data, user_id):
    # Validity for updating the card
    if not user_id:
        return None, [env_constants.NOT_LOGGED_IN_ERROR,]
    
    if not data:
        return None, [env_constants.INVALID_REQUEST_ERROR,]

    query = "SELECT contact_id, user_id FROM cards WHERE contact_id = %s"
    cards = db.read(query, (card_id,))
    if not cards:
        return None, ["No such card exists",]

    if cards[0]['user_id'] != user_id:
        return None, ["Denied permission for editing this card",]

    query = "UPDATE cards SET value = %s WHERE contact_id = %s"
    db.write(query, (data.encode(encoding='UTF-8', errors='ignore'), card_id))
    
    return card_id, None

def contact_updates(contact_ids, user_id):
    if not user_id:
        return None, [env_constants.NOT_LOGGED_IN_ERROR,]

    if not contact_ids:
        return None, [env_constants.INVALID_REQUEST_ERROR,]

    query = "SELECT contact_id, value, user_id FROM cards WHERE contact_id IN (%s)"
    print(contact_ids)
    contact_info = db.read(query, tuple(contact_ids))

    return_info = {}
    
    for info in contact_info:
        if info['value']:
            add_card_follower(user_id, info['contact_id'])
            return_info[info['contact_id']] = info
    
    return return_info, None
            

def add_card_follower(user_id, contact_id):
    if not user_id or not contact_id:
        #ignore
        return
    query = "SELECT contact_id, user_id FROM followers WHERE contact_id = %s AND user_id = %s"
    
    # Checking if the table does not contain this relationship
    if not db.read(query, (contact_id, user_id)):
        query = "INSERT INTO followers (contact_id, user_id) VALUES (%s, %s)"
        follower_info = db.write(query, (contact_id, user_id))
        logging.info("Follower user %s added for card %s", user_id, contact_id)
    return

if __name__ == "__main__":
    pass
