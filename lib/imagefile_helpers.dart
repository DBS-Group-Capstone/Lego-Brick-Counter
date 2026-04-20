import 'dart:typed_data';

import 'package:image/image.dart' as imaging;
import 'package:cross_file/cross_file.dart';

// Helper function to make sure we're only dealing with Png encoding
Future<XFile?> verifyPng(XFile f) async {
  Uint8List? image;
  var bytes = await f.readAsBytes();
  var decoder = imaging.findDecoderForData(bytes);
  if (decoder != null) {
    var decoded = decoder.decode(bytes);
    if (decoded != null) {
      image = imaging.encodePng(decoded);
    }
  }

  if (image!= null) {
    return XFile.fromData(image);
  }
  return null;
} 

Future<XFile?> verifyPngAndRemoveEXIF(XFile f) async {
  Uint8List? image;
  var bytes = await f.readAsBytes();
  var decoder = imaging.findDecoderForData(bytes);
  if (decoder != null) {
    var decoded = decoder.decode(bytes);
    if (decoded != null) {
      if (decoded.exif.imageIfd.hasOrientation) {
        decoded = imaging.bakeOrientation(decoded);
      }
    }
    if(decoded != null) {
      image = imaging.encodePng(decoded);
    }
  }
  if (image!= null) {
    return XFile.fromData(image);
  }
  return null;
} 