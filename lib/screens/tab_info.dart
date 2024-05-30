import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              'Молодежная общероссийская общественная организация «Российские Студенческие Отряды»',
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
                icon: Icons.people,
                label: 'О нас',
                onTap: () => _launchURL(
                    'https://трудкрут.рф/o_rossiyskikh_studencheskikh_otryadakh.html'),
              ),
              _buildGridItem(
                context,
                icon: Icons.history,
                label: 'История',
                onTap: () =>
                    _launchURL('https://трудкрут.рф/about_us/istoriya.html'),
              ),
              _buildGridItem(
                context,
                icon: Icons.eco,
                label: 'Проекты',
                onTap: () => _launchURL(
                    'https://трудкрут.рф/deyatelnost/sotsialnye_proekty.html'),
              ),
            ]),
            const SizedBox(height: 20),
            _buildRow(context, [
              _buildGridItem(
                context,
                icon: Icons.construction,
                label: 'Структура',
                onTap: () => _launchURL(
                    'https://трудкрут.рф/about_us/rukovodyashchie_organy.html'),
              ),
              _buildGridItem(
                context,
                icon: Icons.document_scanner,
                label: 'Основные документы',
                onTap: () =>
                    _launchURL('https://трудкрут.рф/about_us/dokumenty.html'),
              ),
              _buildGridItem(
                context,
                icon: Icons.contact_page,
                label: 'Контакты',
                onTap: () => _launchURL(
                    'https://трудкрут.рф/kontakty/map/szfo/kaliningradskaya-oblast'),
              ),
            ]),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () => _launchURL('https://vk.com/rso39'),
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
