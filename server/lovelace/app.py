import os
from flask import Flask, request, jsonify, Blueprint, redirect
from logger import setup_logger
from account import account_page
from recommendation import recommendation_page
from chat import chat_page

logger = setup_logger("")
app = Flask(__name__)


@app.route("/")
def index():
    return redirect("https://github.com/lgf2111/lovelace")


app.register_blueprint(account_page)
app.register_blueprint(recommendation_page)
app.register_blueprint(chat_page)
host = "0.0.0.0" if os.environ.get("IN_DOCKER", False) else "localhost"
app.run(debug=True, host=host, port=3000)
