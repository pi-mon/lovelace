from functools import wraps
from flask import jsonify, request
import jwt
from lovelace import mongo
from os import environ
from validate_email import validate_email
import re

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
            account_collection = mongo.account
            data = jwt.decode(
                token, environ.get("APPLICATION_SIGNATURE_KEY"), algorithms="HS256"
            )
            print(data)
            current_user = account_collection.user.find_one(data["username"])
        except jwt.ExpiredSignatureError:
            return jsonify({"message": "Token has expired !!"}), 401
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
