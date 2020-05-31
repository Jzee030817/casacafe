class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message]) : super(message, "Error: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Solicitud invalida: ");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([message]) : super(message, "No Autorizado: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message])
      : super(message, "Entrada Invalida: ");
}
