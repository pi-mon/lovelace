from flask import Flask, request, jsonify, Blueprint
from account import account_page
import os, logging

logger = logging.getLogger("werkzeug")
logger.setLevel(logging.INFO)
logger.addHandler(
    logging.FileHandler(f"{os.getcwd()}\\server\\lovelace\\logs\\werkzeug.log")
)
stream_handler = logging.StreamHandler()
stream_handler.setLevel(logging.INFO)
logger.addHandler(stream_handler)

from recommendation import recommendation_page
from chat import chat_page

app = Flask(__name__)
app.register_blueprint(account_page)
app.register_blueprint(recommendation_page)
app.register_blueprint(chat_page)
app.run(debug=True)
