from flask import Blueprint, jsonify, request
from db import mongo
recommendation_page = Blueprint('recommendation_page', __name__,
                        template_folder='templates')

@recommendation_page.route("/recommendation")
def recommendation():
  #current_user = "user" #jwt token
  return jsonify({"users":["test1","test2","test3"]})