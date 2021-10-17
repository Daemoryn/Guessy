import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Loading...",
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFFFFA450),
          ),
        ),
      ),
    );
  }
}
