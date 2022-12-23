from flask import Blueprint, jsonify, request
from lovelace import mongo_account_read,mongo_account_write,mongo_account_details_write
from flask import current_app as app
from flask_mail import Message,Mail
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
    encrypted_token_required,
    schema,
    email_validation,
    password_validation,
)
import jwcrypto
from flask_expects_json import expects_json
from argon2 import exceptions as argon2_exceptions

dotenv.load_dotenv()
account_page = Blueprint("account", __name__, template_folder="templates")


@account_page.route("/account/create", methods=["POST"])
@expects_json(schema)
def create_account():
    ph = PasswordHasher()
    account_collection = mongo_account_write.account
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

        except db_errors.OperationFailure:
            logger.info("%s Failed database operation %s", request.remote_addr)
            return jsonify({"login": False, "response": "Failed database operation"})


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
    account_collection = mongo_account_read.account
    try:
        valid_login = ph.verify(
            account_collection.user.find_one({"email": email}, {"password": 1})[
                "password"
            ],
            password,
        )  # compares password hash
        #account_collection.user.create_index("email", unique=True) #test code for database isolation
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

    except db_errors.OperationFailure:
        logger.info("%s Invalid database operation %s", request.remote_addr, email)
        return jsonify({"login": False, "response": "Disallowed database operation"})
    if valid_login:
        token = jwt.encode(
            {"email": email,
            "request ip":request.remote_addr,
            "exp": datetime.utcnow() + timedelta(minutes=30)
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

@account_page.route("/account/update_profile")
@token_required #user is email registered
def create_profile(user):
    profile_information = request.get_json()
    user_detail_collection = mongo_account_details_write.account_details
    new_account_details = account.UserDetails(user,profile_information["username"],profile_information["age"],profile_information["location"])
    if user_detail_collection.account_details.find_one({"email": user},{"email": 1}) == None: #check if need to update profile or create new profile
        user_detail_collection.account_details.insert_one(new_account_details.__dict__)
        return(jsonify({"create":True,"response":"User account details has been created"}))
    else:
        user_detail_collection.account_details.update_one({})
        return(jsonify({"create":False,"response":"User details has already been created"}))
    
@account_page.route("/account/profile")
@token_required
def test(user):
    user_detail_collection = mongo_account_details_write.account_details
    account_details = user_detail_collection.account_details.find_one({"email": user})
    account_details["_id"] = str(account_details["_id"])
    return(jsonify(account_details))

@account_page.route("/account/email")
def test_email():
    mail = Mail(app)
    msg = Message('Hello from the other side!', sender =   'lovelace.dating@gmail.com', recipients = ['joel.lim04@gmail.com'])
    msg.body = "Hey Paul, sending you this email from my Flask app, lmk if it works"
    mail.send(msg)
    return "Message sent!"
