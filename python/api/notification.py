import logging
import db
from pushjack import APNSClient, APNSSandboxClient

ios_client = APNSSandboxClient(certificate='prodcert.pem',
                        default_error_timeout=10,
                        default_expiration_offset=2592000,
                        default_batch_size=100)

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

def send_update(user_ids, message, payload={}):
    print("Sending update: ")
    ios_devices = []
    android_devices = []
    for user_id in user_ids:
        devices = db.read("SELECT device_id, device_type FROM devices WHERE user_id = %s",(user_id,))
        print devices
        for device in devices:
            if device['device_type'] == "ios":
                ios_devices.append(device['device_id'])
            elif device['device_type'] == "android":
                android_devices.append(device['device_id'])
    print("Sending update: ios devices: " % ios_devices)
    push_ios_notifications(ios_devices, message, payload=payload)
    push_android_notifications(android_devices, message)

def push_ios_notifications(devices, message, payload={}):
    options = {
        'badge': 1,
        'title': 'Contact Card Update',
        'extra': payload
    }
    print("Sending update message - " + message + " to devices " + str(devices) + "with options " + str(options))
    res = ios_client.send(devices, message, **options)
    ios_client.close()
    print(res.errors)

def push_android_notifications(devices, message, payload={}):
    pass

def push_notification(user_id, message):
    pass
