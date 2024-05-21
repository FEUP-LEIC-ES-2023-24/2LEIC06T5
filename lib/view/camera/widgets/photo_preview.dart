import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:pagepal/controller/books_fetcher.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/view/camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhotoPreviewer extends StatefulWidget {
  final String filePath;
  final Function(String) callback;
  const PhotoPreviewer(
      {required this.filePath, required this.callback, super.key});

  @override
  State<StatefulWidget> createState() => PhotoPreviewerState();
}

class PhotoPreviewerState extends State<PhotoPreviewer> {
  String isbn = '';

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Image.file(File(widget.filePath))),
        Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FutureBuilder<List<CameraDescription>?>(
                            future: availableCameras(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<CameraDescription>?>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.data != null) {
                                  return TakePictureScreen(
                                    camera: snapshot.data!.first,
                                    callback: (string) => {},
                                  );
                                } else {
                                  return const Text('No camera available');
                                }
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                  child: const Text("Retake")),
            ),
            Padding(
                padding: const EdgeInsets.all(5),
                child: TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(3),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                      showAdaptiveDialog(
                          context: context,
                          builder: (context) => AlertDialog.adaptive(
                                content: IntrinsicHeight(
                                    child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: "ISBN",
                                            icon: Icon(Icons.book),
                                          ),
                                          onSaved: (String? value) =>
                                              isbn = value!,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          Book book = await BooksFetcher()
                                              .searchBookByISBN(isbn);
                                          showBookInformationDialog(book);
                                          addPictureToStorage(
                                              widget.filePath, book.isbn);
                                        }
                                      },
                                      child: const Text("Search book"))
                                ],
                              ));
                    },
                    child: const Text("Approve")))
          ],
        ))
      ],
    );
  }

  void showBookInformationDialog(Book book) {
    Navigator.pop(context);
    showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
                content: IntrinsicHeight(
              child: Column(
                children: [
                  Text(book.title),
                  Text(book.authors[0]),
                  Text(book.genres[0]),
                  Text(book.pubYear),
                  Text(book.lang),
                  TextButton(
                      child: const Text("Confirm"),
                      onPressed: () {
                        BooksFetcher().addBook(book);
                        widget.callback(widget.filePath);
                        Navigator.pop(context);
                      }),
                ],
              ),
            )));
  }

  void addPictureToStorage(String filePath, String isbn) async {
    final user = FirebaseAuth.instance.currentUser;

    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child('${isbn}_${user!.uid}');
    File file = File(filePath);
    await imagesRef.putFile(file);
  }
}
