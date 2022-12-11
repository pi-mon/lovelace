from flask import Blueprint, jsonify, request
from lovelace import recommendation_logger as logger


recommendation = Blueprint("recommendation", __name__, template_folder="templates")


@recommendation.route("/recommendation")
def get_recommendation():
    # current_user = "user" #jwt token
    logger.info("%s Accessed Recommendation", request.remote_addr)
    return jsonify({"users": ["test1", "test2", "test3"]})
