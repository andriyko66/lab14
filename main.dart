import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('native_channel');
  String nativeText = 'Немає даних';
  File? imageFile;

  Future<void> getNativeText() async {
    try {
      final String result = await platform.invokeMethod('getStaticText');
      setState(() {
        nativeText = result;
      });
    } on PlatformException catch (e) {
      nativeText = "Помилка: ${e.message}";
    }
  }

  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Нативні можливості')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              nativeText,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getNativeText,
              child: const Text('Отримати текст з Android'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: takePhoto,
              child: const Text('Зробити фото'),
            ),
            const SizedBox(height: 20),
            if (imageFile != null)
              Image.file(imageFile!, height: 300),
          ],
        ),
      ),
    );
  }
}
