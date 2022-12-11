from flask import Blueprint, request
from lovelace import chat_logger as logger

chat = Blueprint("chat", __name__, template_folder="templates")


@chat.route("/chat/<user>")
def get_chat(user):
    target_user = user
    # current_user = "user" #jwt token
    logger.info("%s Accessed chat with User %s", request.remote_addr, str(user))
    return "talking to " + user
