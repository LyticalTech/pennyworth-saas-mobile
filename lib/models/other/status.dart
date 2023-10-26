class Success {
  int code;
  Object response;
  Success({this.code = 200, required this.response});
}

class Failure {
  String? code;
  Object? errorResponse;
  Failure({this.code, required this.errorResponse});
}