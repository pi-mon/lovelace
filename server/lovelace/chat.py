from flask import Blueprint, jsonify, request
from db import mongo
chat_page = Blueprint('chat_page', __name__,
                        template_folder='templates')

@chat_page.route("/chat/<user>")
def chat(user):
  target_user = user
  #current_user = "user" #jwt token
  return("talking to "+user)