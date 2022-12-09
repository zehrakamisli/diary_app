import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceDialog extends StatelessWidget {
  const ImageSourceDialog({super.key, required this.callback});

  final Function(ImageSource) callback;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .2,
        width: MediaQuery.of(context).size.width * .3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Chose where you take the photo'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => callback(ImageSource.camera),
                    child: Row(
                      children: const [
                        Expanded(child: Icon(Icons.camera_alt_rounded)),
                        Expanded(child: Text('Camera')),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => callback(ImageSource.gallery),
                    child: Row(
                      children: const [
                        Expanded(child: Icon(Icons.photo_camera_back_rounded)),
                        Expanded(child: Text('Gallery')),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
