from functools import wraps
from flask import jsonify, request
import jwt
from lovelace import mongo_account_read
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


def token_required(need_authenticated=True, database=mongo_account_read.account.user):
    def decorater(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            token = None
            # jwt is passed in the form of a cookie
            if request.cookies.get("token") != False:
                token = request.cookies.get("token")
            # return 401 if token is not passed
            if not token:
                message = "Token is missing !!"
                print(message)
                return jsonify({"message": message}), 401

            try:
                # decoding the payload to fetch the stored details
                account_collection = database
                data = jwt.decode(
                    token, environ.get("APPLICATION_SIGNATURE_KEY"), algorithms="HS256"
                )
                if data["request ip"] != request.remote_addr:
                    return jsonify("Mismatched request ip address !!")
                current_user = account_collection.find_one({"email": data["email"]})
                if current_user == None:
                    return jsonify({"message": "Invalid user in token"}), 500
                if need_authenticated == True and data["authenticated"] == False:
                    return (
                        jsonify({"message": "user is not authenticated with token"}),
                        500,
                    )
                current_user = current_user["email"]
            except jwt.ExpiredSignatureError:
                message = "Token has expired !!"
                print(message)
                return jsonify({"message": message}), 401
            except db_errors.OperationFailure:
                return jsonify({"message": "Disallowed database operation"})
            except:
                return jsonify({"message": "Token is invalid !!"}), 401
            # returns the current logged in users contex to the routes

            return f(current_user, *args, **kwargs)

        return decorated

    return decorater


def encrypted_token_required(f):
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
            if data["request ip"] != request.remote_addr:
                return jsonify("Mismatched request ip address !!")
            current_user = account_collection.user.find_one({"email": data["email"]})
            if current_user == None:
                return jsonify({"message": "Invalid user in token"}), 500
            current_user = current_user["email"]
        except jwt.ExpiredSignatureError:
            return jsonify({"message": "Token has expired !!"}), 401
        except db_errors.OperationFailure:
            return jsonify({"message": "Disallowed database operation"})
        except:
            return jsonify({"message": "Token is invalid !!"}), 401
        # returns the current logged in users contex to the routes

        return f(current_user, *args, **kwargs)

    return decorated


def email_validation(email):
    return len(email) <= 320 and validate_email(email)


def password_validation(password):
    return re.match(
        r"^(?=\S{8,20}$)(?=.*?\d)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^A-Za-z\s0-9])",
        password,
    )
