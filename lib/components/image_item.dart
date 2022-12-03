import 'dart:io';
import 'dart:typed_data';

class ImageItem {
  File file;
  Uint8List byestsImg;
  String base64Image;

  ImageItem({
    this.file,
    this.base64Image,
    this.byestsImg,
  });
}
