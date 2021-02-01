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
  AccountSuccess(this.action);
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
  final SharedPreferences _sharedPreferences = locator<SharedPreferences>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AccountBloc(AccountState initialState) : super(initialState);

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    yield AccountInProgress('Logging out...');

    final action = event.action;

    if (action == AccountAction.getProfile) {
      await Future.delayed(Duration(seconds: 1));
    } else if (action == AccountAction.updateProfile) {
    } else if (action == AccountAction.signOut) {
      try {
        await _auth.signOut();

        await _sharedPreferences.clear();
        await _sharedPreferences.setBool('isAdmin', false);
      } on FirebaseAuthException catch (e) {
        yield AccountFailure(e.toString());
        return;
      }
    }

    yield AccountSuccess(action);
    return;
  }
}
