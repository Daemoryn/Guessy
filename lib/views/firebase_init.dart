import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'loading.dart';
import 'my_error.dart';

class FirebaseInit extends StatelessWidget {
  FirebaseInit({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guessy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MyError(error: snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomePage();
          }
          return const Loading();
        },
      ),
    );
  }
}
