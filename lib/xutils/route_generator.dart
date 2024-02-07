import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secchat/screens/chat_screen.dart';
import 'package:secchat/screens/home_screen.dart';
import 'package:secchat/screens/error_screen.dart';
import 'package:secchat/screens/login_screen.dart';
import 'package:secchat/screens/register_screen.dart';

import '../models/chat_slot_model.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/': //HomeScreen
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/login': //Login Screen
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register': //Register Screen
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/chat': //Chat Screen
        return MaterialPageRoute(
            builder: (_) => ChatScreen(doc: args as DocumentSnapshot));
      default: //Error Screen
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }
}
