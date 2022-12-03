from flask import Flask,request,jsonify,Blueprint
from account import account_page
import os, logging

logger = logging.getLogger('werkzeug')
logger.setLevel(logging.INFO)
logger.addHandler(logging.FileHandler(f'{os.getcwd()}\\server\\lovelace\\logs\\werkzeug.log'))

app = Flask(__name__)
app.register_blueprint(account_page)
app.run()