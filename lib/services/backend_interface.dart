import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tuktak/models/server_response.dart';
import 'package:tuktak/services/shared_preference_service.dart';

class HttpException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic details;

  HttpException({
    required this.message,
    this.statusCode,
    this.details,
  });

  @override
  String toString() {
    return "HttpException: $message (Status code: $statusCode) Details: $details";
  }
}

class BackendInterface {
  BackendInterface._privateConstructor(this._dio) {
    _dio.options.validateStatus = (status) => true;
    _initializeCookies();
  }

  static final BackendInterface _instance =
      BackendInterface._privateConstructor(Dio());

  final String _baseUrl = "http://52.3.40.124/api/v1";
  final Dio _dio;
  String? cookie;

  factory BackendInterface() {
    return _instance;
  }

  // Initialize cookie when the instance is created
  void _initializeCookies() {
    final sharedPreferenceService = SharedPreferenceService();
    cookie = sharedPreferenceService.cookies; // Retrieve cookie if it exists
  }

  void clearCookies() {
    cookie = null;
  }

  // Handle server response and parse JSON
  ServerResponse handleResponse(Response<String> response) {
    try {
      print(response.data);
      final jsonDecoded = jsonDecode(response.data!);

      return ServerResponse.fromJson(jsonDecoded,
          headers: response.headers.map);
    } catch (e) {
      throw HttpException(
          message:
              "Unknown response! The response data is not in correct format");
    }
  }

  // Extract the cookies from headers if available
  Future<void> _handleCookies(Response<String> response) async {
    final setCookie = response.headers.value('Set-Cookie');
    if (setCookie != null) {
      cookie = setCookie; // Store the cookie
      // save cookie using SharedPreferenceService to persist it
      await SharedPreferenceService().setCookie(setCookie);
    }
  }

  // Handle HTTP requests with error handling
  Future<ServerResponse> _sendRequest(String method, String url,
      {Object? body, HashMap<String, dynamic>? headers}) async {
    final String endpoint = "$_baseUrl/$url";
    try {
      // Add the cookie to headers if available
      if (cookie != null) {
        headers ??= HashMap();
        print("Cookie is $cookie");
        headers['Cookie'] = cookie;
      }

      // Make the HTTP request using Dio
      Response<String> response;
      switch (method) {
        case 'POST':
          response = await _dio.post(endpoint,
              data: body, options: Options(headers: headers));
          break;
        case 'GET':
          response =
              await _dio.get(endpoint, options: Options(headers: headers),data: body);
          break;
        case 'PUT':
          response = await _dio.put(endpoint,
              data: body, options: Options(headers: headers));
          break;
        case 'DELETE':
          response = await _dio.delete(endpoint,
              data: body, options: Options(headers: headers));
          break;
        default:
          throw HttpException(message: "Unsupported HTTP method: $method");
      }

      // Handle cookies and return the response
      await _handleCookies(response);
      print(response.data);
      return handleResponse(response);
    } on DioException catch (e) {
      throw HttpException(
          message:
              "Something went wrong when communicating with backend: ${e.message}");
    } catch (e) {
      throw HttpException(message: "Unexpected error: ${e.toString()}");
    }
  }

  // POST request
  Future<ServerResponse> post(String url,
      {Object? body, HashMap<String, dynamic>? headers}) async {
    return _sendRequest('POST', url, body: body, headers: headers);
  }

  // GET request
  Future<ServerResponse> get(String url,
      {HashMap<String, dynamic>? headers,Object? body}) async {
    return _sendRequest('GET', url, headers: headers,body: body);
  }

  // PUT request
  Future<ServerResponse> put(String url,
      {Object? body, HashMap<String, dynamic>? headers}) async {
    return _sendRequest('PUT', url, body: body, headers: headers);
  }

  // DELETE request
  Future<ServerResponse> delete(String url,
      {Object? body, HashMap<String, dynamic>? headers}) async {
    return _sendRequest('DELETE', url, body: body, headers: headers);
  }

  Future<void> sendPutRequest(String url,
      {Object? body, HashMap<String, dynamic>? headers}) async {
    final dio = Dio();
    final Response<String> response =
        await dio.put(url, data: body, options: Options(headers: headers));
  }
}
