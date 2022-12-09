from flask import Blueprint, request, jsonify
from lovelace.logger import setup_logger
from pathlib import Path
import os, json

logger = setup_logger(__name__)
logs = Blueprint("logs", __name__)

@logs.route("/logs/werkzeug", methods=["GET"])
def werkzeug_logs():
    logger.info("%s Accessed werkzeug logs", request.remote_addr)
    LOG_DIR = os.path.join(Path(__file__).parent.parent.parent, "logs\\root.log")
    counter = 0
    logDict = {}
    with open(LOG_DIR) as f:
        for line in f:
            stripped = line.strip("")
            print(stripped)

    return "asdasd"

@logs.route("/logs/account")
def account_logs():
    logger.info("%s Accessed account logs", request.remote_addr)
    LOG_DIR = os.path.join(Path(__file__).parent.parent.parent, "logs\\lovelace.account.routes.log")
    counter = 0
    logDict = {}
    with open(LOG_DIR) as f:
        for line in f:
            decoded = json.loads(line)
            logDict[counter] = decoded
            counter += 1

    return logDict

@logs.route("/logs/chat")
def chat_logs():
    logger.info("%s Accessed chat logs", request.remote_addr)
    LOG_DIR = os.path.join(Path(__file__).parent.parent.parent, "logs\\lovelace.chat.routes.log")
    counter = 0
    logDict = {}
    with open(LOG_DIR) as f:
        for line in f:
            decoded = json.loads(line)
            logDict[counter] = decoded
            counter += 1

    return logDict

@logs.route("/logs/recommendation")
def recommendation_logs():
    logger.info("%s Accessed recommendation logs", request.remote_addr)
    LOG_DIR = os.path.join(Path(__file__).parent.parent.parent, "logs\\lovelace.recommendation.routes.log")
    counter = 0
    logDict = {}
    with open(LOG_DIR) as f:
        for line in f: 
            decoded = json.loads(line)
            logDict[counter] = decoded
            counter += 1

    return logDict