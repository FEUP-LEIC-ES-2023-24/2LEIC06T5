import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:pagepal/controller/books_fetcher.dart';
import 'package:pagepal/model/providers/book_provider.dart';
import 'package:pagepal/view/camera/camera.dart';
import 'package:pagepal/view/profile/widgets/edit_dialog.dart';

import 'package:pagepal/view/profile/widgets/custom_painter.dart';
import 'package:pagepal/view/profile/widgets/main_info.dart';
import 'package:pagepal/view/profile/widgets/profile_stats.dart';
import 'package:pagepal/view/profile/widgets/rating_dialog.dart';
import 'package:pagepal/view/templates/general/general_page.dart';
import 'package:provider/provider.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePageViewState();
}

class ProfilePageViewState extends GeneralPageState {
  final user = FirebaseAuth.instance.currentUser;
  String imagePath = '';
  static String username = '';

  @override
  void initState() {
    super.initState();
    username = user?.displayName ?? '';
    loadBookImages();
  }

  Future<void> loadBookImages() async {
    final bookImages =
        await BooksFetcher().fetchUserBookImages(user?.email ?? '');
    // ignore: use_build_context_synchronously
    Provider.of<BooksProvider>(context, listen: false).setBooks(bookImages);
  }

  static const NetworkImage profilePic = NetworkImage(
      // needs to be an image provider to work
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png");

  //final smallBoookDisplay = SmallBookDisplay();

  @override
  Widget getBody(BuildContext context) {
    final books = Provider.of<BooksProvider>(context).books;
    return Column(
      children: [
        const MainInfo(),
        const ProfileStats(),
        //smallBoookDisplay.getYourBooksBar(),
        getBooksPics(books)
      ],
    );
  }

  Widget getBooksPics(List<Image> books) {
    final List<Widget> picBooks = books
        .map((book) => Container(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              width: 100,
              height: 150,
              child: book,
            )))
        .toList();
    final buttonToAddBook = Container(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
            width: 100,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    Navigator.push(
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
                                  camera: snapshot.data!.first,
                                  callback: (imagePath) {
                                    Provider.of<BooksProvider>(context,
                                            listen: false)
                                        .addBook(Image.file(File(imagePath)));
                                  },
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
                    );
                  },
                  icon: const Icon(Icons.add)),
            )));

    picBooks.insert(0, buttonToAddBook);

    return Expanded(
        child: SingleChildScrollView(
            child: Wrap(
      children: picBooks,
    )));
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context) {
    const double heightAppBar = 190;

    return AppBar(
        toolbarHeight: heightAppBar,
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: () => showAdaptiveDialog(
                  context: context,
                  builder: (context) => RatingDialog(
                        userID: user!.uid,
                      )),
              child: const Text('Rate them!!'))
        ],
        flexibleSpace: Stack(
          children: <Widget>[
            Container(
              height: heightAppBar * 0.8,
              color: const Color(0xFFD4A373),
            ),
            Container(
              alignment: Alignment.topRight,
              child: TextButton(
                  onPressed: () => showDialog(
                        context: context,
                        builder: (context) => const EditProfileDialog(),
                      ),
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFEFAE0),
                      foregroundColor: const Color(0xFFD4A373)),
                  child: const Text('Edit Profile')),
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
              child:
                  const CircleAvatar(radius: 35, backgroundImage: profilePic),
            )
          ],
        ));
  }
}
