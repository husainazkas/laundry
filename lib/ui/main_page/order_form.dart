import 'package:flutter/material.dart';

class OrderForm extends StatefulWidget {
  final String orderType;
  OrderForm(this.orderType);

  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulir ' + widget.orderType),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
      ),
    );
  }
}
