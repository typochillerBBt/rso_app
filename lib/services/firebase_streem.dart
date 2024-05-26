import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theatre_app/screens/home_screen.dart';
import 'package:theatre_app/screens/login_screen.dart';
import 'package:theatre_app/screens/verify_email_screen.dart';

class FirebaseStream extends StatelessWidget {
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
              body: Center(child: Text('Что-то пошло не так!')));
        } else if (snapshot.hasData) {
          if (!snapshot.data!.emailVerified) {
            // Перенаправление на страницу подтверждения email, если email не подтвержден
            return const VerifyEmailScreen();
          }
          // Перенаправление на главный экран, если пользователь вошел в систему и email подтвержден
          return const HomeScreen();
        } else {
          // Перенаправление на экран входа, если пользователь не вошел в систему
          return const LoginScreen();
        }
      },
    );
  }
}
