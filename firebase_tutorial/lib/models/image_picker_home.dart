import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class home_image_picker extends StatefulWidget {
  const home_image_picker({super.key, required this.onpickimage});
  final void Function(File _selected_image) onpickimage;

  @override
  State<home_image_picker> createState() => _home_image_pickerState();
}

class _home_image_pickerState extends State<home_image_picker> {
  File? _selected_imagefile;
  void _select_image() async {
    final _selected_image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 300,
    );
    if (_selected_image == null) {
      return;
    }
    setState(() {
      _selected_imagefile = File(_selected_image.path);
    });
    widget.onpickimage(_selected_imagefile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () => _select_image(),
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        )
      ],
    );
  }
}
