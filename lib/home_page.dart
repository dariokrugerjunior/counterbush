import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImagePicker imagePicker = ImagePicker();
  File? imageSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Contador de Botijão')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageSelected == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.file(imageSelected!)
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    getImageGalery();
                  },
                  icon: Icon(Icons.add_photo_alternate_outlined),
                ),
                IconButton(
                  onPressed: () {
                    getImageCamera();
                  },
                  icon: Icon(Icons.photo_camera_outlined),
                ),
              ],
            )
          ],
        ));
  }

  getImageGalery() async {
    final PickedFile? imageTemp =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (imageTemp != null) {
      setState(() {
        imageSelected = File(imageTemp.path);
      });
    }
  }

  getImageCamera() async {
    final PickedFile? imageTemp =
        await imagePicker.getImage(source: ImageSource.camera);
    if (imageTemp != null) {
      setState(() {
        imageSelected = File(imageTemp.path);
      });
    }
  }

}
