import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import '../class/detection_response.dart';

class ApiService {
  final String apiKey;

  ApiService(this.apiKey);

  Future<Map<String, int>> sendImageForPrediction(File imageFile) async {
    var url = Uri.parse(
        'https://detect.roboflow.com/box-apple/1?api_key=$apiKey');

    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
    ));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonMap = json.decode(responseBody);
        DetectionResponse detectionResult = DetectionResponse.fromJson(jsonMap);
        final List<Prediction> predictions = detectionResult.predictions;
        Map<String, int> classCount = {};
        for (var prediction in predictions) {
          if (classCount.containsKey(prediction.classLabel)) {
            classCount[prediction.classLabel] =
                classCount[prediction.classLabel]! + 1;
          } else {
            classCount[prediction.classLabel] = 1;
          }
        }
        return classCount;
      } else {
        throw Exception('Requisição falhou com status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao enviar a requisição: $e');
    }
  }

  Future<Uint8List> sendImageForPredictionFile(File imageFile) async {
    var url = Uri.parse(
        'https://detect.roboflow.com/box-apple/1?api_key=$apiKey&format=image&labels=false&stroke=5');

    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
    ));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.toBytes();
        return Uint8List.fromList(responseBody);
      } else {
        throw Exception('Requisição falhou com status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao enviar a requisição: $e');
    }
  }
}
