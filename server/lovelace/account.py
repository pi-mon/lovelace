from flask import Blueprint, jsonify, request,make_response
from db import mongo
from pymongo import errors as db_errors
from argon2 import PasswordHasher
from models import account_model
from functools import wraps
import jwt
from datetime import datetime, timedelta
from dotenv import load_dotenv
from os import environ
from log import setup_custom_logger
load_dotenv()


logger = setup_custom_logger(__name__)

account_page = Blueprint('account_page', __name__,
                        template_folder='templates')

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        # jwt is passed in the form of a cookie
        if request.cookies.get("token") != False:
            token = request.cookies.get("token")
        # return 401 if token is not passed
        if not token:
            return jsonify({'message' : 'Token is missing !!'}), 401
  
        try:
            # decoding the payload to fetch the stored details
            account_collection = mongo.account
            data = jwt.decode(token,environ.get("APPLICATION_SIGNATURE_KEY"),algorithms="HS256")
            print(data)
            current_user = account_collection.user.find_one(data["username"])
        except:
            return jsonify({
                'message' : 'Token is invalid !!'
            }), 401
        # returns the current logged in users contex to the routes
        return  f(current_user, *args, **kwargs)
  
    return decorated
@account_page.route("/account/create",methods = ["POST"])
def create_account():
  ph = PasswordHasher()
  account_collection = mongo.account
  #new_username = request.form.get("username")
  account_json = request.get_json()
  new_email = account_json["email"]
  new_password = account_json["password"]
  if not new_email or not new_password: #check if empty input
    return(jsonify({"creation":False,"response":"Invalid email or password"}))
  else:
    try:
      new_password_hash = ph.hash(new_password)
      new_user = account_model.User(new_email,new_password_hash)
      new_user_json = new_user.__dict__
      account_collection.user.create_index("email",unique=True)
      account_collection.user.insert_one(new_user_json)
      return(jsonify({"creation":True,"response":"Account was created successfully"}))
    except db_errors.DuplicateKeyError:
      return(jsonify({"creation":False,"response":"Email already exist"}))

@account_page.route("/account/login",methods=["POST","GET"])
def login_account():
  ph = PasswordHasher()
  account_json = request.get_json()
  email = account_json["email"]
  password = account_json["password"]
  if not email or not password: #check if empty input
    account_collection = mongo.account
    return(jsonify({"login":False,"response":"Invalid email or password"}))
  account_collection = mongo.account
  valid_login = ph.verify(account_collection.user.find_one({"email":email})["password"],password) #compares password hash
  if valid_login:
    token = jwt.encode({
            'email': email,
            'exp' : datetime.utcnow() + timedelta(minutes = 30)
        }, environ.get("APPLICATION_SIGNATURE_KEY"),algorithm="HS256")
    resp = make_response(jsonify({"login":True,"response":"User login successful"}))
    resp.set_cookie("token", token)
    return(resp)
    
@account_page.route("/account/test")
@token_required
def test(username):
  return(username)
  
