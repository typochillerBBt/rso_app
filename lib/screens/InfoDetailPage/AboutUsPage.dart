import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'О нас',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Молодежная общероссийская общественная организация «Российские Студенческие Отряды» (РСО) – крупнейшая молодежная организация страны, которая обеспечивает временной трудовой занятостью более 240 тысяч молодых людей из 74 субъектов РФ, а также занимается гражданским и патриотическим воспитанием, развивает творческий и спортивный потенциал молодежи. Датой начала развития движения современных студенческих отрядов следует считать 17 февраля 2004 года, когда в Москве в Государственном Кремлевском Дворце был проведен Всероссийский форум студенческих отрядов, посвященный 45-летию движения студенческих отрядов Российской Федерации.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Image.asset('assets/about_us/about_us1.jpg'),
            const SizedBox(height: 16),
            const Text(
              'Основные задачи деятельности отрядов:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Содействие временному и постоянному трудоустройству студентов и выпускников учебных заведений;\n2. Привлечение учащейся молодежи к участию в трудовой деятельности;\n3. Патриотическое воспитание молодежи, поддержка и развитие традиций движения студенческих отрядов, культурная и социально-значимая работа среди населени;\n4. Содействие в формировании кадрового резерва для различных отраслей экономики Российской Федерации.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}