from os import environ
from dotenv import load_dotenv

load_dotenv()
SESSION_COOKIE_SECURE = True
SECRET_KEY = environ.get("SECRET_KEY")
MAIL_SERVER='smtp.gmail.com'
MAIL_PORT = 465
MAIL_USERNAME = environ.get("MAIL_USERNAME")
MAIL_PASSWORD = environ.get("MAIL_PASSWORD")
MAIL_USE_TLS = False
MAIL_USE_SSL = True