import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: LandingPage(
        auth: Auth(),
      ),
    );
  }
}
