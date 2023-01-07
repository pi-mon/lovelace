from flask import Blueprint, jsonify, request
from lovelace import (
    mongo_account_read,
    mongo_account_write,
    mongo_account_details_write,
    mongo_temp_write,
    mongo_temp_read,
)
from flask import current_app as app
from flask_mail import Message, Mail
from pymongo import errors as db_errors
from argon2 import PasswordHasher
from lovelace.models import account
import jwt
from datetime import datetime, timedelta
from os import environ
from pyotp import TOTP
from lovelace import account_logger as logger
from lovelace.account.utils import (
    token_required,
    schema,
    email_validation,
    password_validation,
)
from flask_expects_json import expects_json
from argon2 import exceptions as argon2_exceptions

account_page = Blueprint("account", __name__, template_folder="templates")


@account_page.route("/account/create", methods=["POST"])
@expects_json(schema)
def create_account():
    try:
        ph = PasswordHasher()
        account_collection = mongo_account_read.account
        temp_collection = mongo_temp_write.account
        # new_username = request.form.get("username")
        account_json = request.get_json()
        new_display_name = account_json["displayName"]
        new_email = account_json["email"]
        new_password = account_json["password"]
    except KeyError:
        return jsonify(
            {"login": False, "response": "User login failed due to invalid input"}
        )
    if not email_validation(new_email) or not password_validation(
        new_password
    ):  # check if empty input
        logger.info(
            "%s Did not succeed in creating an account due to failed input validation",
            request.remote_addr,
        )
        return jsonify({"creation": False, "response": "Invalid email or password"})
    else:
        try:
            if account_collection.user.find_one({"email": new_email}) != None:
                logger.info(
                    "%s Did not succeed in creating an account due to duplicated email %s",
                    request.remote_addr,
                    new_email,
                )
                return jsonify({"creation": False, "response": "Email already exist"})
            new_password_hash = ph.hash(new_password)
            new_user = account.User(
                display_name=new_display_name,
                email=new_email,
                password=new_password_hash,
            )
            new_user_json = new_user.__dict__
            new_user_json["createdAt"] = datetime.utcnow()
            # temp_collection.temp_user.create_index("email", unique=True) #makes email unique
            # temp_collection.temp_user.create_index("createdAt",expireAfterSeconds=5*60) #adds to database for 5 minutes before deleting
            token = jwt.encode(
                {
                    "email": new_email,
                    "request ip": request.remote_addr,
                    "authenticated": False,
                    "exp": datetime.utcnow() + timedelta(minutes=5),
                },
                environ.get("APPLICATION_SIGNATURE_KEY"),
                algorithm="HS256",
            )
            mail = Mail(app)
            msg = Message(
                "OTP for lovelace",
                sender="lovelace.dating@gmail.com",
                recipients=[new_email],
            )  # include email later
            totp = TOTP("base32secret3232")
            otp = totp.now()
            otp_expiry = datetime.utcnow() + timedelta(minutes=5)
            new_user_json["otp"] = otp
            new_user_json["otp_expiry"] = otp_expiry
            try:
                temp_collection.temp_user.insert_one(new_user_json)
            except db_errors.DuplicateKeyError:
                del new_user_json["email"]
                del new_user_json["_id"]
                new_values = {"$set": new_user_json}
                temp_collection.temp_user.update_one(
                    {"email": new_email}, update=new_values
                )
            except db_errors.OperationFailure:
                logger.info("%s Failed database operation %s", request.remote_addr)
                return jsonify(
                    {"login": False, "response": "Failed database operation"}
                )
            msg.body = f"Your otp is {otp}. This otp will expire within 5 minutes. Please do not share this otp"
            mail.send(msg)
            logger.info(
                "%s Succeed in creating a Temp account using email %s",
                request.remote_addr,
                new_email,
            )
            output = jsonify(
                {
                    "creation": True,
                    "response": "Temp account was created successfully, please check mailbox for email verification.",
                }
            )
            output.set_cookie("token", token)
            return output
        # except db_errors.DuplicateKeyError:
        #     logger.info(
        #         "%s Did not succeed in creating an account due to duplicated email %s",
        #         request.remote_addr,
        #         new_email,
        #     )
        #     return jsonify({"creation": False, "response": "Email already exist"})

        except db_errors.OperationFailure:
            logger.info("%s Failed database operation %s", request.remote_addr)
            return jsonify({"login": False, "response": "Failed database operation"})


@account_page.route("/account/create/verify", methods=["POST"])
@token_required(need_authenticated=False, database=mongo_temp_write.account.temp_user)
def create_verify(user):
    try:
        temp_collection = mongo_temp_read.account
        user_details = temp_collection.temp_user.find_one({"email": user})
        otp_expiry = user_details["otp_expiry"]
        otp = str(request.get_json()["otp"])
    except db_errors.OperationFailure:
        return jsonify({"create": False, "response": "Invalid database operation"})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify(
            {"create": False, "response": "User login failed due to invalid input"}
        )
    try:
        if otp_expiry > datetime.utcnow() and user_details["otp"] == otp:
            account_collection = mongo_account_write.account
            new_user = account.User(user_details["email"], user_details["password"])
            new_user_json = new_user.__dict__
            account_collection.user.insert_one(new_user_json)
            return jsonify(
                {"create": True, "response": "Account was created successfully"}
            )
    except db_errors.OperationFailure:
        return jsonify({"create": False, "response": "Invalid database operation"})
    except:
        return jsonify({"create": False, "response": "Account creation has an error"})
    return jsonify({"create": False, "response": "Expired or Invalid OTP was entered"})
    #     if otp_expiry > datetime.utcnow() and user_details["otp"] == otp:
    #         account_collection = mongo_account_write.account
    #         new_user = account.User(
    #             display_name=user_details["display_name"],
    #             email=user_details["email"],
    #             password=user_details["password"],
    #         )
    #         new_user_json = new_user.__dict__
    #         account_collection.user.insert_one(new_user_json)
    # except db_errors.OperationFailure:
    #     return jsonify({"create": False, "response": "Invalid database operation"})
    # except Exception as e:
    #     print(f"Error: {e}")
    #     return jsonify({"create": False, "response": "Account creation has an error"})
    # return jsonify({"create": True, "response": "Account was created successfully"})


@account_page.route("/account/login", methods=["POST", "GET"])
@expects_json(schema)
def login_account():
    try:
        ph = PasswordHasher()
        account_json = request.get_json()
        email = account_json["email"]
        password = account_json["password"]
    except KeyError:
        return jsonify(
            {"login": False, "response": "User login failed due to invalid input"}
        )
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
        # account_collection.user.create_index("email", unique=True) #test code for database isolation
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
            {
                "email": email,
                "request ip": request.remote_addr,
                "authenticated": False,
                "exp": datetime.utcnow() + timedelta(minutes=5),
            },
            environ.get("APPLICATION_SIGNATURE_KEY"),
            algorithm="HS256",
        )
        mail = Mail(app)
        msg = Message(
            "OTP for lovelace", sender="lovelace.dating@gmail.com", recipients=[email]
        )
        totp = TOTP("base32secret3232")
        otp = totp.now()
        otp_expiry = datetime.utcnow() + timedelta(minutes=5)
        account_collection_write = mongo_account_write.account
        new_values = {"$set": {"otp": otp, "otp_expiry": otp_expiry}}
        account_collection_write.user.update_one({"email": email}, update=new_values)
        msg.body = f"Your otp is {otp}. This otp will expire within 5 minutes. Please do not share this otp"
        mail.send(msg)
        # resp = make_response(jsonify({"login":True,"response":"User login successful"}))
        # resp.set_cookie("token", token)
        logger.info(
            "%s Logged in successfully using email, otp required to login %s",
            request.remote_addr,
            email,
        )
        output = jsonify(
            {
                "login": True,
                "response": "User login successful, otp required to login",
            }
        )
        output.set_cookie("token", token)
        return output


@account_page.route("/account/login/verify", methods=["POST", "GET"])
@token_required(need_authenticated=False)
def login_verify(user):
    try:
        account_collection = mongo_account_read.account
        otp_details = account_collection.user.find_one(
            {"email": user}, {"otp": 1, "otp_expiry": 1}
        )
        otp_expiry = otp_details["otp_expiry"]
        otp = str(request.get_json()["otp"])
    except:
        return jsonify(
            {"login": False, "response": "User login failed due to invalid input"}
        )
    if (
        otp_expiry > datetime.utcnow() and otp_details["otp"] == otp
    ):  # checks if otp has expired
        token = jwt.encode(
            {
                "email": user,
                "request ip": request.remote_addr,
                "authenticated": True,
                "exp": datetime.utcnow() + timedelta(minutes=30),
            },
            environ.get("APPLICATION_SIGNATURE_KEY"),
            algorithm="HS256",
        )
        logger.info(
            "%s Logged in successfully with 2fa using email %s",
            request.remote_addr,
            user,
        )
        output = jsonify({"login": True, "response": "Login verify successful"})
        output.set_cookie("token", token)
        return output
    else:
        return jsonify({"login": False, "response": "Invalid or expired otp"})


@account_page.route("/account/profile/update")
@token_required()  # user is email registered
def update_profile(user):
    try:
        profile_information = request.get_json()
        user_detail_collection = mongo_account_details_write.account_details
        new_account_details = account.UserDetails(
            user,
            profile_information["display_name"],
            profile_information["age"],
            profile_information["gender"],
            profile_information["location"],
        )
    except:
        return jsonify({"create": False, "response": "Invalid user input"})
    if (
        user_detail_collection.account_details.find_one({"email": user}, {"email": 1})
        == None
    ):  # check if need to update profilwwwwwe or create new profile
        #         output = jsonify({"login": True, "response": "User login successful"})
        #         output.set_cookie("token", token)
        #         return output
        #     return jsonify({"login": False, "response": "Invalid or expired otp"})

        # @account_page.route("/account/profile/update")
        # @token_required()  # user is email registered
        # def update_profile(user_email):
        #     profile_information = request.get_json()
        #     user_detail_collection = mongo_account_details_write.account_details
        #     new_account_details = account.UserDetails(
        #         user_email,
        #         # profile_information["username"],
        #         profile_information["birthday"],
        #         profile_information["location"],
        #     )
        #     if (
        #         user_detail_collection.account_details.find_one(
        #             {"email": user_email}, {"email": 1}
        #         )
        #         == None
        #     ):  # check if need to update profile or create new profile
        user_detail_collection.account_details.insert_one(new_account_details.__dict__)
        return jsonify(
            {"create": True, "response": "User account details has been created"}
        )
    else:
        new_values = {
            "$set": {
                "username": profile_information["display_name"],
                "gender": profile_information["gender"],
                "age": profile_information["age"],
                "location": profile_information["location"],
            }
        }
        user_detail_collection.account_details.update_one(
            {"email": user}, update=new_values
        )
        return jsonify({"create": True, "response": "User details has been updated"})

        # user_detail_collection.account_details.update_one({})
        # return jsonify(
        #     {"create": False, "response": "User details has already been created"}
        # )


@account_page.route("/account/profile")
@token_required()
def profile(user):
    user_detail_collection = mongo_account_details_write.account_details
    account_details = user_detail_collection.account_details.find_one({"email": user})
    if account_details == None:
        return jsonify(
            {"read": False, "response": "User details has not been created yet"}
        )
    else:
        account_details["_id"] = str(account_details["_id"])
        return jsonify({"read": True, "response": account_details})


# @account_page.route("/account/email")
# def test_email():
#     mail = Mail(app)
#     msg = Message('Hello from the other side!', sender =   'lovelace.dating@gmail.com', recipients = ['joel.lim04@gmail.com'])
#     msg.body = "Hey Paul, sending you this email from my Flask app, lmk if it works"
#     mail.send(msg)
#     return "Message sent!"
