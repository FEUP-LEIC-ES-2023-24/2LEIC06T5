import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:pagepal/controller/books_fetcher.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/view/camera/camera.dart';

class PhotoPreviewer extends StatefulWidget {
  final String filePath;
  const PhotoPreviewer({required this.filePath, super.key});

  @override
  State<StatefulWidget> createState() => PhotoPreviewerState();
}

class PhotoPreviewerState extends State<PhotoPreviewer> {
  String isbn = '';

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Column(
      children: [
        Image.file(File(widget.filePath)),
        Row(
          children: [
            TextButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FutureBuilder<List<CameraDescription>?>(
                          future: availableCameras(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<CameraDescription>?>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data != null) {
                                return TakePictureScreen(
                                    camera: snapshot.data!.first);
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
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                  showAdaptiveDialog(
                      context: context,
                      builder: (context) => AlertDialog.adaptive(
                            content: IntrinsicHeight(
                                child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: "ISBN",
                                        icon: Icon(Icons.book),
                                      ),
                                      onSaved: (String? value) => isbn = value!,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            actions: [
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      print(isbn);
                                      Book book = await BooksFetcher()
                                          .searchBookByISBN(isbn);
                                      showBookInformationDialog(book);
                                    }
                                  },
                                  child: const Text("Search book"))
                            ],
                          ));
                },
                child: const Text("Approve"))
          ],
        )
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
                  Text(book.pubYear.toString()),
                  Text(book.lang),
                  TextButton(
                      child: const Text("Confirm"),
                      onPressed: () {
                        BooksFetcher()
                            .addBook(book.title, book.isbn, book.authors[0]);
                        Navigator.pop(context);
                      }),
                ],
              ),
            )));
  }
}
