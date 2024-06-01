import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  bool isDeveloperMode = false;
  final ImagePicker _picker = ImagePicker();
  bool isTitleFilled = false;
  bool isEvent = false;

  @override
  void initState() {
    super.initState();
    _checkDeveloperMode();
  }

  Future<void> _checkDeveloperMode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots().listen((snapshot) {
        if (snapshot.data() != null) {
          setState(() {
            isDeveloperMode = snapshot.data()!['admin'] as bool? ?? false;
          });
        }
      });
    }
  }
  
  // Функция показа диалога добавления новости
  Future<void> _showAddNewsDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    String? uploadedImageUrl;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF023064),
          title: const Text('Добавить новость', style: TextStyle(color: Colors.white)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Введите заголовок',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        filled: true,
                        fillColor: Colors.blueGrey[900],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          isTitleFilled = value.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Введите основной текст',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        filled: true,
                        fillColor: Colors.blueGrey[900],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isTitleFilled
                          ? () async {
                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          File file = File(image.path);
                          try {
                            // Upload to Firebase Storage
                            String fileName = 'news_photos/${DateTime.now().millisecondsSinceEpoch.toString()}';
                            FirebaseStorage storage = FirebaseStorage.instance;
                            Reference ref = storage.ref().child(fileName);
                            UploadTask task = ref.putFile(file);
                            final snapshot = await task.whenComplete(() {});
                            final String url = await snapshot.ref.getDownloadURL();
                            print("Image URL: $url");
                            setState(() {
                              uploadedImageUrl = url;
                            });
                          } catch (e) {
                            print("Error uploading image: $e");
                          }
                        }
                      }
                          : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[700]),
                      child: const Text('Загрузить фотографию'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: isEvent,
                          onChanged: (bool? value) {
                            setState(() {
                              isEvent = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Мероприятие',
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.help, color: Colors.white),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF023064),
                                  title: const Text('Мероприятие', style: TextStyle(color: Colors.white)),
                                  content: const Text(
                                    'Отметьте этот флажок, если новость относится к мероприятию и на него можно будет записаться.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('ОК', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Сохранить', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
              onPressed: () {
                if (titleController.text.isNotEmpty && uploadedImageUrl != null) {
                  _addNews(titleController.text, contentController.text, uploadedImageUrl!, isEvent);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Функция добавления новости в базу данных
  void _addNews(String title, String content, String photoUrl, bool isEvent) {
    FirebaseFirestore.instance.collection('news').add({
      'title': title,
      'content': content,
      'photoUrl': photoUrl,
      'isEvent': isEvent,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Функция для показа изображения в полном размере
  void _showFullImage(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          body: Dismissible(
            key: Key(imageUrl),
            direction: DismissDirection.vertical,
            onDismissed: (direction) {
              Navigator.of(context).pop();
            },
            child: Center(
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                minScale: 0.1,
                maxScale: 4,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text(
                      'Не удалось загрузить изображение',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Функция показа диалога записи на мероприятие
  void _showRegistrationDialog(String eventTitle) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      String? fullName = userData['fullName'];
      String? squad = userData['squad'];
      String? email = user.email;

      if (fullName == null || fullName.isEmpty || squad == null || squad.isEmpty || email == null || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Заполните все данные в профиле.'),
          ),
        );
        return;
      }
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF023064),
            title: const Text('Запись на мероприятие', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Вы точно хотите записаться на это мероприятие?',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Отменить', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Да', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
                onPressed: () {
                  _registerForEvent(fullName, squad, email, eventTitle);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Функция записи на мероприятие
  void _registerForEvent(String fullName, String squad, String email, String eventTitle) {
    FirebaseFirestore.instance.collection('event_registrations').add({
      'fullName': fullName,
      'squad': squad,
      'email': email,
      'eventTitle': eventTitle,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) {
      setState(() {});  // Обновление состояния страницы
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Вы успешно записались на мероприятие.'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при записи: $error'),
        ),
      );
    });
  }

  // Функция проверки, записан ли пользователь на мероприятие
  Future<bool> _isUserRegistered(String eventTitle, String userEmail) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('event_registrations')
        .where('eventTitle', isEqualTo: eventTitle)
        .where('email', isEqualTo: userEmail)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Функция показа диалога удаления новости
  void _showDeleteDialog(String docId) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF023064),
          title:
          const Text('Удалить новость?', style: TextStyle(color: Colors.white)),
          content: const Text('Вы действительно хотите удалить запись?',
              style: TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Да', style: TextStyle(color: Colors.white, decoration: TextDecoration.none)),
              onPressed: () {
                _deleteNews(docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Функция удаления новости и показа Snackbar с возможностью отмены
  void _deleteNews(String docId) async {
    var docRef = FirebaseFirestore.instance.collection('news').doc(docId);
    var doc = await docRef.get();
    if (doc.exists) {
      Map<String, dynamic>? lastDeletedNews =
      doc.data();
      await docRef.delete();
      _showUndoSnackbar(docId, lastDeletedNews);
    }
  }

  // Функция показа Snackbar
  void _showUndoSnackbar(String docId, Map<String, dynamic>? lastDeletedNews) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 50,
          child: const Center(
            child: Text(
              "Вы успешно удалили запись",
              style: TextStyle(
                  fontSize: 16),
            ),
          ),
        ),
        action: SnackBarAction(
          label: "Отменить",
          onPressed: () => _undoDelete(docId, lastDeletedNews),
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // Функция восстановления удалённой новости
  void _undoDelete(String docId, Map<String, dynamic>? lastDeletedNews) {
    if (lastDeletedNews != null) {
      FirebaseFirestore.instance
          .collection('news')
          .doc(docId)
          .set(lastDeletedNews);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isDeveloperMode ? FloatingActionButton(
        onPressed: _showAddNewsDialog,
        backgroundColor: const Color(0xFFD24925),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('news').orderBy('timestamp', descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Center(child: Text('Произошла ошибка: ${snapshot.error}'));
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () => _showFullImage(data['photoUrl']),
                  onLongPress: isDeveloperMode ? () => _showDeleteDialog(document.id) : null,
                  child: Card(
                    margin: const EdgeInsets.all(12.0),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          data['photoUrl'],
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: const Text('Не удалось загрузить изображение'),
                          ),
                        ),
                        Container(
                          color: const Color(0xFF012E58),
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: data['isEvent'] == true ? 32.0 : 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      data['content'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (data['isEvent'] == true)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: FutureBuilder<bool>(
                                    future: _isUserRegistered(data['title'], FirebaseAuth.instance.currentUser!.email!),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      final isRegistered = snapshot.data ?? false;
                                      return TextButton(
                                        onPressed: isRegistered
                                            ? () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Вы уже записались на это мероприятие.'),
                                            ),
                                          );
                                        }
                                            : () => _showRegistrationDialog(data['title']),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white, backgroundColor: isRegistered ? Colors.grey : const Color(0xFFD24925),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          isRegistered ? 'Вы записаны' : 'Записаться',
                                          style: const TextStyle(
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),

    );
  }
}
