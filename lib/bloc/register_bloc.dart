import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/injector/injector.dart';
import 'package:laundry/model/user_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterInProgress extends RegisterState {
  final String status;
  RegisterInProgress(this.status);
}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}

class RegisterEvent {
  final UserData userData;
  RegisterEvent(this.userData);
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('user-data');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RegisterBloc(RegisterState initialState) : super(initialState);

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    yield RegisterInProgress('Mendaftarkan akun Anda');

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: event.userData.email, password: event.userData.pass);

      yield RegisterInProgress('Menginput data Anda');

      await _firestore.add({
        'uid': credential.user.uid,
        'name': event.userData.name,
        'phone': event.userData.phone,
        'email': event.userData.email,
        'city': event.userData.city,
      });
    } catch (e) {
      print(e);
      yield RegisterFailure(e.toString());
      return;
    }
    await locator<SharedPreferences>().setBool('isAdmin', false);
    yield RegisterSuccess();
  }
}
