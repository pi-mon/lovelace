from flask import Blueprint, request, jsonify
from lovelace import chat_logger as logger
from lovelace import socketio
from flask_socketio import join_room, emit, leave_room
from lovelace.account.utils import token_required
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
def join(message):
    user1 = message["user1"]
    user2 = message["user2"]
    chat_collection = mongo_chat_write.chat
    room = chat_collection.chat.find_one(
        {"$and": [{"user1": user1}, {"user2": user2}]}
    )["_id"]

    if room == None:
        room = chat_collection.chat.insert_one(
            {"user1": message["user1"], "user2": message["user2"]}
        )

    # join room
    join_room(str(room))
    response = f"{user1} has entered room ({room})."
    print(response)

    # Emit message or notifier to other user of same room
    emit("message", {"response": response}, room=room)


@socketio.on("sent", namespace="/chat")
@token_required()
def sent(message):
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
def leave(message):
    user1 = message["user1"]
    user2 = message["user2"]
    chat_collection = mongo_chat_write.chat
    room = chat_collection.chat.find_one(
        {"$and": [{"user1": user1}, {"user2": user2}]}
    )["_id"]
    # leaving the room
    leave_room(room=room)
    emit("message", {"response": f"{user1} has left the room."}, room=room)
