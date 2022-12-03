from flask import Flask,request,jsonify,Blueprint
from account import account_page
app = Flask(__name__)
app.register_blueprint(account_page)
app.run()