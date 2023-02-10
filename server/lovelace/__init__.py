from flask import Flask, request
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_socketio import SocketIO
import pymongo
import certifi
import os
from lovelace.logger import setup_logger
import dotenv
from prometheus_flask_exporter import PrometheusMetrics
from flask_httpauth import HTTPBasicAuth
import flask_monitoringdashboard as dashboard
from flask_talisman import Talisman
from flask_wtf.csrf import CSRFProtect

dotenv.load_dotenv()
ca = certifi.where()
mongo = pymongo.MongoClient(host=os.environ.get("MONGO_URI"), tlsCAFile=ca)
mongo_account_read = pymongo.MongoClient(
    host=os.environ.get("MONGO_URI_ACCOUNT_READ"), tlsCAFile=ca
)
mongo_account_write = pymongo.MongoClient(
    host=os.environ.get("MONGO_URI_ACCOUNT_WRITE"), tlsCAFile=ca
)
mongo_admin_read = pymongo.MongoClient(
    host=os.environ.get("MONGO_URI_ADMIN_READ"), tlsCAFile=ca
)
mongo_account_details_write = pymongo.MongoClient(
    host=os.environ.get("MONGO_URI_ACCOUNT_DETAILS_WRITE"), tlsCAFile=ca
)
mongo_temp_write = pymongo.MongoClient(
    host=os.environ.get("MONGO_URI_TEMP_USER_WRITE"), tlsCAFile=ca
)
mongo_temp_read = pymongo.MongoClient(
    host=os.environ.get("MONGO_URI_TEMP_USER_READ"), tlsCAFile=ca
)
mongo_chat_write = pymongo.MongoClient(
    host=os.environ.get("MONGO_URI_CHAT_WRITE"), tlsCAFile=ca
)
mongo_chat_request_write = pymongo.MongoClient(
    host=os.environ.get("MONGO_URI_USER_CHAT_REQUEST_WRITE"), tlsCAFile=ca
)
mongo_chat_request_read = pymongo.MongoClient(
    host=os.environ.get("MONGO_URI_USER_CHAT_REQUEST_READ"), tlsCAFile=ca
)

root_logger = setup_logger("")
account_logger = setup_logger("account")
chat_logger = setup_logger("chat")
logs_logger = setup_logger("logs")
recommendation_logger = setup_logger("recommendation")


app = Flask(__name__)
app.config["WTF_CSRF_SECRET_KEY"] = os.environ.get("APPLICATION_SIGNATURE_KEY")
Talisman(app,force_https=False)

#csrf = CSRFProtect(app)
auth = HTTPBasicAuth(app)
metrics = PrometheusMetrics(app, metrics_decorator=auth.login_required)
metrics.register_default(
    metrics.counter(
        "by_path_counter",
        "Request count by request paths",
        labels={"path": lambda: request.path},
    )
)
#csrf.init_app(app)


@auth.verify_password
def verify_credentials(username, password):
    return (username, password) == (
        os.environ.get("METRICS_USERNAME"),
        os.environ.get("METRICS_PASSWORD"),
    )


app.config.from_pyfile("config.py")

dashboard.config.init_from(file="monitor/config.cfg")
dashboard.bind(app)

limiter = Limiter(get_remote_address, app=app, default_limits=["10 per minute"])
socketio = SocketIO(
    app,
    cors_allowed_origins=[
        "ec2-13-229-224-40.ap-southeast-1.compute.amazonaws.com",
    ],
)

from lovelace.account.routes import account_page
from lovelace.recommendation.routes import recommendation
from lovelace.chat.routes import chat
from lovelace.logger.routes import logs
from lovelace.admin.routes import admin

app.register_blueprint(account_page)
app.register_blueprint(recommendation)
app.register_blueprint(chat)
app.register_blueprint(logs)
app.register_blueprint(admin)
