import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/bloc/account_bloc.dart';
import 'package:laundry/model/map_account_model.dart';
import 'package:laundry/storage/storage.dart';
import 'package:laundry/ui/widget/account_card.dart';
import 'package:laundry/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final AccountBloc _accountBloc = AccountBloc(AccountInitial());
  final SharedPreferences _storage = locator<SharedPreferences>();

  MapAccount _mapAccount = MapAccount(
    key: List.from([
      'Nama',
      'No. Telp',
      'Email',
    ], growable: false),
    value: List(3),
  );

  bool _editing = false;
  List<String> _tempUpdates = [];
  AutovalidateMode _avm = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _mapAccount.value.setAll(0, [
      _storage.getString(keyName),
      _storage.getString(keyPhone),
      _storage.getString(keyEmail),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun Anda'),
        centerTitle: true,
      ),
      body: BlocProvider<AccountBloc>(
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
              if (state is AccountFailure) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Operasi ini gagal.'),
                ));
              } else if (state is AccountSuccess) {
                if (state.data == null) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (r) => false);
                  return;
                }
                _tempUpdates.clear();
                setState(() {
                  _mapAccount.value.setAll(0, [
                    state.data.name,
                    state.data.phone,
                    state.data.email,
                  ]);
                });
              }
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
                    child: Form(
                      key: _key,
                      autovalidateMode: _avm,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 400.0,
                            padding: EdgeInsets.all(14.0),
                            child: AccountCard(
                              _mapAccount,
                              _editing,
                              editor: List.generate(_mapAccount.key.length,
                                  (index) {
                                final List<TextInputType> inputType = [
                                  TextInputType.name,
                                  TextInputType.phone,
                                  TextInputType.emailAddress
                                ];

                                final List<FocusNode> node = [
                                  FocusNode(),
                                  FocusNode(),
                                  FocusNode(),
                                ];

                                return TextFormField(
                                  initialValue: _tempUpdates.isNotEmpty
                                      ? _tempUpdates[index]
                                      : _mapAccount.value[index],
                                  validator: (val) => val.isEmpty
                                      ? '${_mapAccount.key[index]} tidak boleh kosong.'
                                      : _mapAccount.key[index] == 'Email' &&
                                              !Validator.emailCheck(val)
                                          ? 'Email yang Anda masukkan salah.'
                                          : null,
                                  keyboardType: inputType[index],
                                  focusNode: node[index],
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (val) =>
                                      node[index].unfocus(),
                                  onSaved: (val) =>
                                      _tempUpdates.add(val.trim()),
                                );
                              }),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (_editing)
                                FlatButton(
                                  minWidth: 12.0,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(12.0),
                                  onPressed: () =>
                                      setState(() => _editing = !_editing),
                                  child: Icon(Icons.close),
                                ),
                              FlatButton(
                                minWidth: 12.0,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12.0),
                                onPressed: () {
                                  if (_editing) {
                                    if (_key.currentState.validate()) {
                                      _key.currentState.save();
                                      _accountBloc.add(AccountEvent(
                                        editing: true,
                                        value: _tempUpdates,
                                      ));
                                      setState(() => _editing = !_editing);
                                    } else {
                                      _avm = AutovalidateMode.onUserInteraction;
                                    }
                                  } else {
                                    setState(() => _editing = !_editing);
                                  }
                                },
                                child:
                                    Icon(_editing ? Icons.check : Icons.edit),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 24.0),
                    child: FlatButton(
                      height: 46.0,
                      padding: EdgeInsets.symmetric(horizontal: 36.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () => _accountBloc.add(AccountEvent()),
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
      ),
    );
  }
}
