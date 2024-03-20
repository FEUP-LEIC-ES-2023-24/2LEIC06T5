import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pagepal/model/navbar_item.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  String? getCurrentPage(BuildContext context) =>
      ModalRoute.of(context)!.settings.name;

  int getCurrentIndex(BuildContext context) {
    final currentPage = getCurrentPage(context);
    for (final item in NavBarItem.values) {
      if (item.page.page == currentPage) {
        return item.index;
      }
    }
    return -1;
  }

  Widget _buildMiddleSeparator() {
    return SizedBox(
      height: 60.0,
      width: 25,
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    int idx = 0;
    for (NavBarItem item in NavBarItem.values) {
      if (item != NavBarItem.swipeItem) {
        items.insert(
            idx,
            IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () =>
                    Navigator.pushNamed(context, '/${item.page.page}'),
                icon: item.icon));
        idx++;
      }
    }

    items.insert(2, _buildMiddleSeparator());

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      height: 60,
      color: const Color(0xFFD4A373),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      ),
    );
  }
}
