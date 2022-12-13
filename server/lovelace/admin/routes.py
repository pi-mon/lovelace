from flask import Blueprint, jsonify, request
from lovelace.account.utils import token_required
from lovelace.admin.utils import admin_required


admin_page = Blueprint("admin", __name__, template_folder="templates")

@admin_page.route("/admin", methods=['POST', 'GET'])
@token_required
@admin_required
def admin_dashboard():
  return(jsonify({"login":True,"response":"User has logged in as admin sucessfully"}))