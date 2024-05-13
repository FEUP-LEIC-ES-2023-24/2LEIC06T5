import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:pagepal/controller/queries.dart';
import 'package:pagepal/view/camera/camera.dart';
import 'package:pagepal/view/profile/widgets/edit_dialog.dart';
import 'package:pagepal/controller/books_fetcher.dart';
import 'package:pagepal/view/profile/widgets/custom_painter.dart';
import 'package:pagepal/view/profile/widgets/main_info.dart';
import 'package:pagepal/view/profile/widgets/profile_stats.dart';
import 'package:pagepal/view/profile/widgets/rating_dialog.dart';
import 'package:pagepal/view/profile/widgets/small_book_display.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePageViewState();
}

class ProfilePageViewState extends GeneralPageState {
  final user = FirebaseAuth.instance.currentUser;

  static String username = '';

  @override
  void initState() {
    super.initState();
    username = FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  final List<Image> books = [];
  static const NetworkImage profilePic = NetworkImage(
      // needs to be an image provider to work
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png");

  final booksFetcher = BooksFetcher();

  final smallBoookDisplay = SmallBookDisplay();

  @override
  Widget getBody(BuildContext context) {
    return Column(
      children: [
        const MainInfo(),
        const ProfileStats(),
        smallBoookDisplay.getYourBooksBar(),
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
                  onPressed: () => setState(() {
                        // TODO: CHANGE THIS
                        books.add(
                          const Image(
                            image: NetworkImage(
                                "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1555447414i/44767458.jpg"),
                          ),
                        );
                      }),
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
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FutureBuilder<List<CameraDescription>?>(
                        future: availableCameras(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<CameraDescription>?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // Make sure there is at least one camera
                            if (snapshot.data != null) {
                              print(snapshot.data);
                              return TakePictureScreen(
                                  camera: snapshot.data!.first);
                            } else {
                              return Text('No camera available');
                            }
                          } else {
                            return CircularProgressIndicator(); // Show a loading indicator while waiting for the cameras
                          }
                        },
                      ),
                    ),
                  ),
              child: const Text("Take a picture!")),
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

  void addBook(String name, String isbn, String author) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    QuerySnapshot authorQuery = await Queries.getAuthor(author);

    DocumentReference authorRef;

    if (authorQuery.docs.isEmpty) {
      authorRef = firestore.collection('author').doc();

      authorRef.set({
        'name': author,
        'wrote': [],
      });
    } else {
      authorRef = authorQuery.docs.first.reference;
    }

    final DocumentReference booksRef = firestore.collection('book').doc();

    booksRef.set({
      'author': authorRef.id,
      'isbn': isbn,
      'title': name,
    });

    authorQuery = await Queries.getAuthor(author);

    List<String> wrote = await Queries.retrieveAuthorBooks(author);

    wrote.add(booksRef.id);
    authorQuery.docs.first.reference.update({'wrote': wrote});

    QuerySnapshot userQuery =
        await Queries.getUser(auth.currentUser!.email ?? '');

    List<String> owns =
        await Queries.retrieveUserBooks(auth.currentUser!.email ?? '');

    owns.add(booksRef.id);
    userQuery.docs.first.reference.update({'owns': owns});
  }
}
