from flask import Blueprint, request, jsonify
from lovelace import chat_logger as logger
from lovelace import socketio
from flask_socketio import join_room, emit, leave_room
from lovelace.account.utils import token_required
import secrets
from lovelace import (
    mongo_account_read,
    mongo_account_write,
    mongo_account_details_write,
    mongo_temp_write,
    mongo_temp_read,
    mongo_chat_write,
)


chat = Blueprint("chat", __name__, template_folder="templates")


# @chat.route("/swipe")
# # @token_required()
# def swipe():
#     account = mongo_account_read.account
#     pipeline = [{"$sample": {"size": 5}}]
#     profiles = account.user.aggregate(pipeline=pipeline)
#     profile_list = list(profiles)
#     for profile in profile_list:
#         profile["_id"] = str(profile["_id"])
#     profile_dict = {"results": profile_list}
#     return jsonify(profile_dict)


# @chat.route("/chat")
# @token_required()
# def get_chat():
#     user_json = request.get_json()
#     email = user_json["email"]
#     target_user = user_json["target_email"]

#     return jsonify({"data": "testing", "email": email})


@socketio.on("join", namespace="/chat")
@token_required()
def join(_, message):
    user1 = message["user1"]
    user2 = message["user2"]
    chat_collection = mongo_chat_write.chat
    room = chat_collection.chat.find_one({"$and": [{"user1": user1}, {"user2": user2}]})

    if room == None:
        room = chat_collection.chat.insert_one(
            {"user1": message["user1"], "user2": message["user2"], "total_user":1}
        )
    else:
        chat_collection.chat.update_one({"$and": [{"user1": user1}, {"user2": user2}]}, {"$set": {"total_user":2}})

    # join room
    room_name = str(room["_id"])
    join_room(str(room_name))
    response = f"{user1} has entered room ({room_name})."

    # get number of users
    user_count = chat_collection.chat.find_one({"$and": [{"user1": user1}, {"user2": user2}]})["total_user"]
    if user_count == 2:
        key = secrets.token_urlsafe(32)
        emit("message", {"key": key}, room_name=room_name)

    print(response)

    # Emit message or notifier to other user of same room
    emit("message", {"response": response}, room_name=room_name)


@socketio.on("sent", namespace="/chat")
@token_required()
def sent(_, message):
    user1 = message["user1"]
    user2 = message["user2"]
    chat_collection = mongo_chat_write.chat
    room = chat_collection.chat.find_one(
        {"$and": [{"user1": user1}, {"user2": user2}]}
    )["_id"]
    msg = message["message"]
    response = f"{user1} : {msg}"
    print(response)
    emit("sent", {"response": response, "message": message}, room=room)


@socketio.on("leave", namespace="/chat")
@token_required()
def leave(_, message):
    user1 = message["user1"]
    user2 = message["user2"]
    chat_collection = mongo_chat_write.chat
    room = chat_collection.chat.find_one(
        {"$and": [{"user1": user1}, {"user2": user2}]}
    )["_id"]
    # leaving the room
    leave_room(room=room)
    chat_collection.chat.delete_one({"_id":room})
    emit("message", {"response": f"{user1} has left the room."}, room=room)
