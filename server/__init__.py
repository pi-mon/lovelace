from flask import Flask
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
import pymongo
import certifi
import os

from lovelace.logger import setup_logger
import dotenv
dotenv.load_dotenv()

ca = certifi.where()
mongo = pymongo.MongoClient(host=os.environ.get("MONGO_URI"), tlsCAFile=ca)


root_logger = setup_logger("")
account_logger = setup_logger("account")
chat_logger = setup_logger("chat")
logs_logger = setup_logger("logs")
recommendation_logger = setup_logger("recommendation")


def create_app():
    app = Flask(__name__)
    limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=["200 per day", "50 per hour"]
    )

    from lovelace.account.routes import account_page
    from lovelace.recommendation.routes import recommendation
    from lovelace.chat.routes import chat
    from lovelace.logger.routes import logs

    app.register_blueprint(account_page)
    app.register_blueprint(recommendation)
    app.register_blueprint(chat)
    app.register_blueprint(logs)

    return app
