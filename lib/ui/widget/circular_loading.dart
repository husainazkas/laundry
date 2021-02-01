import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  final String status;
  CircularLoading([this.status]);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Text(
              status ?? 'Mohon menunggu...',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
