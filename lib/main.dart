import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:theatre_app/screens/account_screen.dart';
import 'package:theatre_app/screens/home_screen.dart';
import 'package:theatre_app/screens/login_screen.dart';
import 'package:theatre_app/screens/reset_password_screen.dart';
import 'package:theatre_app/screens/signup_screen.dart';
import 'package:theatre_app/screens/verify_email_screen.dart';
import 'package:theatre_app/services/firebase_streem.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'CustomButtonsTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomButtonsTheme.lightTheme,
      darkTheme: CustomButtonsTheme.darkTheme,
      themeMode: ThemeMode.light,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/stream': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
      },
      initialRoute: '/stream',
    );
  }
}
