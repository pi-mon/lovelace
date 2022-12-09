from flask import Flask, request, jsonify, Blueprint
from lovelace.logger import setup_logger
from lovelace.account.routes import account_page
from lovelace.recommendation.routes import recommendation_page
from lovelace.chat.routes import chat_page
from lovelace.logs.routes import logs

logger = setup_logger("")
app = Flask(__name__)
app.register_blueprint(account_page)
app.register_blueprint(recommendation_page)
app.register_blueprint(chat_page)
app.register_blueprint(logs)
