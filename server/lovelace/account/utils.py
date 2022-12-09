from functools import wraps
from flask import jsonify, request
import jwt
from lovelace.db import mongo
from os import environ

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
        except:
            return jsonify({"message": "Token is invalid !!"}), 401
        # returns the current logged in users contex to the routes
        return f(current_user, *args, **kwargs)

    return decorated