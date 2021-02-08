import 'package:flutter/material.dart';
import 'package:laundry/model/map_account_model.dart';

class AccountCard extends StatelessWidget {
  final MapAccount mapAccount;
  final bool editing;
  final List<TextFormField> editor;

  AccountCard(
    this.mapAccount,
    this.editing, {
    this.editor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mapAccount.key.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 42.0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mapAccount.key[index],
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 1.1,
              ),
              SizedBox(
                height: 4.0,
              ),
              !editing
                  ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                        mapAccount.value[index],
                        textScaleFactor: 1.15,
                      ),
                  )
                  : editor[index],
            ],
          ),
        );
      },
    );
  }
}
