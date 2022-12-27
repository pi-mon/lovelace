from flask import Blueprint, request, jsonify
from lovelace import chat_logger as logger
from lovelace import socketio
from flask_socketio import join_room, emit, leave_room
from lovelace.account.utils import token_required
from lovelace import mongo_account_read,mongo_account_write,mongo_account_details_write,mongo_temp_write,mongo_temp_read

chat = Blueprint("chat", __name__, template_folder="templates")

@chat.route("/swipe")
#@token_required()
def swipe():
    account_details = mongo_account_details_write.account_details
    profiles = account_details.account_details.find({})
    profile_list = list(profiles)
    for profile in profile_list:
        profile['_id'] = str(profile['_id'])
    profile_dict = {"results":profile_list}
    return jsonify(profile_dict)

@chat.route("/swiperight", method=["POST"])
def swipe_right():
    get_json = request.get_json()
    target_email = get_json["target_email"]

@chat.route("/chat")
@token_required()
def get_chat():
    global user_json
    user_json = request.get_json()
    email = user_json["email"]
    target_user = user_json["target_email"]

    return jsonify({"data": "testing", "email":email})

@socketio.on('join', namespace='/chat')
def join(message):
    room = message['room'] # temporary
    username = user_json["email"] # temporary
    # join room 
    join_room(room)
    # Emit message or notifier to other user of same room 
    emit('message', {"msg": {str(username) + 'has entered the room.'}}, room=room)


@socketio.on('text', namespace='/chat')
def text(message):
    room = message['room']
    username = user_json["email"]
    msg = message['msg']
    emit('message', {"msg": {str(username) + ' : ' + str(msg)}}, room=room)


@socketio.on('left', namespace='/chat')
def left(message):
    room = message['room']
    username = user_json["email"]
    # leaving the room
    leave_room(room=room)
    emit('message', {"msg": {str(username) + 'has left the room.'}}, room=room)
    
