from flask import Blueprint, jsonify, request, abort
from lovelace import recommendation_logger as logger
from lovelace.account.utils import token_required
from lovelace import mongo_chat_request_write, mongo_account_details_write
from pymongo import errors as db_errors

recommendation = Blueprint("recommendation", __name__, template_folder="templates")


# @recommendation.route("/")
# @token_required()
# def get_recommendation(user):
#     request_collection = mongo_chat_request_write.account_details
#     # request_collection.chat_request.create_index("email", unique=True)
#     request_collection.chat_request.insert_one({""})
#     logger.info("%s Accessed Recommendation", request.remote_addr)
#     return jsonify({"users": ["test1", "test2", "test3"]})

@recommendation.route("/servererror")
def server_error():
    abort(500)

@recommendation.route("/recommendation")
@token_required()
def swipe(user):
    import base64
    account_details = mongo_account_details_write.account_details
    profiles = account_details.account_details.find({})
    profile_list = list(profiles)
    for profile in profile_list:
        profile["_id"] = str(profile["_id"])
        display_pic = base64.b64encode(profile["display_pic"]).decode("utf-8")
        profile_pic = base64.b64encode(profile["profile_pic"]).decode("utf-8")
        profile["display_pic"] = display_pic
        profile["profile_pic"] = profile_pic
    profile_dict = {"results": profile_list}
    return jsonify(profile_dict)


@recommendation.route("/recommendation/request", methods=["POST"])
@token_required()
def swipe_right(user):
    target_json = request.get_json()
    target_email = target_json["target_email"]
    request_collection = mongo_chat_request_write.account_details
    # request_collection.chat_request.create_index("email", unique=True)
    # request_collection.chat_request.insert_one({"email":user,"request":[]})
    # request_collection.chat_request.insert_one({"email":target_email,"request":[]})
    try:
      if request_collection.chat_request.find_one({"email":user},{"email":1}) == None or request_collection.chat_request.find_one({"email":target_email},{"email":1}) == None:
        return jsonify({"response":"target user does not exist"})
      user_request = request_collection.chat_request.find_one({"email":user},{"request":1})
      target_user_request = request_collection.chat_request.find_one({"email":target_email},{"request":1})
      for users in user_request["request"]:
          if users["target"] == target_email:
            return jsonify({"response":"already sent chat request"})
      for target_user in target_user_request["request"]:
            if target_user["target"] == user:
              return jsonify({"response":"already sent chat request"})
      new_values = { "$push": { 'request':{"target":target_email,"approved":True}} }
      request_collection.chat_request.update_one({"email": user},update=new_values)
      new_values = { "$push": { 'request':{"target":user,"approved":False}} }
      request_collection.chat_request.update_one({"email": target_email},update=new_values)
    except db_errors.OperationFailure:
        return jsonify({"response":"Database Operation failure"})
    # except:
    #     return jsonify({"response":"internal server error"})
    return jsonify({"response":"chat request was sent"})
