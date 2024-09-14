class AppException implements Exception {
  final String message, prefix, url;

  AppException(this.message, this.prefix, this.url);
}

class BadRequestException extends AppException {
  BadRequestException(String decode, String string,
      {String? message, String? url})
      : super(message!, "Bad Request", url!);
}

class FetchDataException extends AppException {
  FetchDataException(String s, String string, {String? message, String? url})
      : super(message!, "Bad Request", url!);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException(String s, String string,
      {String? message, String? url})
      : super(message!, "Bad Request", url!);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException(String decode, String string,
      {String? message, String? url})
      : super(message!, "Bad Request", url!);
}
