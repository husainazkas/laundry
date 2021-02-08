import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry/model/order_details_model.dart';

class HistoryCard extends StatelessWidget {
  final List<OrderDetails> items;
  HistoryCard(this.items);

  final _numFormat = NumberFormat('#,###', 'id_ID');
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.0,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 3.0),
            child: InkWell(
              onTap: () {
                print('Tap!');
              },
              child: Container(
                padding: EdgeInsets.all(4.0),
                height: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items[index].service, textScaleFactor: 1.2),
                        Text('Rp ' + _numFormat.format(items[index].price),
                            textScaleFactor: 1.1),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(items[index].status),
                        Text(_dateFormat.format(items[index].startDate)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
