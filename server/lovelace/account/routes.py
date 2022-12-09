from flask import Blueprint, jsonify, request, make_response
from lovelace.db import mongo
from pymongo import errors as db_errors
from argon2 import PasswordHasher
from lovelace.models import account_model
import jwt
from datetime import datetime, timedelta
from os import environ
from lovelace.logger import setup_logger
from lovelace.account.utils import token_required

logger = setup_logger(__name__)
account_page = Blueprint("account_page", __name__, template_folder="templates")

@account_page.route("/account/create", methods=["POST"])
def create_account():
    ph = PasswordHasher()
    account_collection = mongo.account
    # new_username = request.form.get("username")
    account_json = request.get_json()
    new_email = account_json["email"]
    new_password = account_json["password"]
    if not new_email or not new_password:  # check if empty input
        return jsonify({"creation": False, "response": "Invalid email or password"})
    else:
        try:
            new_password_hash = ph.hash(new_password)
            new_user = account_model.User(new_email, new_password_hash)
            new_user_json = new_user.__dict__
            account_collection.user.create_index("email", unique=True)
            account_collection.user.insert_one(new_user_json)
            return jsonify(
                {"creation": True, "response": "Account was created successfully"}
            )
        except db_errors.DuplicateKeyError:
            return jsonify({"creation": False, "response": "Email already exist"})


@account_page.route("/account/login", methods=["POST", "GET"])
def login_account():
    ph = PasswordHasher()
    account_json = request.get_json()
    email = account_json["email"]
    password = account_json["password"]
    if not email or not password:  # check if empty input
        account_collection = mongo.account
        return jsonify({"login": False, "response": "Invalid email or password"})
    account_collection = mongo.account
    try:
        valid_login = ph.verify(
            account_collection.user.find_one({"email": email}, {"password": 1})[
                "password"
            ],
            password,
        )  # compares password hash
    except TypeError:
        if account_collection.user.find_one({"email": email}, {"password": 1}) == None:
            return jsonify({"login": False, "response": "Invalid email or password"})
    if valid_login:
        token = jwt.encode(
            {"email": email, "exp": datetime.utcnow() + timedelta(minutes=30)},
            environ.get("APPLICATION_SIGNATURE_KEY"),
            algorithm="HS256",
        )
        # resp = make_response(jsonify({"login":True,"response":"User login successful"}))
        # resp.set_cookie("token", token)
        return jsonify(
            {"login": True, "response": "User login successful", "token": token}
        )


@account_page.route("/account/test")
@token_required
def test(username):
    return username