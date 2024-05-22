import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:pagepal/controller/books_fetcher.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/model/providers/book_provider.dart';
import 'package:pagepal/view/camera/camera.dart';
import 'package:pagepal/view/profile/widgets/edit_dialog.dart';

import 'package:pagepal/view/profile/widgets/custom_painter.dart';
import 'package:pagepal/view/profile/widgets/main_info.dart';
import 'package:pagepal/view/templates/general/general_page.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePageViewState();
}

class ProfilePageViewState extends GeneralPageState {
  final user = FirebaseAuth.instance.currentUser;
  String imagePath = '';
  String isbn = '';
  FileImage? profilePic;
  late StreamingSharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initializePreferences();
    loadBookImages();
  }

  Future<void> initializePreferences() async {
    prefs = await StreamingSharedPreferences.instance;
    prefs.getString('avatarPath', defaultValue: '').listen((value) {
      setState(() {
        profilePic = FileImage(File(value));
      });
    });
  }

  Future<void> loadBookImages() async {
    final bookImages =
        await BooksFetcher().fetchUserBookWithImages(user?.email ?? '');
    Provider.of<BooksProvider>(context, listen: false).setBooks(bookImages);
  }

  @override
  Widget getBody(BuildContext context) {
    final books = Provider.of<BooksProvider>(context).books;

    return Column(
      children: [
        const MainInfo(),
        //smallBoookDisplay.getYourBooksBar(),
        getBooksPics(books)
      ],
    );
  }

  Widget getBooksPics(List<Book> books) {
    final List<Widget> picBooks = books
        .map((book) => Container(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              width: 100,
              height: 150,
              child: Stack(
                children: [
                  book.image ?? Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(2),
                          child: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              BooksFetcher().removeBook(book.isbn);
                              Provider.of<BooksProvider>(context, listen: false)
                                  .removeBook(book);
                              setState(() {});
                            },
                          ))
                    ],
                  )
                ],
              ),
            )))
        .toList();
    final buttonToAddBook = Container(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
            width: 100,
            height: 150,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey),
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FutureBuilder<
                                    List<CameraDescription>?>(
                                future: availableCameras(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<CameraDescription>?>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.data != null) {
                                      return TakePictureScreen(
                                        camera: snapshot.data!.first,
                                        callback: (imagePath, isbn) {
                                          Provider.of<BooksProvider>(context,
                                                  listen: false)
                                              .addBook(Book(
                                                  authors: [],
                                                  genres: [],
                                                  isbn: isbn,
                                                  lang: '',
                                                  pubYear: '',
                                                  title: '',
                                                  image: Image.file(
                                                      File(imagePath))));
                                        },
                                      );
                                    } else {
                                      return const Text('No camera available');
                                    }
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                })));
                  },
                  icon: const Icon(Icons.add),
                ))));

    picBooks.insert(0, buttonToAddBook);

    return Expanded(
        child: SingleChildScrollView(
            child: Wrap(
      children: picBooks,
    )));
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context) {
    const double heightAppBar = 200;

    return AppBar(
        toolbarHeight: heightAppBar,
        leading: null,
        automaticallyImplyLeading: false,
        flexibleSpace: Stack(
          children: <Widget>[
            Container(
              height: heightAppBar * 0.75,
              color: const Color(0xFFD4A373),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: CustomPaint(
                        size: const Size(30, 70),
                        painter: customPainter(),
                      ),
                    )
                  ],
                )),
            Container(
              alignment: Alignment.bottomCenter,
              child: CircleAvatar(radius: 35, backgroundImage: profilePic),
            ),
            Container(
              padding: const EdgeInsets.all(3),
              alignment: Alignment.bottomRight,
              child: OutlinedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const EditProfileDialog(),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFEFAE0),
                    foregroundColor: const Color(0xFFD4A373)),
                child: const Text('Edit Profile'),
              ),
            ),
          ],
        ));
  }
}
