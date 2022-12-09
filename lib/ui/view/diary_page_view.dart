import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/base/base_utility.dart';
import 'package:diary_app/ui/model/diary_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/image_source_dialog.dart';

class DiaryPage extends StatefulWidget {
  final DateTime selectedDay;
  const DiaryPage({super.key, required this.selectedDay});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? _image;

  Future _pickImage() async {
    ImageSource? source;
    await showDialog(
        context: context,
        builder: (context) {
          return ImageSourceDialog(
            callback: (src) {
              source = src;
              Navigator.pop(context);
            },
          );
        });
    if (source != null) {
      try {
        final image = await ImagePicker().pickImage(source: source!);
        if (image == null) return;
        File? img = File(image.path);
        setState(() {
          _image = img;
        });
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

  Future<void> sendDiaryData() async {
    String? imageUrl;
    if (_image != null) {
      var storage = FirebaseStorage.instance.ref();

      final diaryRef = storage
          .child('diaryImage${DateTime.now().millisecondsSinceEpoch}.jpg');

      final diaryImageRef = storage.child(
          'images/diaryImage${DateTime.now().millisecondsSinceEpoch}.jpg');
      try {
        await diaryImageRef.putFile(_image!);
        imageUrl = await diaryImageRef.getDownloadURL();
      } catch (e) {}
    }

    DiaryModel data = DiaryModel(
      id: widget.selectedDay.millisecondsSinceEpoch.toString(),
      title: titleController.text,
      content: contentController.text,
      dateTime: widget.selectedDay,
      image: imageUrl,
    );
    var db = FirebaseFirestore.instance;
    db.collection('diarys').add(data.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorUtility.backGroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () => sendDiaryData(),
          backgroundColor: ColorUtility.fabColor,
          child: const Icon(Icons.save),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Row(children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                  ]),
                  const Spacer(),
                  contentArea(context),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector imageButton() {
    return GestureDetector(
      onTap: () => _pickImage(),
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: ColorUtility.fabColor),
        padding: const EdgeInsets.all(16),
        child: const Icon(
          Icons.add,
          color: ColorUtility.pageColor,
        ),
      ),
    );
  }

  Container contentArea(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 9 / 10,
      width: MediaQuery.of(context).size.width * 4 / 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: Colors.white.withOpacity(0.8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              label: Text('Title'),
            ),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_image != null) Expanded(child: Image.file(_image!)),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        label: Text('Content'),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          imageButton(),
        ],
      ),
    );
  }
}
