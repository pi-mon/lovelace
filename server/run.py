import os
from lovelace import create_app

app = create_app()

if __name__ == "__main__":
    host = "0.0.0.0" if os.environ.get("IN_DOCKER", False) else "localhost"
    app.run(debug=True, host=host, port=3000)  # , ssl_context=("cert.pem", "key.pem"))
