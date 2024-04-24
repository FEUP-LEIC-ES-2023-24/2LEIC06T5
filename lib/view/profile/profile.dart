import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/view/templates/general/general_page.dart';
import 'package:pagepal/controller/queries.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePageViewState();
}

class ProfilePageViewState extends GeneralPageState {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String isbn = '';
  String author = '';

  @override
  Widget getBody(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                                onSaved: (String? value) => name = value!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              onSaved: (String? value) => isbn = value!,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                  onSaved: (String? value) => author = value!)),
                        ],
                      )),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            addBook(name, isbn, author);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("Submit"))
                  ],
                ));
      },
      child: const Text("Add book"),
    );
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
