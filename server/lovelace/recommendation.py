from flask import Blueprint, jsonify, request
from db import mongo
from logger import setup_logger

logger = setup_logger(__name__)

recommendation_page = Blueprint(
    "recommendation_page", __name__, template_folder="templates"
)


@recommendation_page.route("/recommendation")
def recommendation():
    # current_user = "user" #jwt token
    logger.info("%s Accessed Recommendation", request.remote_addr)
    return jsonify({"users": ["test1", "test2", "test3"]})
