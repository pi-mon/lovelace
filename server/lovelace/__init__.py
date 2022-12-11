from flask import Flask
import pymongo
import certifi
import os

from lovelace.logger import setup_logger

ca = certifi.where()
mongo = pymongo.MongoClient(host=os.environ.get("MONGO_URI"), tlsCAFile=ca)


root_logger = setup_logger("")
account_logger = setup_logger("account")
chat_logger = setup_logger("chat")
logs_logger = setup_logger("logs")
recommendation_logger = setup_logger("recommendation")


def create_app():
    app = Flask(__name__)

    from lovelace.account.routes import account_page
    from lovelace.recommendation.routes import recommendation
    from lovelace.chat.routes import chat
    from lovelace.logger.routes import logs

    app.register_blueprint(account_page)
    app.register_blueprint(recommendation)
    app.register_blueprint(chat)
    app.register_blueprint(logs)

    return app
