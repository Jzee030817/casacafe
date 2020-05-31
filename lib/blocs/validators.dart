import 'dart:async';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Email invalido.');
    }
  });

  final validatePassw = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 5) {
      sink.add(password);
    } else {
      sink.addError("Lomgitud minima 6 caracteres.");
    }
  });

  final validateNames =
      StreamTransformer<String, String>.fromHandlers(handleData: (names, sink) {
    if (names.length > 5) {
      sink.add(names);
    } else {
      sink.addError('Introduzca nombre y apellido');
    }
  });

  final validateName = StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 5 ) {
      sink.add(name);
    } else {
      sink.addError('Nombre escrito en la tarjeta');
    }
  });

  final validateNumber = StreamTransformer<String, String>.fromHandlers(handleData: (number, sink) {
    if (number.length == 16) {
      sink.add(number);
    } else {
      sink.addError('Introduzca 16 digitos de tarjeta');
    }
  });

  final validateMonthExp = StreamTransformer<String, String>.fromHandlers(handleData: (month, sink) {
    if (month.length == 2) {
      sink.add(month);
    } else {
      sink.addError('Mes de expiracion');
    }
  });

  final validateYearExp = StreamTransformer<String, String>.fromHandlers(handleData: (year, sink) {
    if (year.length == 2) {
      sink.add(year);
    } else {
      sink.addError('Año de expiracion');
    }
  });

  final validateCardCvc = StreamTransformer<String, String>.fromHandlers(handleData: (cvc, sink) {
    if (cvc.length == 3) {
      sink.add(cvc);
    } else {
      sink.addError('Codigo verificacion');
    }
  });
}
