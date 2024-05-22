import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/controller/nearby.dart';
import 'package:pagepal/view/profile/widgets/username_dialog.dart';
import 'package:pagepal/view/swipe/widgets/swiper.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

class SwipePageView extends StatefulWidget {
  const SwipePageView({super.key});

  @override
  State<StatefulWidget> createState() => SwipePageViewState();
}

class SwipePageViewState extends GeneralPageState {
  final _formKey = GlobalKey<FormState>();
  String? newLocation;
  User? auth = FirebaseAuth.instance.currentUser;

  @override
  Widget getBody(BuildContext context) {
    return ListView(children: [
      Column(
        children: [
          buildHeader(),
          const Padding(
            padding: EdgeInsets.all(5),
            child: Swiper(),
          ),
        ],
      )
    ]);
  }

  @override
  PreferredSizeWidget? getAppBar(BuildContext context) {
    return null;
  }

  Widget buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 10, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    FirebaseUIAuth.signOut(
                        context: context, auth: FirebaseAuth.instance);
                    Navigator.pushNamed(context, '/auth');
                  },
                  child: const Text("Sign Out")),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      content: SizedBox(
                        height: 100,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text("New Location"),
                              Padding(
                                padding: const EdgeInsets.all(1),
                                child: TextFormField(
                                  onSaved: (String? value) =>
                                      newLocation = value,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                updateLocation(newLocation);
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text("Submit")),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(elevation: 10),
                child: const Row(
                  children: [
                    Text(
                      "Location ",
                      style: TextStyle(color: Colors.black),
                    ),
                    Icon(
                      Icons.add_circle,
                      color: Colors.black,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 85,
          child: Padding(
              padding: EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Discover",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCCD5AE))),
                  Row(children: [])
                ],
              )),
        )
      ],
    );
  }
}
