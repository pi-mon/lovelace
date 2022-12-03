from flask import Flask,request,jsonify,Blueprint
from account import account_page
from recommendation import recommendation_page
from chat import chat_page
app = Flask(__name__)
app.register_blueprint(account_page)
app.register_blueprint(recommendation_page)
app.register_blueprint(chat_page)
app.run()