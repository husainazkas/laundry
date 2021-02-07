import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/injector/injector.dart';
import 'package:laundry/model/user_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AccountAction { getProfile, updateProfile, signOut }

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountInProgress extends AccountState {
  final String status;
  AccountInProgress(this.status);
}

class AccountSuccess extends AccountState {
  final AccountAction action;
  final UserData data;
  AccountSuccess(this.action, {this.data});
}

class AccountFailure extends AccountState {
  final String error;
  AccountFailure(this.error);
}

class AccountEvent {
  final AccountAction action;
  final UserData userData;
  AccountEvent(this.action, {this.userData});
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

    switch (event.action) {
      case AccountAction.getProfile:
        final snapshot = await _firestore
            .where('uid', isEqualTo: _auth.currentUser.uid)
            .get();

        final userData = UserData.fromJson(snapshot.docs.single.data());
        yield AccountSuccess(event.action, data: userData);
        break;
      case AccountAction.updateProfile:
        break;
      case AccountAction.signOut:
        try {
          await _auth.signOut();

          await _sharedPreferences.clear();
          yield AccountSuccess(event.action);
        } on FirebaseAuthException catch (e) {
          yield AccountFailure(e.toString());
          return;
        }
        break;
    }
  }
}
