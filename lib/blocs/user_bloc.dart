import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../models/creditcard_model.dart';
import '../models/pedido_model.dart';
import '../resources/repository.dart';
import '../models/user_model.dart';
import '../resources/api_response.dart';
import 'validators.dart';

class UserBloc extends Object with Validators {
  final _repository = Repository();
  // Formulario de login
  final _email = BehaviorSubject<String>();
  final _passw = BehaviorSubject<String>();
  final _names = BehaviorSubject<String>();

  // Formulario cambio de password
  final _cpold = BehaviorSubject<String>();
  final _cpnew = BehaviorSubject<String>();
  final _cpcnf = BehaviorSubject<String>();

  // Formulario datos de tarjeta de credito
  final _nameoncard = BehaviorSubject<String>();
  final _cardnumber = BehaviorSubject<String>();
  final _cardmonthd = BehaviorSubject<String>();
  final _cardyeardu = BehaviorSubject<String>();
  final _cvconcard = BehaviorSubject<String>();

  Stream<String> get emailstream => _email.stream.transform(validateEmail);
  Stream<String> get passwstream => _passw.stream.transform(validatePassw);
  Stream<String> get namesstream => _names.stream.transform(validateNames);

  Stream<String> get pwdchangeOld => _cpold.stream.transform(validatePassw);
  Stream<String> get pwdchangeNew => _cpnew.stream.transform(validatePassw);
  Stream<String> get pwdchangeConf => _cpcnf.stream.transform(validatePassw);

  Stream<String> get nameoncardstr => _nameoncard.stream.transform(validateName);
  Stream<String> get cardnumberstr => _cardnumber.stream.transform(validateNumber);
  Stream<String> get cardmonthdstr => _cardmonthd.stream.transform(validateMonthExp);
  Stream<String> get cardyeardustr => _cardyeardu.stream.transform(validateYearExp);
  Stream<String> get cvconcardstrm => _cvconcard.stream.transform(validateCardCvc);

  Stream<bool> get submitLoginValid =>
      Observable.combineLatest2(emailstream, passwstream, (e, p) => true);
  Stream<bool> get submitSignupValid =>
      Observable.combineLatest2(namesstream, namesstream, (e, p) => true);
  Stream<bool> get submitChangeValid => 
      Observable.combineLatest3(pwdchangeOld, pwdchangeNew, pwdchangeConf, (e, p, c) => true);
  Stream<bool> get submitCardData =>
      Observable.combineLatest5(nameoncardstr, cardnumberstr, cardmonthdstr, cardyeardustr, cvconcardstrm, (a, b, c, d, e) => true);

  // Change the data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassw => _passw.sink.add;
  Function(String) get changeNames => _names.sink.add;

  Function(String) get changeOldpwd => _cpold.sink.add;
  Function(String) get changeNewpwd => _cpnew.sink.add;
  Function(String) get changeConfpwd => _cpcnf.sink.add;

  Function(String) get changeCardName => _nameoncard.sink.add;
  Function(String) get changeCardNumb => _cardnumber.sink.add;
  Function(String) get changeCardMont => _cardmonthd.sink.add;
  Function(String) get changeCardYear => _cardyeardu.sink.add;
  Function(String) get changeCardCvc => _cvconcard.sink.add;

  // Datos de sesion
  final _isess = PublishSubject<ApiResponse<UserModel>>();
  final _osess = BehaviorSubject<ApiResponse<UserModel>>();
  final _ichpw = PublishSubject<ApiResponse<PedidoResult>>();
  final _ochpw = BehaviorSubject<ApiResponse<PedidoResult>>();
  final _iccdt = PublishSubject<CreditCardModel>();
  final _occdt = BehaviorSubject<CreditCardModel>();

  Observable<ApiResponse<UserModel>> get sessionStream => _osess.stream;
  Observable<ApiResponse<PedidoResult>> get changepwdStream => _ochpw.stream;
  Observable<CreditCardModel> get ccdataStream => _occdt.stream;

  // Getters a sinks
  UserBloc() {
    _isess.stream.pipe(_osess);
    _ichpw.stream.pipe(_ochpw);
    _iccdt.stream.pipe(_occdt);
  }

  dispose() {
    _email.close();
    _passw.close();
    _names.close();
    _isess.close();
    _osess.close();
    _ichpw.close();
    _ochpw.close();

    _cpold.close();
    _cpnew.close();
    _cpcnf.close();

    _nameoncard.close();
    _cardnumber.close();
    _cardmonthd.close();
    _cardyeardu.close();
    _cvconcard.close();

    _iccdt.close();
    _occdt.close();
  }

  submitCCData(String _ccname, String _ccnumber, String _ccmonth, String _ccyear, String _cccvc) {
    _iccdt.sink.add(CreditCardModel(cardNumber: _ccnumber, nameOnCard: _ccname, monthDue: _ccmonth, yearDue: _ccyear, cvcOnCard: _cccvc));
  }

  getSessionData(String _idUser, String _pwd) async {
    _isess.sink.add(ApiResponse.loading('Autenticando...'));
    try {
      UserModel user = await _repository.getSessionData(_idUser, _pwd);
      _isess.sink.add(ApiResponse.completed(user));
    } catch (e) {
      _isess.sink.add(ApiResponse.error(e.toString()));
    }
  }

  submitPwdReset(String _email) {
    _repository.resetPassword(_email);
  }

  submitLogin(validEmail, validPassw) {
    getSessionData(validEmail, validPassw);
  }

  submitChangePwd(String userId, String sesionId, String oldPwd, String newPwd) async {
    _ichpw.sink.add(ApiResponse.loading('...'));
    try {
      PedidoResult res = await _repository.changePassword(userId, sesionId, oldPwd, newPwd);
      _ichpw.sink.add(ApiResponse.completed(res));
    } catch (e) {
      _ichpw.sink.add(ApiResponse.error(e.toString()));
    }
  }

  submitSignup(validEmail, validNames) async {
    _isess.sink.add(ApiResponse.loading('...'));
    try {
      UserModel user = await _repository.getSignupData(validEmail, validNames);
      _isess.sink.add(ApiResponse.completed(user));
    } catch (e) {
      _isess.sink.add(ApiResponse.error(e.toString()));
    }
  }

  restoreSession() async {
    _isess.sink.add(ApiResponse.loading('...'));
    try {
      UserModel user = await _repository.restoreSession();
      _isess.sink.add(ApiResponse.completed(user));
    } catch (e) {
      _isess.sink.add(ApiResponse.error(e.toString()));
    }
  }

  closeSession() async {
    await _repository.closeSession();
    restoreSession();
  }
}
