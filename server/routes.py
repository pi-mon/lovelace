from flask import Blueprint, jsonify, request
from lovelace import mongo
from pymongo import errors as db_errors
from argon2 import PasswordHasher
from lovelace.models import account
import jwt
from datetime import datetime, timedelta
from os import environ
import dotenv
from lovelace import account_logger as logger
from lovelace.account.utils import (
    token_required,
    schema,
    email_validation,
    password_validation,
)
from flask_expects_json import expects_json
from argon2 import exceptions as argon2_exceptions

dotenv.load_dotenv()
account_page = Blueprint("account", __name__, template_folder="templates")


@account_page.route("/account/create", methods=["POST"])
@expects_json(schema)
def create_account():
    ph = PasswordHasher()
    account_collection = mongo.account
    # new_username = request.form.get("username")
    account_json = request.get_json()
    new_email = account_json["email"]
    new_password = account_json["password"]
    if (
        not email_validation(new_email) or not password_validation(new_password)
    ):  # check if empty input
        logger.info(
            "%s Did not succeed in creating an account due to failed input validation",
            request.remote_addr,
        )
        return jsonify({"creation": False, "response": "Invalid email or password"})
    else:
        try:
            new_password_hash = ph.hash(new_password)
            new_user = account.User(new_email, new_password_hash)
            new_user_json = new_user.__dict__
            account_collection.user.create_index("email", unique=True)
            account_collection.user.insert_one(new_user_json)
            logger.info(
                "%s Succeed in creating an account using email %s",
                request.remote_addr,
                new_email,
            )
            return jsonify(
                {"creation": True, "response": "Account was created successfully"}
            )
        except db_errors.DuplicateKeyError:
            logger.info(
                "%s Did not succeed in creating an account due to duplicated email %s",
                request.remote_addr,
                new_email,
            )
            return jsonify({"creation": False, "response": "Email already exist"})

        except argon2_exceptions.VerifyMismatchError:
            logger.info(
                "%s Did not succeed in creating an account due to argon2 exceptions mismatch",
                request.remote_addr,
            )
            return jsonify({"login": False, "response": "Invalid email or password"})


@account_page.route("/account/login", methods=["POST", "GET"])
@expects_json(schema)
def login_account():
    ph = PasswordHasher()
    account_json = request.get_json()
    email = account_json["email"]
    password = account_json["password"]
    # if (
    #     not email_validation(email)
    #     or not password_validation(password)
    # ):  # check if empty input
    #     account_collection = mongo.account
    #     logger.info(
    #         "%s Failed to login using email %s due to failed input validation",
    #         request.remote_addr,
    #         email,
    #     )
    #     return jsonify({"login": False, "response": "Invalid email or password"})
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
            logger.info("%s Failed to login using email %s", request.remote_addr, email)
            return jsonify({"login": False, "response": "Invalid email or password"})
            
    except argon2_exceptions.VerifyMismatchError:
            logger.info(
                "%s Did not succeed in creating an account due to argon2 exceptions mismatch",
                request.remote_addr,
            )
            return jsonify({"login": False, "response": "Invalid email or password"})
    if valid_login:
        token = jwt.encode(
            {"email": email,
            "request ip":request.remote_addr,
            "exp": datetime.utcnow() + timedelta(minutes=2)
            },
            environ.get("APPLICATION_SIGNATURE_KEY"),
            algorithm="HS256",
        )
        # resp = make_response(jsonify({"login":True,"response":"User login successful"}))
        # resp.set_cookie("token", token)
        logger.info(
            "%s Logged in successfully using email %s", request.remote_addr, email
        )
        return jsonify(
            {"login": True, "response": "User login successful", "token": token}
        )


@account_page.route("/account/test")
@token_required
def test(username):
    return username
