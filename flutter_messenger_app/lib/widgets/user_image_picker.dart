import 'dart:html' as html;
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, 
  required this.imagePickFn});

  final void Function(Uint8List pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  Uint8List? _pickedImage;

  void _pickImage() async {
    final pickedImage = await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImage = pickedImage as Uint8List?;
    });

    widget.imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null ? MemoryImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text('Add Image', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
      ],
    );
  }
}