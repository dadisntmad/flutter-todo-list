import 'package:flutter/material.dart';
import 'package:todo/views/screens/home_screen.dart';
import 'package:todo/views/screens/signin_screen.dart';
import 'package:todo/views/screens/signup_screen.dart';

abstract class NavigationRoute {
  static const home = '/';
  static const signin = '/signin';
  static const signup = '/signup';
}

class Navigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationRoute.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case NavigationRoute.signin:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case NavigationRoute.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      default:
        const widget = Text('Navigation error!');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
