from flask import Flask
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_socketio import SocketIO
import pymongo
import certifi
import os
from lovelace.logger import setup_logger
import dotenv
dotenv.load_dotenv()
ca = certifi.where()
mongo = pymongo.MongoClient(host=os.environ.get("MONGO_URI"), tlsCAFile=ca)
mongo_account_read = pymongo.MongoClient(host=os.environ.get("MONGO_URI_ACCOUNT_READ"), tlsCAFile=ca)
mongo_account_write = pymongo.MongoClient(host=os.environ.get("MONGO_URI_ACCOUNT_WRITE"), tlsCAFile=ca)
mongo_admin_read = pymongo.MongoClient(host=os.environ.get("MONGO_URI_ADMIN_READ"), tlsCAFile=ca)
mongo_account_details_write = pymongo.MongoClient(host=os.environ.get("MONGO_URI_ACCOUNT_DETAILS_WRITE"), tlsCAFile=ca)
mongo_temp_write = pymongo.MongoClient(host=os.environ.get("MONGO_URI_TEMP_USER_WRITE"), tlsCAFile=ca)
mongo_temp_read = pymongo.MongoClient(host=os.environ.get("MONGO_URI_TEMP_USER_READ"), tlsCAFile=ca)

root_logger = setup_logger("")
account_logger = setup_logger("account")
chat_logger = setup_logger("chat")
logs_logger = setup_logger("logs")
recommendation_logger = setup_logger("recommendation")


app = Flask(__name__)
app.config.from_pyfile('config.py')
limiter = Limiter(
app,
key_func=get_remote_address,
default_limits=["50 per minute"]
)
socketio = SocketIO(app, cors_allowed_origins='*')

from lovelace.account.routes import account_page
from lovelace.recommendation.routes import recommendation
from lovelace.chat.routes import chat
from lovelace.logger.routes import logs
from lovelace.admin.routes import admin_page

app.register_blueprint(account_page)
app.register_blueprint(recommendation)
app.register_blueprint(chat)
app.register_blueprint(logs)
app.register_blueprint(admin_page)
