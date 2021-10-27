import '../../api_connection/service_models/request_result.dart';

class RequestError extends RequestResult {
  String errorDiscreption;

  RequestError([this.errorDiscreption]);

  @override
  String toString() {
    return '${this.errorDiscreption}';
  }
}

class InternetConnectionError extends RequestError {
  InternetConnectionError([String errorDesc]) : super(errorDesc);

  @override
  String toString() {
    return 'Error Type: InternetConnectionError, ${this.errorDiscreption}';
  }
}

class NonVaildBodyType extends RequestError {
  NonVaildBodyType([String errorDesc]) : super(errorDesc);

  @override
  String toString() {
    return 'Error Type: NonVaildBodyType, ${this.errorDiscreption}';
  }
}

class ConnectionTimedOut extends RequestError {
  ConnectionTimedOut([String errorDesc]) : super(errorDesc);

  @override
  String toString() {
    return 'Error Type: ConnectionTimedOut, ${this.errorDiscreption}';
  }
}

class UnkonwnError extends RequestError {
  UnkonwnError([String errorDesc]) : super(errorDesc);

  @override
  String toString() {
    return 'Error Type: UnkonwnError, ${this.errorDiscreption}';
  }
}
