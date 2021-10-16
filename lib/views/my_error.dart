import 'package:flutter/material.dart';

class MyError extends StatelessWidget {
  late String _error;

  MyError({Key? key, required String error}) : super(key: key) {
    _error = error;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Error: $_error'),
    );
  }
}
