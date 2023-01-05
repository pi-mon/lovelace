from lovelace import mongo_admin_read
from flask import jsonify

def admin_required(f):
  def wrapper(user):
    admin_collection = mongo_admin_read.admin_account
    is_admin = admin_collection.admin.find_one({"email": user["email"]}, {"admin": 1})
    if is_admin != None and is_admin["admin"] == True:
      #return(jsonify({"login":True,"response":"User has logged in as admin sucessfully"}))
      return(f())
    else:
      return(jsonify({"login":False,"reponse":"User is not an admin"}))
  return(wrapper)