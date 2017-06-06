import json
import os
from wsgiref.simple_server import make_server


def simple_app(environ, start_response):
    try:
        payload_length = int(environ.get("CONTENT_LENGTH") or 0)
        input_payload = environ["wsgi.input"].read(payload_length)
        input_data = json.loads(input_payload) if input_payload else None
        status = "200 OK"
    except ValueError as e:
        input_data = {"error": "Cannot parse content."}
        status = "400 BAD REQUEST"
    headers = [
        ("Content-type", "application/json"),
    ]
    start_response(status, headers)
    return [json.dumps(input_data, indent=2).encode("utf-8")]


def main():
    host = os.environ.get("HOST", "127.0.0.1")
    port = int(os.environ.get("PORT", 8000))
    print("Start a server at http://{0}:{1}".format(host, port))
    print("Press Ctrl+C to stop this server.\n")
    httpd = make_server(host, 8000, simple_app)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nClose the server ...")
        pass

if __name__ == "__main__":
    main()
