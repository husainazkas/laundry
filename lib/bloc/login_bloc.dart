import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/injector/injector.dart';
import 'package:laundry/model/user_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {
  final String status;
  LoginInProgress(this.status);
}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LoginEvent {
  final String email, pass;
  LoginEvent(this.email, this.pass);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferences _storage = locator<SharedPreferences>();
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('user-data');

  LoginBloc(LoginState initialState) : super(initialState);

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    yield LoginInProgress('Mohon tunggu...');
    UserCredential credential;

    try {
      credential = await _auth.signInWithEmailAndPassword(
          email: event.email, password: event.pass);
    } on FirebaseAuthException catch (e) {
      print(e);
      yield LoginFailure(e.message);
      return;
    }

    yield LoginInProgress('Mengunduh data Anda');

    final snapshot =
        await _firestore.where('uid', isEqualTo: credential.user.uid).get();

    final data = snapshot.docs.single.data();
    if (data.isEmpty) {
      yield LoginFailure(
          'Maaf, terjadi kesalahan. Harap hubungi administrator Anda.');
      return;
    }

    final userData = UserData.fromJson(data);
    await _storage.setString('name', userData.name);
    await _storage.setString('email', userData.email);
    await _storage.setString('phone', userData.phone);
    await _storage.setBool('isDriver', userData.isDriver);

    yield LoginSuccess();
  }
}
