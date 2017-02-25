#!/usr/bin/python

from helpers import env_constants
from flask import Flask, request, jsonify
from api import api
from settings import settings

import traceback
import logging

app = Flask(__name__, static_folder="template")
# Checking for log file directory
log_dir = '/var/log/py_server/'
log_path = log_dir + 'app.log'
try:
    import os, errno
    os.makedirs(log_dir)
except Exception, e:
    pass

logging.basicConfig(filename=log_path,level=logging.DEBUG)
logging.info('''
**************************************************************
*                        SERVER START                        *
**************************************************************
''')

app.secret_key = "LetsTestThisServer"

if not app.secret_key:
    print "YOUR SECRET KEY IS EMPTY. SECURITY !!! BAD !!!"
    logging.info('Empty Secret Key. Potential Security leak')

@app.route('/')
def index():
    return app.send_static_file('index.html')

@app.route('/api/card', methods=['GET', 'POST', 'PUT', 'DELETE'])
def call_api():
    try:
        print("API Called: Card with method - " + request.method)
        if request.method == 'PUT':
            return jsonify(api.create_card())
    except Exception,e:
        print(e)
    return jsonify({'success': False, 'error': 'An internal error occured'})

@app.route('/api/<api_func>', methods=['GET', 'POST', 'PUT'])
def api_call(api_func):
    print("APIs Called: " + api_func)
    if not api_func:
        response = {'success':False, 'error':'No such api call exists'}
        return jsonify(**response)
    try:
        try:
            func = getattr(api, str(api_func))
        except AttributeError:
            response = {'success':False, 'error':env_constants.NO_SUCH_API_ERROR}
        else:
            response = func()
        if not response:
            response = {'success':True, 'no_return': True}
        
        if type(response) == type(dict()):
            return jsonify(**response)
        else:
            return response
    except Exception,e:
        return traceback.print_exc()        

@app.errorhandler(404)
def page_not_found(error):
    return jsonify({'success':False, 'error':'No such api call exists'})

@app.errorhandler(500)
def internal_error(error):
    return error

if __name__ == "__main__":
    app.run('0.0.0.0', 8080, debug=True)
