import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String titleText;
  CustomAppBar({
    super.key,
    required this.titleText,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(titleText),
      actions: <Widget>[
        PopupMenuButton<int>(
          onSelected: (value) {
            switch (value) {
              case 0:
                Get.toNamed(Routes.HTTP);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 0,
              child: TextButton(
                onPressed: null,
                child: Text("HTTP Page"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
