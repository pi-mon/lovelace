from flask import Blueprint, jsonify, request
from db import mongo
from logger import setup_logger

logger = setup_logger(__name__)
chat_page = Blueprint("chat_page", __name__, template_folder="templates")


@chat_page.route("/chat/<user>")
def chat(user):
    target_user = user
    # current_user = "user" #jwt token
    logger.info("%s Accessed chat with User %s", request.remote_addr, str(user))
    return "talking to " + user
