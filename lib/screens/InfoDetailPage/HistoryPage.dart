import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

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
              'История',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Началом Движения студенческих отрядов считается 1959 год, когда 339 студентов-добровольцев физического факультета Московского государственного университета имени М.В. Ломоносова во время летних каникул отправились в Казахстан, на целину. В совхозах Северо-Казахстанской области они построили 16 объектов. В следующем году в строительстве участвовало уже 520 студентов МГУ.\n\nВ 1960 году студенты построили первую улицу в совхозе «Булаевский» Северо-Казахстанской области. В стройке участвовало 520 студентов МГУ. Было принято решение назвать улицу Университетской.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Image.asset('assets/about_us/history1.jpg'),
            const SizedBox(height: 16),
            const Text(
              '1961 год',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'В студенческих отрядах трудилось уже около 1000 бойцов. В этом году у студенческого движения, занимавшегося строительными работами, появился свой печатный орган — газета «Молодой целинник».\n\nПри студенческом отряде Первого Московского государственного медицинского университета имени И.М. Сеченова был впервые организован пионерский лагерь «Спутник». Это событие положило начало целой традиции, и со временем такие лагеря стали появляться в других регионах СССР.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}