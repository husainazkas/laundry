import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/bloc/login_bloc.dart';
import 'package:laundry/ui/widget/circular_loading.dart';
import 'package:laundry/utils/validator.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginBloc _loginBloc = LoginBloc(LoginInitial());
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();

  AutovalidateMode _validationMode = AutovalidateMode.disabled;
  String _email, _pass;
  bool _obscurePass = true;

  @override
  void initState() {
    super.initState();
  }

  bool _validate() {
    final state = _formKey.currentState;
    if (state.validate()) {
      state.save();
      return true;
    }
    setState(() => _validationMode = AutovalidateMode.onUserInteraction);
    return false;
  }

  void login() {
    if (_validate()) {
      _loginBloc
        ..add(LoginEvent(_email, _pass))
        ..listen((state) {
          if (state is LoginFailure) {
            dialog('Upss..', state.error);
          } else if (state is LoginSuccess) {
            Navigator.pushNamedAndRemoveUntil(context, '/bottom_navbar', (r) => false);
          }
        });
    }
  }

  void dialog(String title, String body) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => _loginBloc,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: Center(
                        child: Text(
                          "Laundry",
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 52.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    forms(),
                  ],
                ),
              ),
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginInProgress) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: CircularLoading(state.status),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget forms() {
    return Form(
      key: _formKey,
      autovalidateMode: _validationMode,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Masuk',
              style: TextStyle(fontSize: 28.0),
            ),
          ),
          TextFormField(
            autocorrect: false,
            validator: (val) => val.isEmpty
                ? 'Email tidak boleh kosong.'
                : Validator.emailCheck(val)
                    ? null
                    : 'Email yang Anda masukkan salah.',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            focusNode: _emailNode,
            onFieldSubmitted: (val) {
              _emailNode.unfocus();
              FocusScope.of(context).requestFocus(_passNode);
            },
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            onSaved: (val) => _email = val.trim(),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            autocorrect: false,
            obscureText: _obscurePass,
            textInputAction: TextInputAction.done,
            focusNode: _passNode,
            onFieldSubmitted: (val) {
              _passNode.unfocus();
              login();
            },
            validator: (val) =>
                val.isNotEmpty ? null : 'Password tidak boleh kosong.',
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => setState(() {
                  _obscurePass = !_obscurePass;
                }),
                icon: Icon(
                  _obscurePass ? Icons.visibility_off : Icons.visibility,
                  color: _obscurePass ? Colors.grey : Colors.blue,
                ),
              ),
            ),
            onSaved: (val) => _pass = val,
          ),
          SizedBox(height: 12.0),
          FlatButton(
            height: 46.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.blue,
            onPressed: login,
            child: Center(
              child: Text(
                'Masuk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum memiliki akun? '),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  borderRadius: BorderRadius.circular(6.0),
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      'Daftar sekarang.',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
