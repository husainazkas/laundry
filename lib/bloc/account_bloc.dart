import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/storage/storage.dart';
import 'package:laundry/model/user_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountInProgress extends AccountState {
  final String status;
  AccountInProgress(this.status);
}

class AccountSuccess extends AccountState {
  final UserData data;
  AccountSuccess(this.data);
}

class AccountFailure extends AccountState {
  final String error;
  AccountFailure(this.error);
}

class AccountEvent {
  final bool editing;
  final List<String> value;
  AccountEvent({this.editing = false, this.value});
}

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('user-data');
  final SharedPreferences _sharedPreferences = locator<SharedPreferences>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AccountBloc(AccountState initialState) : super(initialState);

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    yield AccountInProgress('Logging out...');
    UserData userData;

    if (event.editing) {
      userData = UserData(
        name: event.value[0],
        phone: event.value[1],
        email: event.value[2],
      );

      try {
        if (_auth.currentUser.email != userData.email) {
          await _auth.currentUser.updateEmail(userData.email);
        }

        final doc = await _firestore
            .where('uid', isEqualTo: _auth.currentUser.uid)
            .get();
        await doc.docs.single.reference
            .update(userData.toJson()..remove(keyDriver));

        _sharedPreferences.setString(keyName, userData.name);
        _sharedPreferences.setString(keyPhone, userData.phone);
        _sharedPreferences.setString(keyEmail, userData.email);
      } catch (e) {
        yield AccountFailure(e.toString());
        return;
      }
    } else {
      try {
        await _auth.signOut();
        await _sharedPreferences.clear();
      } on FirebaseAuthException catch (e) {
        yield AccountFailure(e.message);
        return;
      }
    }

    yield AccountSuccess(userData);
  }
}
