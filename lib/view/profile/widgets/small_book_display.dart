import 'package:flutter/material.dart';
import 'package:pagepal/controller/books_fetcher.dart';

class SmallBookDisplay {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String isbn = '';
  String author = '';

  BooksFetcher booksFetcher = BooksFetcher();

  Widget getYourBooksBar() {
    return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Container(
          alignment: Alignment.topCenter,
          width: 200,
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black, width: 2))),
          child: const Text('Your books'),
        ));
  }

  Future bookDialog(BuildContext context) {
    return showDialog(
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
                        booksFetcher.addBook(name, isbn, author);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Submit"))
              ],
            ));
  }
}
