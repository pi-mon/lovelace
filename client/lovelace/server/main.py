from flask import Flask, jsonify, request

app = Flask(__name__)


@app.route("/", methods=["POST"])
def index():
    content = request.json
    print(content)
    return jsonify(content)


if __name__ == "__main__":
    app.run(debug=True)
