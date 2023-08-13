class DetectionResponse {
  final double time;
  final ImageInfo image;
  final List<Prediction> predictions;

  DetectionResponse({
    required this.time,
    required this.image,
    required this.predictions,
  });

  factory DetectionResponse.fromJson(Map<String, dynamic> json) {
    var predictionList = json['predictions'] as List;
    List<Prediction> predictions = predictionList
        .map((predictionJson) => Prediction.fromJson(predictionJson))
        .toList();

    return DetectionResponse(
      time: json['time'],
      image: ImageInfo.fromJson(json['image']),
      predictions: predictions,
    );
  }
}

class ImageInfo {
  final int width;
  final int height;

  ImageInfo({
    required this.width,
    required this.height,
  });

  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      width: json['width'],
      height: json['height'],
    );
  }
}

class Prediction {
  final double x;
  final double y;
  final double width;
  final double height;
  final double confidence;
  final String classLabel;

  Prediction({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.confidence,
    required this.classLabel,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      x: json['x'],
      y: json['y'],
      width: json['width'],
      height: json['height'],
      confidence: json['confidence'],
      classLabel: json['class'],
    );
  }
}