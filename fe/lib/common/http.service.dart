import 'dart:convert';
import 'package:http/http.dart' as http;
import 'common.model.dart';

class HttpService {
  final String baseUrl;

  HttpService({required this.baseUrl});

  Future<dynamic> request(HttpRequest request) async {
    http.Response response;

    switch (request.method) {
      case HttpMethod.GET:
        response = await http.get(Uri.parse(baseUrl + request.endpoint),
            headers: request.headers);
        break;
      case HttpMethod.POST:
        response = await http.post(
          Uri.parse(baseUrl + request.endpoint),
          body: json.encode(request.body),
          headers: request.headers,
        );
        break;
      case HttpMethod.PUT:
        response = await http.put(
          Uri.parse(baseUrl + request.endpoint),
          body: json.encode(request.body),
          headers: request.headers,
        );
        break;
      case HttpMethod.DELETE:
        response = await http.delete(Uri.parse(baseUrl + request.endpoint),
            headers: request.headers);
        break;
      case HttpMethod.MULTIPART:
        response = await http.post(
          Uri.parse(baseUrl + request.endpoint),
          headers: request.headers,
          body: request.body,
        );
        break;
      default:
        throw Exception('HTTP method not supported');
    }

    if (response.statusCode == 500) {
      throw Exception('Failed to load data');
    } else {
      return json.decode(response.body);
    }
  }
}
