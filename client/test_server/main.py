from flask import Flask, jsonify, request

app = Flask(__name__)


@app.route("/register", methods=["POST"])
def register():
    content = request.json
    print(content)
    return jsonify(content)


@app.route("/login", methods=["POST"])
def login():
    content = request.json
    print(content)
    if content["email"] == "admin@gmail.com" and content["password"] == "admin":
        return jsonify({"status": "success"})
    return jsonify({"content": "failed"})


if __name__ == "__main__":
    app.run(debug=True)
