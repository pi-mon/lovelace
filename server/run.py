import os
from lovelace import app, socketio
from apscheduler.schedulers.background import BackgroundScheduler
from dotenv import load_dotenv,set_key,find_dotenv
import random
import string
# from flask_wtf.csrf import CSRFError,generate_csrf
# from flask import jsonify


dotenv_file = find_dotenv()
load_dotenv(dotenv_file)

@app.route("/")
def index():
    return "I'm alive!"

#@app.route("/get_crsf")
#def get_csrf():
    #crsf_token = generate_csrf()
    #eturn(jsonify({"token":crsf_token}))

#@app.errorhandler(CSRFError)
#def handle_csrf_error(e):
    #return(jsonify({"response":"CRSF token is invalid"}))

def rotate_key():
    # get random string with letters, digits, and symbols
    characters = string.ascii_letters + string.digits + string.punctuation
    characters = characters.replace('"','')
    characters = characters.replace("'","")
    key = ''.join(random.choice(characters) for i in range(256))
    os.environ["APPLICATION_SIGNATURE_KEY_TEMP"] = os.environ["APPLICATION_SIGNATURE_KEY"] #store key temp
    os.environ["APPLICATION_SIGNATURE_KEY"] = key
    set_key(dotenv_file,"APPLICATION_SIGNATURE_KEY",os.environ.get("APPLICATION_SIGNATURE_KEY"))
    set_key(dotenv_file,"APPLICATION_SIGNATURE_KEY_TEMP",os.environ.get("APPLICATION_SIGNATURE_KEY_TEMP"))

sched = BackgroundScheduler(daemon=True)
sched.add_job(rotate_key,'interval',hours=336) #reset every 2 weeks
sched.start()


if __name__ == "__main__":
    host = "127.0.0.1" if os.environ.get("IN_DOCKER", False) else "0.0.0.0"
    socketio.run(
        app,
        debug=False,
        host=host,
        port=3000,
        #ssl_context=("ec2-cert.pem", "ec2-key.pem"),
    )
