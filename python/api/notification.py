from flask_pushjack import FlaskAPNS
import logging
import db

client = FlaskAPNS()

def init_app(app):
    client.init_app(app)

def register_device(user_id, device_id, device_type):
    if not user_id or not device_id or not device_type:
        return
    
    # Check for this device existense
    # This cannot be more than 1 user
    current_user = db.read("SELECT user_id FROM devices WHERE device_id = %s AND device_type = %s", (device_id, device_type))

    if current_user and len(current_user) > 0:
        current_user = current_user[0]

    if current_user and not current_user['user_id'] == user_id:
        # Delete the device id from the previous user
        db.write("DELETE from devices WHERE user_id = %s AND device_id = %s AND device_type = %s", (current_user['user_id'], device_id, device_type))
    elif current_user and current_user['user_id'] == user_id:
        # The current user already has regiestered for this device
        return

    db.write("INSERT INTO devices (user_id, device_id, device_type) VALUES (%s, %s, %s)", (user_id, device_id, device_type))

def unregister_device(user_id,device_id,device_type):
    db.write("DELETE from devices WHERE user_id = %s AND device_id = %s AND device_type = %s", (user_id, device_id, device_type))
        

def push_card(card_id):
    if not card_id:
        logging.error("No Card ID")
        return
    
    users = db.read("SELECT user_id FROM followers WHERE contact_id = %s", (card_id,))
    if not users:
        logging.error("No followers found for card %s" % card_id)
        return

    value = db.read_one("SELECT contact_id, value FROM cards WHERE contact_id = %s", (card_id,))
    if not value:
        logging.error("No value to push notification for")
        return;

    ios_devices = []
    android_devices = []
    for user in users:
        devices = db.read("SELECT device_id, device_type FROM devices WHERE user_id = %s", (user['user_id'],))
        for device in devices:
            device_id = devide['device_id']
            if not device_id:
                continue
            
            if device['device_type'] == "ios":
                ios_devices.append(device_id)
            elif device['device_type'] == "android":
                android_devices.append(device_id)
    
    push_ios_notifications(ios_devices, value)

def push_ios_notifications(devices, payload):
    client.send(devices, "Alert", extra=payload)

def push_android_notifications(devices, payload):
    pass

def push_notification(user_id, message):
    pass
