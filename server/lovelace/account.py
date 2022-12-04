from flask import Blueprint, jsonify, request
from db import mongo
from log import setup_custom_logger

logger = setup_custom_logger(__name__)

account_page = Blueprint('account_page', __name__,
                        template_folder='templates')
@account_page.route("/account/create")
def create_account():
  collection = mongo.users
  collection.users.insert_one({'name':"test123334344"})
  new_username = request.form.get("username")
  new_password = request.form.get("password")
  if not new_username or not new_password:
    logger.info('%s Invalid username or password', request.remote_addr)
    return(jsonify({"creation":False,"response":"Invalid username or password"}))
  else:
    logger.info('%s Created %s User', request.remote_addr, new_username)
    return("Valid username")