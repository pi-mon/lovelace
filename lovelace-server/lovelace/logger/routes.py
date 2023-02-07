from flask import Blueprint, request, jsonify
from lovelace.logger.utils import get_paginated_list
from lovelace.account.utils import token_required
from lovelace.admin.utils import admin_required
from lovelace import logs_logger as logger
from pathlib import Path
import os, json

logs = Blueprint("logs", __name__)
LOG_DIR = os.path.join(Path(__file__).parent.parent.parent, "logs")


@logs.route("/logs/root/<int:start>/<int:limit>", methods=["GET"])
# @token_required()
# @admin_required()
def root_logs(start, limit):
    logger.info("%s Accessed root logs", request.remote_addr)
    log_dir = os.path.join(LOG_DIR, "root.log")

    try:
        # start = int(request.args.get("start", 1))
        # limit = int(request.args.get("limit", 20))
        if start == 0:
            return jsonify({"response": "start variable must be from 1 onwards"})
    except TypeError:
        return jsonify({"response": "Invalid data type, must be integer"})

    log_list = []
    count = 0
    with open(log_dir) as f:
        for i, line in enumerate(f):
            decoded = json.loads(line)
            log_list.append(decoded)
            count += 1

    log_dict = get_paginated_list("/logs/account", start, limit, count)
    log_dict["results"] = log_list[(start - 1) : (start - 1 + limit)]
    return jsonify(log_dict)


@logs.route("/logs/account/<int:start>/<int:limit>")
# @token_required()
# @admin_required()
def account_logs(start, limit):
    logger.info("%s Accessed account logs", request.remote_addr)
    log_dir = os.path.join(LOG_DIR, "account.log")

    try:
        # start = int(request.args.get("start", 1))
        # limit = int(request.args.get("limit", 20))
        if start == 0:
            return jsonify({"response": "start variable must be from 1 onwards"})
    except TypeError:
        return jsonify({"response": "Invalid data type, must be integer"})

    log_list = []
    count = 0
    with open(log_dir) as f:
        for i, line in enumerate(f):
            decoded = json.loads(line)
            log_list.append(decoded)
            count += 1

    log_dict = get_paginated_list("/logs/root", start, limit, count)
    log_dict["results"] = log_list[(start - 1) : (start - 1 + limit)]
    return jsonify(log_dict)


@logs.route("/logs/chat/<int:start>/<int:limit>")
# @token_required()
# @admin_required()
def chat_logs(start, limit):
    logger.info("%s Accessed chat logs", request.remote_addr)
    log_dir = os.path.join(LOG_DIR, "chat.log")

    try:
        # start = int(request.args.get("start", 1))
        # limit = int(request.args.get("limit", 20))
        if start == 0:
            return jsonify({"response": "start variable must be from 1 onwards"})
    except TypeError:
        return jsonify({"response": "Invalid data type, must be integer"})

    log_list = []
    count = 0
    with open(log_dir) as f:
        for i, line in enumerate(f):
            decoded = json.loads(line)
            log_list[counter] = decoded
            counter += 1

    return log_list


@logs.route("/logs/recommendation/<int:start>/<int:limit>")
# @token_required()
# @admin_required()
def recommendation_logs(start, limit):
    logger.info("%s Accessed recommendation logs", request.remote_addr)
    log_dir = os.path.join(LOG_DIR, "recommendation.log")

    counter = 0
    log_dict = {}
    with open(log_dir) as f:
        for i, line in enumerate(f):
            decoded = json.loads(line)
            log_dict[counter] = decoded
            counter += 1

    return log_dict

    # log_dict = {"results": log_list}
    # return jsonify(log_dict)
