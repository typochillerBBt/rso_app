import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String fullName = '';
  String squad = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    setState(() {
      fullName = userData['fullName'] ?? '';
      squad = userData['squad'] ?? '';
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }


  Future<void> updateUserProfile(
      String fullName, String squad, String birthDate, String position) async {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'fullName': fullName,
      'squad': squad,
      'birthDate': birthDate,
      'position': position,
    });
    loadUserData(); // Reload user data to reflect changes
  }

  Future<void> showEditDialog() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    TextEditingController fullNameController =
    TextEditingController(text: userData['fullName']);
    TextEditingController squadController =
    TextEditingController(text: userData['squad']);
    TextEditingController birthDateController =
    TextEditingController(text: userData['birthDate']);
    TextEditingController positionController =
    TextEditingController(text: userData['position']);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF023064),
          title: const Text('Редактировать профиль',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    hintText: "ФИО",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.blueGrey[900],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: squadController,
                  decoration: InputDecoration(
                    hintText: "Отряд",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.blueGrey[900],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: birthDateController,
                  decoration: InputDecoration(
                    hintText: "Дата рождения",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.blueGrey[900],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: positionController,
                  decoration: InputDecoration(
                    hintText: "Должность",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    filled: true,
                    fillColor: Colors.blueGrey[900],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
              const Text('Отменить', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Сохранить',
                  style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
              onPressed: () {
                updateUserProfile(
                  fullNameController.text,
                  squadController.text,
                  birthDateController.text,
                  positionController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012E58),
      appBar: AppBar(
        backgroundColor: const Color(0xFF012E58),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => showEditDialog(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        backgroundColor: const Color(0xFFD24925),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/kro_logo.png', height: 148, width: 148),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                  right: 24, left: 24, bottom: 20, top: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFF012E58),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    squad,
                    style:
                    const TextStyle(fontSize: 16, color: Color(0xFF012E58)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.feedback_outlined, color: Color(0xFF012E58)),
                      label: const Text('Обратная связь', style: TextStyle(color: Color(0xFF012E58), decoration: TextDecoration.none)),
                      onPressed: () => _launchURL('https://forms.yandex.ru/u/6658c71df47e7311a08f86c3/'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.settings_outlined, color: Color(0xFF012E58)),
                      label: const Text('Настройки', style: TextStyle(color: Color(0xFF012E58), decoration: TextDecoration.none)),
                      onPressed: () {
                        // Действие при нажатии на кнопку
                      },
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: signOut,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFD24925),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text('Выйти из аккаунта',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}