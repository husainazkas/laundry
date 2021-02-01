import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {
  final String status;
  LoginInProgress(this.status);
}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final FirebaseAuthException error;
  LoginFailure(this.error);
}

class LoginEvent {
  final String email, pass;
  final bool isAdmin;
  LoginEvent(this.email, this.pass, this.isAdmin);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc(LoginState initialState) : super(initialState);

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    yield LoginInProgress('Mohon tunggu...');

    final notAllowed =
        FirebaseAuthException(code: 'login-not-allowed', message: 'Anda tidak memiliki izin untuk masuk. Harap hubungi administrator Anda.');

    if (!event.isAdmin && event.email == 'admin@mail.com') {
      yield LoginFailure(notAllowed);
      return;
    } else if (event.isAdmin && event.email != 'admin@mail.com') {
      yield LoginFailure(notAllowed);
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
          email: event.email, password: event.pass);
    } on FirebaseAuthException catch (e) {
      print(e);
      yield LoginFailure(e);
      return;
    }

    yield LoginSuccess();
  }
}
