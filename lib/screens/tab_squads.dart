import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:theatre_app/screens/SquadDetailScreen.dart';

class TabSquads extends StatelessWidget {
  const TabSquads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('squads')
            .orderBy('category')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          Map<String, List<DocumentSnapshot>> squadsByCategory = {};
          for (DocumentSnapshot doc in snapshot.data!.docs) {
            String category = doc['category'] as String;
            if (!squadsByCategory.containsKey(category)) {
              squadsByCategory[category] = [];
            }
            squadsByCategory[category]!.add(doc);
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: squadsByCategory.entries.expand((entry) {
              List<Widget> widgets = [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD24925),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ];

              List<DocumentSnapshot> sortedSquads = entry.value
                ..sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

              widgets.addAll(
                sortedSquads.map((doc) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SquadDetailScreen(
                          name: doc['name'],
                          logoUrl: doc['logoUrl'],
                          description: doc['description'] ?? 'Описание отсутствует', // Проверка наличия описания
                        ),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF012E58),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(doc['logoUrl']),
                          radius: 24,
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(
                          doc['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
              return widgets;
            }).toList(),
          );
        },
      ),
    );
  }
}
