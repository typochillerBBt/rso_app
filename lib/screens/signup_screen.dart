import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theatre_app/services/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  TextEditingController passwordTextRepeatInputController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    passwordTextRepeatInputController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> signUp(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (passwordTextInputController.text !=
        passwordTextRepeatInputController.text) {
      SnackBarService.showSnackBar(context, 'Пароли должны совпадать', true);
      return;
    }

    try {
      // Создание нового пользователя
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );

      // Получение UID созданного пользователя
      String userId = userCredential.user!.uid;

      // Добавление данных пользователя в Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': emailTextInputController.text.trim(),
        'password': passwordTextInputController.text.trim(),
        'fullName': '', // ФИО
        'squad': '', // Отряд
        'birthDate': '', // Дата рождения
        'position': '', // Должность
        'admin': 'false'
      });

      // Переход на другую страницу после успешной регистрации
      Navigator.of(context).pushNamed('/stream');
      SnackBarService.showSnackBar(context, 'Регистрация успешна', false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(context, 'Такой Email уже используется, используйте другой Email или восстановите пароль', true);
      } else {
        SnackBarService.showSnackBar(context, 'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.', true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background
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
                      const SizedBox(height: 10),
                      TextField(
                        autocorrect: false,
                        controller: passwordTextRepeatInputController,
                        obscureText: isHiddenPassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.25),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: 'Подтверждение пароля',
                          errorText: passwordTextRepeatInputController
                                      .text.isNotEmpty &&
                                  passwordTextRepeatInputController
                                          .text.length < 8
                              ? 'Минимум 8 символов'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/login'),
                        child: const Text('Уже есть аккаунт? Авторизуйтесь'),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () => signUp(context),
                        child: const Text('Создать аккаунт'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
