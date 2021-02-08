import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/bloc/register_bloc.dart';
import 'package:laundry/model/user_data_model.dart';
import 'package:laundry/ui/widget/circular_loading.dart';
import 'package:laundry/utils/validator.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final RegisterBloc _registerBloc = RegisterBloc(RegisterInitial());
  final TextEditingController _passText = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode1 = FocusNode();
  final FocusNode _passNode2 = FocusNode();
  final _userData = UserData(isDriver: false);

  AutovalidateMode _validationMode = AutovalidateMode.disabled;
  bool _agree = false;
  String _pass;

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

  void register() {
    if (_validate()) {
      _registerBloc
        ..add(RegisterEvent(_userData, _pass))
        ..listen((state) {
          if (state is RegisterFailure) {
            if (state.error.contains('email-already-in-use')) {
              dialog('Gagal Mendaftar',
                  'Email yang Anda masukkan sudah digunakan.');
            }
            dialog('Kesalahan', 'Harap coba lagi nanti.');
          } else if (state is RegisterSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/bottom_navbar', (r) => false);
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
      body: BlocProvider<RegisterBloc>(
        create: (context) => _registerBloc,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _validationMode,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Mendaftar',
                          style: TextStyle(fontSize: 28.0),
                        ),
                      ),
                      name(),
                      SizedBox(height: 12.0),
                      phone(),
                      SizedBox(height: 12.0),
                      email(),
                      SizedBox(height: 12.0),
                      pass(),
                      SizedBox(height: 12.0),
                      confirm(),
                      agreement(),
                      btnRegister(),
                      backToLogin(),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                if (state is RegisterInProgress) {
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

  Widget name() {
    return TextFormField(
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'Nama tidak boleh kosong.' : null,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      focusNode: _nameNode,
      onFieldSubmitted: (val) {
        _nameNode.unfocus();
        FocusScope.of(context).requestFocus(_phoneNode);
      },
      decoration: InputDecoration(
        labelText: 'Nama lengkap',
        border: OutlineInputBorder(),
      ),
      onSaved: (val) => _userData.name = val.trim(),
    );
  }

  Widget phone() {
    return TextFormField(
      autocorrect: false,
      validator: (val) => val.isEmpty
          ? 'Nomor telepon tidak boleh kosong.'
          : val.length >= 9 && val.length < 15
              ? null
              : 'Nomor yang Anda masukkan salah.',
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      focusNode: _phoneNode,
      onFieldSubmitted: (val) {
        _phoneNode.unfocus();
        FocusScope.of(context).requestFocus(_emailNode);
      },
      decoration: InputDecoration(
        labelText: 'Nomor ponsel',
        border: OutlineInputBorder(),
      ),
      onSaved: (val) => _userData.phone = val.trim(),
    );
  }

  Widget email() {
    return TextFormField(
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
        FocusScope.of(context).requestFocus(_passNode1);
      },
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      onSaved: (val) => _userData.email = val.trim(),
    );
  }

  Widget pass() {
    return TextFormField(
      autocorrect: false,
      controller: _passText,
      obscureText: true,
      textInputAction: TextInputAction.next,
      focusNode: _passNode1,
      onFieldSubmitted: (val) {
        _passNode1.unfocus();
        FocusScope.of(context).requestFocus(_passNode2);
      },
      validator: (val) => val.isEmpty
          ? 'Kata sandi tidak boleh kosong.'
          : val.length >= 6
              ? null
              : 'Kata sandi harus 6 karakter atau lebih.',
      decoration: InputDecoration(
        labelText: 'Kata sandi',
        border: OutlineInputBorder(),
      ),
      onSaved: (val) => _pass = val,
    );
  }

  Widget confirm() {
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: _passNode2,
      onFieldSubmitted: (val) {
        _passNode2.unfocus();
        if (_agree) register();
      },
      validator: (val) =>
          val == _passText.text ? null : 'Kata sandi tidak cocok.',
      decoration: InputDecoration(
        labelText: 'Konfirmasi kata sandi',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget agreement() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Checkbox(
            value: _agree,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (bool value) => setState(() => _agree = value),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  'Dengan ini menyetujui kebijakan kami.',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              onTap: () => setState(() => _agree = !_agree),
            ),
          ),
        ],
      ),
    );
  }

  Widget btnRegister() {
    return FlatButton(
      height: 46.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Colors.blue,
      disabledColor: Colors.blue[200],
      onPressed: _agree ? register : null,
      child: Center(
        child: Text(
          'Daftar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget backToLogin() {
    return Container(
      padding: EdgeInsets.only(top: 12.0),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          padding: EdgeInsets.all(2.0),
          child: Text(
            'Sudah memiliki akun? Masuk untuk melanjutkan.',
          ),
        ),
      ),
    );
  }
}
