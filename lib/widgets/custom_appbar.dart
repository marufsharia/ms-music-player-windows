import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  bool isBackButtonVisible = false;
  Function? onBackButtonPressed;

  CustomAppBar(
      {this.title = "MS Music Player",
      this.isBackButtonVisible = false,
      this.onBackButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          //add back button here
          isBackButtonVisible
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 16.0),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title ?? 'MS Music Player',
                style: TextStyle(color: Colors.white)),
          ),

          Expanded(
            child: MoveWindow(), // Allows dragging the window
          ),
          Row(
            children: [
              MinimizeWindowButton(),
              MaximizeWindowButton(),
              CloseWindowButton(),
            ],
          ),
        ],
      ),
    );
  }
}
