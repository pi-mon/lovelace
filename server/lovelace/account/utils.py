<<<<<<< HEAD
from functools import wraps
from flask import jsonify, request
import jwt
from lovelace import mongo,mongo_account_read
from pymongo import errors as db_errors
from os import environ
from validate_email import validate_email
import re
import dotenv
dotenv.load_dotenv()

schema = {
    "type": "object",
    "properties": {"email": {"type": "string"}, "password": {"type": "string"}},
    "required": ["email", "password"],
}


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        # jwt is passed in the form of a cookie
        if request.cookies.get("token") != False:
            token = request.cookies.get("token")
        # return 401 if token is not passed
        if not token:
            return jsonify({"message": "Token is missing !!"}), 401

        try:
            # decoding the payload to fetch the stored details
            account_collection = mongo_account_read.account
            data = jwt.decode(
                token, environ.get("APPLICATION_SIGNATURE_KEY"), algorithms="HS256"
            )
            print(data)
            if data["request ip"] != request.remote_addr:
              return(jsonify("Mismatched request ip address !!"))
            current_user = account_collection.user.find_one({"email": data["email"]})
            current_user["_id"] =  str(current_user["_id"])
        except jwt.ExpiredSignatureError:
            return jsonify({"message": "Token has expired !!"}), 401
        # except:
        #     return jsonify({"message": "Token is invalid !!"}), 401
        # returns the current logged in users contex to the routes
        except db_errors.OperationFailure:
          return jsonify({"message": "Disallowed database operation"})
          
        return f(current_user, *args, **kwargs)

    return decorated


def email_validation(email):
    if len(email) <= 320:
        validate_email(email)
        return True
    else:
        return False


def password_validation(password):
    if re.match(
        r"^(?=\S{8,20}$)(?=.*?\d)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^A-Za-z\s0-9])",
        password,
    ):
        return True
    else:
        return False
=======
from functools import wraps
from flask import jsonify, request
import jwt
from lovelace import mongo,mongo_account_read
from pymongo import errors as db_errors
from os import environ
from validate_email import validate_email
import re
import dotenv
dotenv.load_dotenv()

schema = {
    "type": "object",
    "properties": {"email": {"type": "string"}, "password": {"type": "string"}},
    "required": ["email", "password"],
}


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        # jwt is passed in the form of a cookie
        if request.cookies.get("token") != False:
            token = request.cookies.get("token")
        # return 401 if token is not passed
        if not token:
            return jsonify({"message": "Token is missing !!"}), 401

        try:
            # decoding the payload to fetch the stored details
            account_collection = mongo_account_read.account
            data = jwt.decode(
                token, environ.get("APPLICATION_SIGNATURE_KEY"), algorithms="HS256"
            )
            print(data)
            if data["request ip"] != request.remote_addr:
              return(jsonify("Mismatched request ip address !!"))
            current_user = account_collection.user.find_one({"email": data["email"]})
            current_user["_id"] =  str(current_user["_id"])
        except jwt.ExpiredSignatureError:
            return jsonify({"message": "Token has expired !!"}), 401
        # except:
        #     return jsonify({"message": "Token is invalid !!"}), 401
        # returns the current logged in users contex to the routes
        except db_errors.OperationFailure:
          return jsonify({"login": False, "response": "Disallowed database operation"})
        return f(current_user, *args, **kwargs)

    return decorated


def email_validation(email):
    if len(email) <= 320:
        validate_email(email)
        return True
    else:
        return False


def password_validation(password):
    if re.match(
        r"^(?=\S{8,20}$)(?=.*?\d)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^A-Za-z\s0-9])",
        password
    ):
        return True
    else:
        return False
>>>>>>> c688771cdbdfb52ec738fd48815661a07057a54f
