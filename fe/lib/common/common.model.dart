enum HttpMethod { GET, POST, PUT, DELETE, MULTIPART }

class HttpRequest {
  String endpoint;
  HttpMethod method;
  Map<String, String>? headers;
  dynamic body;

  HttpRequest({
    required this.endpoint,
    required this.method,
    this.headers,
    this.body,
  });
}
