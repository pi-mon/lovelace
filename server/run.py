import os
from lovelace import app, socketio


@app.route("/")
def index():
    return "I'm alive!"

if __name__ == "__main__":
    host = "0.0.0.0" if os.environ.get("IN_DOCKER", False) else "127.0.0.1"
    socketio.run(
        app,
        debug=False,
        host=host,
        port=3000,
        #ssl_context=("cert.pem", "key.pem"),
    )
