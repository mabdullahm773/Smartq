import 'dart:io';
import 'package:image_picker/image_picker.dart';

File? _imageFile;
final ImagePicker _picker = ImagePicker();

Future<void> accessCamera() async {
  _captureImage();
}

Future<void> accessGallery() async {
  _pickImage();
}
Future<void> _pickImage() async {
  final ImagePicker picker = ImagePicker();
  // Pick an image.
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if(image != null){
    _imageFile = File(image.path);
  }

}

Future<void> _captureImage() async {
  final ImagePicker picker = ImagePicker();
  // Capture a photo.
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  if(photo != null){
    _imageFile = File(photo.path);
  }
}
