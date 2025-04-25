import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
  }

  List<dynamic> runModel(List<double> input) {
    var output = List.filled(1, 0).reshape([1, 1]); // Adjust based on model output
    _interpreter?.run(input, output);
    return output;
  }
}
