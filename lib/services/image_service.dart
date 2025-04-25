import 'dart:io';
import 'package:image_picker/image_picker.dart';

File? _imageFile;
final ImagePicker _picker = ImagePicker();

Future<void> _pickImage() async {
  final ImagePicker picker = ImagePicker();
  // Pick an image.
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

}

Future<void> _captureImage() async {
  final ImagePicker picker = ImagePicker();
  // Capture a photo.
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
}
