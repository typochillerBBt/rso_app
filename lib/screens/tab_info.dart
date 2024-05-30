import 'package:flutter/material.dart';
import 'package:theatre_app/screens/InfoDetailPage/HistoryPage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'InfoDetailPage/AboutUsPage.dart';

class TabInfo extends StatelessWidget {
  const TabInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Калининградское региональное\nотделение МООО "РСО"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD24925),
              ),
            ),
            const SizedBox(height: 40),
            _buildRow(context, [
              _buildGridItem(
                context,
                icon: Icons.schedule,
                label: 'О нас',
                onTap: () => _navigateToPage(context, 'О нас'),
              ),
              _buildGridItem(
                context,
                icon: Icons.question_answer,
                label: 'История',
                onTap: () => _navigateToPage(context, 'История'),
              ),
              _buildGridItem(
                context,
                icon: Icons.mic,
                label: 'Проекты',
                onTap: () => _navigateToPage(context, 'Проекты'),
              ),
            ]),
            const SizedBox(height: 20),
            _buildRow(context, [
              _buildGridItem(
                context,
                icon: Icons.schedule,
                label: 'Структура',
                onTap: () => _navigateToPage(context, 'Структура'),
              ),
              _buildGridItem(
                context,
                icon: Icons.question_answer,
                label: 'Основные документы',
                onTap: () => _navigateToPage(context, 'Основные документы'),
              ),
              _buildGridItem(
                context,
                icon: Icons.mic,
                label: 'Контакты',
                onTap: () => _navigateToPage(context, 'Контакты'),
              ),
            ]),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () => _launchURL('https://vk.com/rso39?w=app6013442_-9737205%2523form_id%253D1'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFD24925),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 0,
                ),
                child: const Text(
                  'Вступить в отряд',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<Widget> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  Widget _buildGridItem(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFD24925).withOpacity(0.3),
            child: Icon(icon, size: 30, color: const Color(0xFFD24925)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFD24925), fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, String pageTitle) {
    Widget page;

    switch (pageTitle) {
      case 'О нас':
        page = const AboutUsPage();
        break;
      case 'История':
        page = const HistoryPage();
        break;
      default:
        page = InfoDetailPage(title: pageTitle);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }
}

class InfoDetailPage extends StatelessWidget {
  final String title;

  const InfoDetailPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF012E58),
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Content for $title',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}