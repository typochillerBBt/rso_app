import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theatre_app/screens/tab_info.dart';
import 'package:theatre_app/screens/tab_news.dart';
import 'package:theatre_app/screens/account_screen.dart';
import 'package:theatre_app/screens/login_screen.dart';
import 'package:theatre_app/constants.dart';
import 'package:theatre_app/screens/tab_squads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isFabOpen = false;
  bool isDeveloperMode = false;
  late PageController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _tabController.addListener(() {
      setState(() {}); // вызов setState при изменении вкладки
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadDeveloperModeStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        isDeveloperMode = userData['admin'] ?? false;
      });
    }
  }

  Future<void> updateDeveloperModeStatus(bool status) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'admin': status});
      setState(() {
        isDeveloperMode = status;
      });
    }
  }

  Future<void> showAdminDialog() async {
    TextEditingController loginController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF023064),
          title: const Text('Панель управления', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (!isDeveloperMode) ...[
                  TextField(
                    controller: loginController,
                    decoration: InputDecoration(
                      hintText: 'Логин',
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
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.blueGrey[900],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  isDeveloperMode ? "Вы в режиме администратора" : "Вы не вошли в режим администратора",
                  style: TextStyle(
                    color: isDeveloperMode ? Colors.green : Colors.red,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            if (!isDeveloperMode)
              TextButton(
                child: const Text('Войти', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
                onPressed: () {
                  if (loginController.text == 'admin' && passwordController.text == 'admin') {
                    updateDeveloperModeStatus(true).then((_) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Вы успешно вошли в режим администратора.'),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    });
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Введенные данные неверны.'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            if (isDeveloperMode)
              TextButton(
                child: const Text('Выйти', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
                onPressed: () {
                  updateDeveloperModeStatus(false).then((_) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Вы вышли из режима администратора.'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  });
                },
              ),
          ],
        );
      },
    );
  }

  Widget buildTabIcon(int index, String activeIcon, String inactiveIcon) {
    return Image.asset(
      _tabController.index == index ? activeIcon : inactiveIcon,
      height: 24,
      width: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Труд-Крут!', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColorBlue,
        leading: GestureDetector(
          onLongPress: showAdminDialog,
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Image.asset('assets/kro_logo.png'),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.white54,
          labelColor: primaryColorWhite,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          tabs: const [
            Tab(icon: Icon(Icons.event), text: "Мероприятия"),
            Tab(icon: Icon(Icons.public), text: "О нас"),
            Tab(icon: Icon(Icons.group), text: "Отряды"),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              if (user == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountScreen(),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.person,
              color: user == null ? primaryColorOrange : Colors.green,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/kro_bg_white.png',
              fit: BoxFit.cover,
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              _tabController.animateTo(index);
            },
            children: const [
              NewsTab(),
              TabInfo(),
              TabSquads(),
            ],
          ),
        ],
      ),
    );
  }
}