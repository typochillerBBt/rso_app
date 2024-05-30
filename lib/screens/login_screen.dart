import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theatre_app/services/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async {
    final navigator = Navigator.of(context);
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль. Повторите попытку',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
        return;
      }
    }
    navigator.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/rso_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo, field
          Padding(
            padding: const EdgeInsets.fromLTRB(36.0, 60.0, 36.0, 0.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/kro_logo.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        controller: emailTextInputController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.25),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: 'Электронная почта',
                          errorText: emailTextInputController.text.isNotEmpty &&
                                  !EmailValidator.validate(
                                      emailTextInputController.text)
                              ? 'Введите правильный Email'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        autocorrect: false,
                        controller: passwordTextInputController,
                        obscureText: isHiddenPassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.25),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: 'Пароль',
                          errorText: passwordTextInputController
                                      .text.isNotEmpty &&
                                  passwordTextInputController.text.length < 8
                              ? 'Минимум 8 символов'
                              : null,
                          suffixIcon: InkWell(
                            onTap: togglePasswordView,
                            child: Icon(
                              isHiddenPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/signup'),
                  child: const Text('Еще нет аккаунта? Зарегистрируйтесь'),
                ),
                TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/reset_password'),
                    child: const Text('Сбросить пароль')),
                const SizedBox(height: 25),
                ElevatedButton(onPressed: login, child: Text('Войти')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
