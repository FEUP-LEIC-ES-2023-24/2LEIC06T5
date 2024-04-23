import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/view/swipe/widgets/swiper.dart';
import 'package:pagepal/view/templates/general/general_page.dart';

class SwipePageView extends StatefulWidget {
  const SwipePageView({super.key});

  @override
  State<StatefulWidget> createState() => SwipePageViewState();
}

class SwipePageViewState extends GeneralPageState {
  @override
  Widget getBody(BuildContext context) {
    return Column(
      children: [
        buildHeader(),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Swiper(),
        ),
      ],
    );
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
              const SignOutButton(),
              ElevatedButton(
                onPressed: () {},
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
                  Row(children: [
                    Icon(Icons.add),
                    // TODO: THIS IS HARDCODED
                    Text("Porto, Portugal")
                  ])
                ],
              )),
        )
      ],
    );
  }
}
