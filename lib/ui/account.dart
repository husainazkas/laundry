import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/bloc/account_bloc.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final AccountBloc _accountBloc = AccountBloc(AccountInitial());

  @override
  void initState() {
    super.initState();
    _accountBloc.add(AccountEvent(AccountAction.getProfile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) => _accountBloc,
      child: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountInProgress) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: Center(
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            Navigator.pop(context);
          }
          if (state is AccountFailure) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Operasi ini gagal.'),
            ));
          } else if (state is AccountSuccess) {
            if (state.action == AccountAction.signOut) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (r) => false);
            } else if (state.action == AccountAction.getProfile) {
            } else if (state.action == AccountAction.updateProfile) {}
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400.0,
                        padding: EdgeInsets.all(14.0),
                        child: ListView.builder(
                          itemCount: 1,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              child: Text('sometext'),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            minWidth: 12.0,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(12.0),
                            onPressed: () => setState(() {}),
                            child: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 24.0),
                  child: FlatButton(
                    height: 46.0,
                    padding: EdgeInsets.symmetric(horizontal: 36.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    onPressed: () =>
                        _accountBloc.add(AccountEvent(AccountAction.signOut)),
                    color: Colors.redAccent[100],
                    child: Text(
                      'Keluar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
