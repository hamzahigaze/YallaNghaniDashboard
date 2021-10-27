import 'dart:convert';

import '../../api_connection/service_models/request_result.dart';

// enum ResponseFailureReason {
//   internetConnectionError,
//   connectionTimedOUt,
//   wrongBodyType,
//   nullResponse,
//   badRequest,
//   unauthourized,
//   forbidden,
//   notFound,
//   methodNotAllowed,
//   internalServerError,
//   unknown
// }

abstract class ApiResponse extends RequestResult {
  ApiResponse({this.statusCode, this.headers, this.body});

  int statusCode;

  String body;

  Map<String, String> headers;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> parsedBody;

    try {
      parsedBody = json.decode(body);
    } catch (e) {}

    return {
      'statusCode': statusCode,
      'body': parsedBody ?? body,
      'headers': headers
    };
  }

  Map<String, dynamic> deserilizeBody() {
    try {
      return json.decode(body);
    } catch (e, stackTrace) {
      throw Exception('''An Eception Occured While Parsing The Body. 
The Inner Excetion Was: ${e.toString()}.
The Stack Trace Was: $stackTrace.''');
    }
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class Ok extends ApiResponse {
  Ok({Map<String, String> headers, String body})
      : super(body: body, headers: headers, statusCode: 200);
}

class BadRequest extends ApiResponse {
  BadRequest({Map<String, String> headers, String body})
      : super(body: body, headers: headers, statusCode: 400);
}

class NotFound extends ApiResponse {
  NotFound({Map<String, String> headers, String body})
      : super(body: body, headers: headers, statusCode: 404);
}

class UnAuthorized extends ApiResponse {
  UnAuthorized({Map<String, String> headers, String body})
      : super(body: body, headers: headers, statusCode: 401);
}

class Forbidden extends ApiResponse {
  Forbidden({Map<String, String> headers, String body})
      : super(body: body, headers: headers, statusCode: 403);
}

class MethodNotAllowed extends ApiResponse {
  MethodNotAllowed({Map<String, String> headers, String body})
      : super(body: body, headers: headers, statusCode: 405);
}

class InternalServerError extends ApiResponse {
  InternalServerError({Map<String, String> headers, String body})
      : super(body: body, headers: headers, statusCode: 500);
}
