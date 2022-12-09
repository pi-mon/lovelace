import pymongo
import certifi
import os


ca = certifi.where()
mongo = pymongo.MongoClient(host=os.environ.get("MONGO_URI"), tlsCAFile=ca)
