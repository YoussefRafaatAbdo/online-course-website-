from flask import Flask
from prometheus_client import Counter, generate_latest

app = Flask(__name__)

REQUEST_COUNT = Counter('http_requests_total', 'Total Requests')

@app.route("/")
def home():
    REQUEST_COUNT.inc()
    return "ECourses Website"

@app.route("/metrics")
def metrics():
    return generate_latest()
