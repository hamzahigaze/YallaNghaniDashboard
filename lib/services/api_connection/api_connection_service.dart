import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'service_models/request_error.dart';
import 'service_models/request_result.dart';
import 'service_models/api_response.dart';

export 'service_models/request_error.dart';
export 'service_models/request_result.dart';
export 'service_models/api_response.dart';

enum HttpMethod { POST, GET, PATCH, PUT, DELETE }

class ApiCaller {
  ///

  static Future<RequestResult> request({
    @required String url,
    @required HttpMethod method,
    Map<String, String> headers,
    body,
    Duration timeout,
  }) async {
    if (body != null && !_isValidBodyType(body)) {
      return NonVaildBodyType(''' Wrong Request Body Type : 
Allowed Types Are : 
1: List<int>
2: String
3: Map<String, String>''');
    }
    http.Response response;
    Duration timeoutDuration = timeout ?? Duration(minutes: 5);
    try {
      switch (method) {
        case HttpMethod.POST:
          response = await http
              .post(Uri.parse(url), body: body, headers: headers)
              .timeout(timeoutDuration);
          break;
        case HttpMethod.GET:
          response = await http
              .get(Uri.parse(url), headers: headers)
              .timeout(timeoutDuration);
          break;
        case HttpMethod.PATCH:
          response = await http
              .patch(Uri.parse(url), body: body, headers: headers)
              .timeout(timeoutDuration);
          break;
        case HttpMethod.PUT:
          response = await http
              .put(Uri.parse(url), body: body, headers: headers)
              .timeout(timeoutDuration);
          break;
        case HttpMethod.DELETE:
          response = await http
              .delete(Uri.parse(url), headers: headers)
              .timeout(timeoutDuration);
          break;
      }
      return parseHttpResponse(response);
    } on SocketException {
      return InternetConnectionError(
          "A SocketException Was Thrown Detecting internet Connection error");
    } on TimeoutException {
      return ConnectionTimedOut();
    } catch (exception, stackTrace) {
      return UnkonwnError(
        ''' An Exception Was Caught Sending The Request.
Exception: 
${exception.toString()}
Stack Trace: 
${stackTrace.toString()}''',
      );
    }
  }

  static RequestResult parseHttpResponse(http.Response response) {
    int statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode <= 299) {
      return Ok(body: response.body, headers: response.headers);
    }

    if (statusCode == 400) {
      return BadRequest(body: response.body, headers: response.headers);
    } else if (statusCode == 401) {
      return UnAuthorized(body: response.body, headers: response.headers);
    } else if (statusCode == 403) {
      return Forbidden(body: response.body, headers: response.headers);
    } else if (statusCode == 404) {
      return NotFound(body: response.body, headers: response.headers);
    } else if (statusCode == 405) {
      return MethodNotAllowed(body: response.body, headers: response.headers);
    } else if (statusCode == 500) {
      return InternalServerError(
        body: response.body,
        headers: response.headers,
      );
    } else {
      return UnkonwnError(
        'The Service Doesn\'t Recognize Response\'s Status Code. statusCode: $statusCode, body: ${response.body}',
      );
    }
  }

  static bool _isValidBodyType(body) {
    return body is List<int> || body is String || body is Map<String, String>;
  }

  //Get the full Url for the request
  static String attachParamsToUrl(String url, Map<String, String> params) {
    if (Uri.parse(url) == null) return null;
    String finalUrl = url;
    if (params == null || params.length == 0) {
      return finalUrl;
    }
    if (finalUrl[finalUrl.length - 1] != '?') {
      finalUrl += "?";
    }
    params.forEach((key, val) => {finalUrl += key + "=" + val + "&"});
    return finalUrl.substring(0, finalUrl.length - 1);
  }
}
