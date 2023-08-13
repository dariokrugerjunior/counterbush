import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'api/robo_flow.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';


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
    showSnackBar("Pesquisando Maçãs");
    try {
      classCount = await apiService.sendImageForPrediction(imageFile);
      imageBytes = await apiService.sendImageForPredictionFile(imageFile);
      setState(() {
        imageSelected = null; // Remover a imagem selecionada
      });
    } catch (e) {
      showSnackBar('Erro: $e');
    }
  }

   Future<void> _saveImageToGallery(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      final tempFilePath = '${directory.path}/temp_image.png';

      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(bytes);

      final result = await GallerySaver.saveImage(tempFilePath, toDcim: true);
      if (result!) {
        showSnackBar('Imagem salva na galeria com sucesso.');
      } else {
        showSnackBar('Error ao salvar imagem na galeria.');
      }

      // Após salvar, você pode excluir o arquivo temporário se necessário
      await tempFile.delete();
    } catch (e) {
      showSnackBar('Error: $e');
    }
  }


  void openFullScreenImage(Uint8List bytes) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Image.memory(bytes)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _saveImageToGallery(bytes);
                        },
                        child: const Text('Salvar na Galeria'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> buildClassCountWidgets() {
    return classCount.entries.map((entry) {
      return Card(
        child: ListTile(
          title: Text('Maçã: ${getColorApple(entry.key)}'),
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        searchApiImage(imageSelected!);
                      },
                      child: const Text('Pesquisar Maçãs'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.file(imageSelected!),
                ),
              ],
            ),
          if (imageBytes != null)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        openFullScreenImage(imageBytes!);
                      },
                      child: const Text('Ver em Tela Cheia'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.memory(imageBytes!),
                ),
              ],
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

  void showSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2), // Adjust the duration as needed
    ),
  );
}
}

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
