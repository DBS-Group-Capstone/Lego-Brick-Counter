import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier{
  //camera list and initialization status
  List <CameraDescription> _cameras = [];
  bool _isInitialized = false;

  //getter methods
  List<CameraDescription> get cameras => _cameras;
  bool get isInitialized => _isInitialized;

  //load available cameras
  Future<void> loadCameras() async{
    try{
      _cameras = await availableCameras();
      _isInitialized = true;
      notifyListeners();
    } catch (e){
      print("Error loading cameras: $e");
    }
  }
}