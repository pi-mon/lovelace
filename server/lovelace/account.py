from flask import Blueprint, jsonify, request
from db import mongo
account_page = Blueprint('account_page', __name__,
                        template_folder='templates')
@account_page.route("/account/create")
def create_account():
  collection = mongo.users
  collection.users.insert_one({'name':"test123334344"})
  new_username = request.form.get("username")
  new_password = request.form.get("password")
  if not new_username or not new_password:
    return(jsonify({"creation":False,"response":"Invalid username or password"}))
  else:
    return("Valid username")