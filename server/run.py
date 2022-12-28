import os
from lovelace import app, socketio

if __name__ == "__main__":
    host = "0.0.0.0" if os.environ.get("IN_DOCKER", False) else "127.0.0.1"
    socketio.run(app,debug=True, host=host, port=3000,)# ssl_context=("cert.pem", "key.pem"))