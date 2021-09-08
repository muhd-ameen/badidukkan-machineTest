import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String? payload;

  const SecondPage({Key? key, this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    payload ?? '',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
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

