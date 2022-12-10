from flask import Blueprint, request
from lovelace import logs_logger as logger
from pathlib import Path
import os, json

logs = Blueprint("logs", __name__)
LOG_DIR = os.path.join(Path(__file__).parent.parent.parent, "logs")


@logs.route("/logs/root", methods=["GET"])
def root_logs():
    logger.info("%s Accessed root logs", request.remote_addr)
    log_dir = os.path.join(LOG_DIR, "root.log")

    counter = 0
    log_dict = {}
    with open(log_dir) as f:
        for line in f:
            decoded = json.loads(line)
            log_dict[counter] = decoded
            counter += 1
    return log_dict


@logs.route("/logs/account")
def account_logs():
    logger.info("%s Accessed account logs", request.remote_addr)
    log_dir = os.path.join(LOG_DIR, "account.log")

    counter = 0
    log_dict = {}
    with open(log_dir) as f:
        for line in f:
            decoded = json.loads(line)
            log_dict[counter] = decoded
            counter += 1

    return log_dict


@logs.route("/logs/chat")
def chat_logs():
    logger.info("%s Accessed chat logs", request.remote_addr)
    log_dir = os.path.join(LOG_DIR, "chat.log")

    counter = 0
    log_dict = {}
    with open(log_dir) as f:
        for line in f:
            decoded = json.loads(line)
            log_dict[counter] = decoded
            counter += 1

    return log_dict


@logs.route("/logs/recommendation")
def recommendation_logs():
    logger.info("%s Accessed recommendation logs", request.remote_addr)
    log_dir = os.path.join(LOG_DIR, "recommendation.log")

    counter = 0
    log_dict = {}
    with open(log_dir) as f:
        for line in f:
            decoded = json.loads(line)
            log_dict[counter] = decoded
            counter += 1

    return log_dict
