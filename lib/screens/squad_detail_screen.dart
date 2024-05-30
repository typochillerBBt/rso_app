import 'package:flutter/material.dart';

class SquadDetailScreen extends StatelessWidget {
  final String name;
  final String logoUrl;
  final String description;  // Добавленный параметр для описания

  const SquadDetailScreen({
    Key? key,
    required this.name,
    required this.logoUrl,
    required this.description  // Инициализация параметра
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/rso_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.only(top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipOval(
                child: Image.network(
                  logoUrl,
                  height: 96,
                  width: 96,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFD24925),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(right: 24, left: 24, bottom: 80, top: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      description,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        backgroundColor: const Color(0xFFD24925),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
