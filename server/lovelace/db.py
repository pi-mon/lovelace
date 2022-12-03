import pymongo
import certifi
import os
from dotenv import load_dotenv
load_dotenv()

ca = certifi.where()
mongo = pymongo.MongoClient(host=os.environ.get("MONGO_URI"),tlsCAFile=ca)