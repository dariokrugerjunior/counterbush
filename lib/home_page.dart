import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'api/robo_flow.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImagePicker imagePicker = ImagePicker();
  File? imageSelected;
  Map<String, int> classCount = {};
  Uint8List? imageBytes;
  ApiService apiService = ApiService('VaFSU2CW1skuZYeidgCM');

  Future<void> searchApiImage(File imageFile) async {
    try {
      classCount = await apiService.sendImageForPrediction(imageFile);
      imageBytes = await apiService.sendImageForPredictionFile(imageFile);
      setState(() {
        imageSelected = null; // Remover a imagem selecionada
      });
    } catch (e) {
      print('Erro: $e');
    }
  }

  List<Widget> buildClassCountWidgets() {
    return classCount.entries.map((entry) {
      return Card(
        child: ListTile(
          title: Text('Maça: ${getColorApple(entry.key)}'),
          subtitle: Text('Quantidade: ${entry.value}'),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador de Maçãs')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (imageBytes == null && imageSelected != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.file(imageSelected!),
            ),
          if (imageBytes != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.memory(imageBytes!),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  getImageGalery();
                },
                icon: const Icon(Icons.add_photo_alternate_outlined),
              ),
              IconButton(
                onPressed: () {
                  getImageCamera();
                },
                icon: const Icon(Icons.photo_camera_outlined),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (imageSelected != null) {
                searchApiImage(imageSelected!);
              }
            },
            child: const Text('Pesquisar Maçãs'),
          ),
          Expanded(
            child: ListView(
              children: buildClassCountWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  getImageGalery() async {
    final PickedFile? imageTemp =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (imageTemp != null) {
      setState(() {
        imageSelected = File(imageTemp.path);
        classCount = {};
        imageBytes = null;
      });
    }
  }

  getImageCamera() async {
    final PickedFile? imageTemp =
        await imagePicker.getImage(source: ImageSource.camera);
    if (imageTemp != null) {
      setState(() {
        imageSelected = File(imageTemp.path);
        classCount = {};
        imageBytes = null;
      });
    }
  }

  getColorApple(String name) {
    switch (name) {
      case 'apple-red':
        return 'Vermelha';
      case 'apple-green':
        return 'Verde';
      case 'spliced-apple-green':
        return 'Verde Cortada';
      case 'spliced-apple-red':
        return 'Vermelha Cortada';
    }
    return name;
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
