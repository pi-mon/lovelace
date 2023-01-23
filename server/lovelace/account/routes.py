from flask import Blueprint, jsonify, request, make_response
from lovelace import (
    mongo_account_read,
    mongo_account_write,
    mongo_account_details_write,
    mongo_temp_write,
    mongo_temp_read,
    mongo_chat_request_write,
    mongo_chat_request_read,
)
from flask import current_app as app
from flask_mail import Message, Mail
from pymongo import errors as db_errors
from argon2 import PasswordHasher
from lovelace.models import account
import jwt
import base64
from datetime import datetime, timedelta
from os import environ
from pyotp import TOTP
from lovelace import account_logger as logger
from bson.binary import Binary
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
            new_user = account.User(new_email, new_password_hash)
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
            resp = make_response(
                jsonify(
                    {
                        "creation": True,
                        "response": "Temp account was created successfully",
                    }
                )
            )
            resp.set_cookie("token", token)
            return resp
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
        otp = str(request.get_json()["otp"]).zfill(6)
    except db_errors.OperationFailure:
        return jsonify({"create": False, "response": "Invalid database operation"})
    except:
        return jsonify(
            {"create": False, "response": "User login failed due to invalid input"}
        )
    try:
        if otp_expiry > datetime.utcnow() and user_details["otp"] == otp:
            account_collection = mongo_account_write.account
            request_collection = mongo_chat_request_write.account_details
            new_user = account.User(user_details["email"], user_details["password"])
            new_user_json = new_user.__dict__
            account_collection.user.insert_one(new_user_json)
            request_collection.chat_request.insert_one({"email": user, "request": []})
            return jsonify(
                {"create": True, "response": "Account was created successfully"}
            )
    except db_errors.OperationFailure:
        return jsonify({"create": False, "response": "Invalid database operation"})
    except:
        return jsonify({"create": False, "response": "Account creation has an error"})
    return jsonify({"create": False, "response": "Expired or Invalid OTP was entered"})


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
        resp = make_response(
            jsonify({"login": True, "response": "User login successful"})
        )
        resp.set_cookie("token", token)
        logger.info(
            "%s Logged in successfully using email, otp required to login %s",
            request.remote_addr,
            email,
        )
        return resp


@account_page.route("/account/login/verify", methods=["POST", "GET"])
@token_required(need_authenticated=False)
def login_verify(user):
    try:
        account_collection = mongo_account_read.account
        otp_details = account_collection.user.find_one(
            {"email": user}, {"otp": 1, "otp_expiry": 1}
        )
        otp = str(request.get_json()["otp"]).zfill(6)
        user_otp = str(otp_details["otp"])
        user_otp_expiry = otp_details["otp_expiry"]
    except:
        return jsonify(
            {"login": False, "response": "User login failed due to invalid input"}
        )
    if (
        user_otp_expiry > datetime.utcnow() and user_otp == otp
    ):  # checks if otp has expired and is valid
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
        resp = make_response(
            jsonify({"login": True, "response": "User login successful"})
        )
        resp.set_cookie("token", token)
        return resp
    elif user_otp_expiry < datetime.utcnow():
        print(
            f"{datetime.utcnow()} is the current time, {user_otp_expiry} is when the otp expires "
        )
        return jsonify({"login": False, "response": "Expired otp"})
    elif user_otp != otp:
        print(f"{otp} is what user entered, {user_otp} is the valid otp")
        return jsonify({"login": False, "response": "Invalid otp"})
    return jsonify(
        {
            "login": False,
            "response": "Error logging verifying account please try again later",
        }
    )


@account_page.route("/account/profile/update", methods=["POST", "GET"])
@token_required()  # user is email registered
def update_profile(user):
    try:
        profile_information = request.get_json()
        user_detail_collection = mongo_account_details_write.account_details
        new_account_details = account.UserDetails(
            user,
            profile_information["display_name"],
            profile_information["birthday"],
            profile_information["gender"],
            profile_information["location"],
        )
    except:
        return jsonify({"update": False, "response": "Invalid user input"})
    if (
        user_detail_collection.account_details.find_one({"email": user}, {"email": 1})
        == None
    ):  # check if need to update profilwwwwwe or create new profile
        user_detail_collection.account_details.insert_one(new_account_details.__dict__)
        return jsonify(
            {"update": True, "response": "User account details has been created"}
        )
    else:
        new_values = {
            "$set": {
                "display_name": profile_information["display_name"],
                "gender": profile_information["gender"],
                "birthday": profile_information["birthday"],
                "location": profile_information["location"],
            }
        }
        user_detail_collection.account_details.update_one(
            {"email": user}, update=new_values
        )
        return jsonify({"update": True, "response": "User details has been updated"})


@account_page.route("/account/profile/update/display_pic", methods=["POST", "GET"])
@token_required()
def update_display_pic(user):
    def compare_hash(hash, file):
        import hashlib
        import base64

        text = base64.b64encode(file.read())
        encoded_text = text.decode("utf-8").encode("utf-8")
        hash_object = hashlib.sha512(encoded_text)
        hex_dig = hash_object.hexdigest()
        print(hex_dig == hash)

    try:
        hash = request.form.get("hash")
        print(hash)
        user_detail_collection = mongo_account_details_write.account_details
        display_pic = request.files["display_pic"]
        compare_hash(hash, display_pic)
        new_account_details = account.UserDetails(user, "", "", "", "")
    except Exception as e:
        print(e)
        return jsonify({"update": False, "response": "Invalid user input"})
    if (
        user_detail_collection.account_details.find_one({"email": user}, {"email": 1})
        == None
    ):  # check if need to update profile or create new profile
        user_detail_collection.account_details.insert_one(new_account_details.__dict__)
        return jsonify(
            {
                "update": True,
                "response": "display_pic was updated and empty user details was created",
            }
        )
    else:
        encoded_display_pic = display_pic.read()
        new_values = {"$set": {"display_pic": encoded_display_pic}}
        user_detail_collection.account_details.update_one(
            {"email": user}, update=new_values
        )
        return jsonify(
            {"update": True, "response": "User display_pic has been updated"}
        )


@account_page.route("/account/profile/update/profile_pic", methods=["POST", "GET"])
@token_required()
def update_profile_pic(user):
    try:
        user_detail_collection = mongo_account_details_write.account_details
        profile_pic = request.files["profile_pic"]
        new_account_details = account.UserDetails(user, "", "", "", "")
    except:
        return jsonify({"update": False, "response": "Invalid user input"})
    if (
        user_detail_collection.account_details.find_one({"email": user}, {"email": 1})
        == None
    ):  # check if need to update profile or create new profile
        user_detail_collection.account_details.insert_one(new_account_details.__dict__)
        return jsonify(
            {
                "update": True,
                "response": "profile_pic was updated and empty user details was created",
            }
        )
    else:
        encoded_profile_pic = profile_pic.read()
        new_values = {"$set": {"profile_pic": encoded_profile_pic}}
        user_detail_collection.account_details.update_one(
            {"email": user}, update=new_values
        )
        return jsonify(
            {"update": True, "response": "User profile_pic has been updated"}
        )


@account_page.route("/account/profile")
@token_required()
def profile(user):
    try:
        user_detail_collection = mongo_account_details_write.account_details
        account_details = user_detail_collection.account_details.find_one(
            {"email": user}
        )
        account_details["_id"] = str(account_details["_id"])
        display_pic = base64.b64encode(account_details["display_pic"]).decode("utf-8")
        profile_pic = base64.b64encode(account_details["profile_pic"]).decode("utf-8")
        account_details["display_pic"] = display_pic
        account_details["profile_pic"] = profile_pic
        return jsonify({"read": True, "response": account_details})
    except Exception as e:
        return jsonify(
            {"read": False, "response": f"Error retrieving user profile: {e}"}
        )


@account_page.route("/account/request_list")
@token_required()
def request_lst(user):
    request_collection = mongo_chat_request_read.account_details
    try:
        user_request_lst = request_collection.chat_request.find_one(
            {"email": user}, {"request": 1}
        )["request"]
    except KeyError:
        return jsonify({"response": "chat request list cannot be found"})
    except db_errors.OperationFailure:
        return jsonify({"Invalid database operation"})
    return jsonify(user_request_lst)


@account_page.route("/account/request_list/accept")
@token_required()
def accept_request(user):
    target_user_json = request.get_json()
    try:
        target_email = target_user_json["target_email"]
    except KeyError:
        return jsonify({"response": "Invalid input was sent"})
    request_collection = mongo_chat_request_write.account_details
    if request_collection.chat_request.find_one({"email": user}) != None:
        follow_lst = request_collection.chat_request.find_one(
            {"email": user}, {"request": 1}
        )["request"]
        for users in follow_lst:
            if users["target"] == target_email:
                new_values = {
                    "$set": {"request": {"target": target_email, "approved": True}}
                }
                request_collection.chat_request.update_one(
                    {"email": user}, update=new_values
                )
                return jsonify({"response": "Chat request was approved"})
    return jsonify({"reponse": "Target user cannot be found in follow list"})
