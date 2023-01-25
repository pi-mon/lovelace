from flask import Blueprint, jsonify, request, render_template, url_for
from lovelace.account.utils import token_required
from lovelace.admin.utils import admin_required
from lovelace import mongo_account_read, mongo_account_details_write
import base64


admin = Blueprint("admin", __name__, template_folder="templates")


@admin.route("/admin/", methods=["POST", "GET"])
# @token_required
# @admin_required
def index():
    return jsonify(
        {"login": True, "response": "User has logged in as admin sucessfully"}
    )


@admin.route("/admin/account", methods=["POST", "GET"])
def account():
    account_collection = mongo_account_read.account
    account_list = [_ for _ in account_collection.user.find({})]
    return render_template(
        "admin/account.html", account_list=account_list, title="Account"
    )


@admin.route("/admin/account-details", methods=["POST", "GET"])
def account_details():
    account_details_collection = mongo_account_details_write.account_details
    account_details_list = [
        _ for _ in account_details_collection.account_details.find({})
    ]
    for account_details in account_details_list:
        account_details["profile_pic"] = base64.b64encode(
            account_details["profile_pic"]
        ).decode("utf-8")
        account_details["display_pic"] = base64.b64encode(
            account_details["display_pic"]
        ).decode("utf-8")
    return render_template(
        "admin/account-details.html",
        account_details_list=account_details_list,
        title="Account Details",
    )
