import 'package:flutter/material.dart';
import 'package:todo/views/screens/signin_screen.dart';
import 'package:todo/views/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignUpScreen(),
        '/signin': (context) => const SignInScreen(),
      },
    );
  }
}
