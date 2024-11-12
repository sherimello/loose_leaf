import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:untitled3/classes/db_helper.dart';
import 'package:untitled3/pages/all_notes.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool shouldAnimateIcon = false,
      shouldLoadHomeUI = false;
  Timer? timer, timer2;
  DbHelper dbHelper = DbHelper();
  Database? database;
  TextEditingController titleController = TextEditingController(),
      noteController = TextEditingController();

  triggerIconAnimation() {
    timer = Timer(
        const Duration(seconds: 1),
            () =>
            setState(() {
              shouldAnimateIcon = true;
            }));

    timer2 = Timer(
        const Duration(seconds: 3),
            () =>
            setState(() {
              shouldLoadHomeUI = true;
            }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  init() async {
    // await initDB();
    await dbHelper.initDB();
    database = dbHelper.database;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    triggerIconAnimation();
    init();
  }

  @override
  Widget build(BuildContext context) {
    var size = Get.size;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 999),
                    curve: Curves.linearToEaseOut,
                    top: shouldLoadHomeUI
                        ? -MediaQuery
                        .of(context)
                        .padding
                        .top
                        : -appBarHeight,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 999),
                      curve: Curves.linearToEaseOut,
                      opacity: shouldLoadHomeUI ? 1 : 0,
                      child: Container(
                        width: size.width,
                        height: appBarHeight + MediaQuery
                            .of(context)
                            .padding
                            .top,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: MediaQuery
                                  .of(context)
                                  .padding
                                  .top * 1.5,
                              child: Center(
                                child: Text(
                                  "loose leaf",
                                  style: TextStyle(
                                      height: 0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      fontSize: size.width * .055),
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery
                                  .of(context)
                                  .padding
                                  .top * 1.5,
                              right: 21,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => const AllNotes());
                                },
                                child: Icon(
                                  CupertinoIcons.list_bullet_indent,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 555),
                  curve: Curves.linearToEaseOut,
                  top: shouldLoadHomeUI
                      ? appBarHeight * 2 + 42
                      : shouldAnimateIcon
                      ? size.height * .5 - size.width * .055
                      : size.height * .5 -
                      size.width * .055 * .5 -
                      MediaQuery
                          .of(context)
                          .padding
                          .top,
                  right: shouldLoadHomeUI
                      ? 21
                      : shouldAnimateIcon
                      ? size.width * .5 - size.width * .055 - 1.5
                      : size.width * .5 - size.width * .055 * .5,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 555),
                    curve: Curves.linearToEaseOut,
                    width: shouldLoadHomeUI ? size.width - 42 : size.width *
                        .055,
                    height: shouldLoadHomeUI
                        ? size.height -
                        appBarHeight * 2 -
                        63 -
                        MediaQuery
                            .of(context)
                            .padding
                            .top
                        : shouldAnimateIcon
                        ? size.width * 0.15 - size.width * .085 - 3
                        : size.width * .055,
                    decoration: BoxDecoration(
                        color: const Color(0xffababab),
                        borderRadius:
                        BorderRadius.circular(shouldLoadHomeUI ? 55 : 1000)),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.linearToEaseOut,
                      opacity: shouldLoadHomeUI ? 1 : 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11.0, vertical: 21),
                        child: TextField(
                          controller: titleController,
                          enabled: shouldLoadHomeUI,
                          maxLines: 1000000,
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              // Make the background transparent
                              border: InputBorder.none,
                              // Remove the border
                              hintText: "let's note down some bhugi sugis...",
                              hintStyle: TextStyle(
                                  height: 0, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 999),
                  curve: Curves.linearToEaseOut,
                  top: shouldLoadHomeUI
                      ? appBarHeight + 21
                      : shouldAnimateIcon
                      ? size.height * .5 -
                      size.width * .15 * .5 -
                      MediaQuery
                          .of(context)
                          .padding
                          .top
                      : size.height * .5 -
                      size.width * .055 * .5 -
                      MediaQuery
                          .of(context)
                          .padding
                          .top,
                  right: shouldLoadHomeUI
                      ? 21
                      : shouldAnimateIcon
                      ? size.width * .5 - size.width * .055 - 1.5
                      : size.width * .5 - size.width * .055 * .5,
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 555),
                      curve: Curves.linearToEaseOut,
                      width: shouldLoadHomeUI ? size.width - 42 : size.width *
                          .055,
                      height: shouldLoadHomeUI
                          ? appBarHeight
                          : shouldAnimateIcon
                          ? size.width * .085
                          : size.width * .055,
                      decoration: BoxDecoration(
                          color: const Color(0xff646464),
                          borderRadius: BorderRadius.circular(1000)),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.linearToEaseOut,
                        opacity: shouldLoadHomeUI ? 1 : 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11.0),
                          child: TextField(
                            controller: noteController,
                            enabled: shouldLoadHomeUI,
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                // Make the background transparent
                                border: InputBorder.none,
                                // Remove the border
                                hintText: "leaf title...",
                                hintStyle:
                                TextStyle(height: 0, color: Colors.white)),
                          ),
                        ),
                      )),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 777),
                  curve: Curves.linearToEaseOut,
                  top: shouldLoadHomeUI
                      ? size.height -
                      size.width * .15 -
                      MediaQuery
                          .of(context)
                          .padding
                          .top -
                      42
                      : shouldAnimateIcon
                      ? size.height * .5 -
                      size.width * .15 * .5 -
                      MediaQuery
                          .of(context)
                          .padding
                          .top
                      : size.height * .5 -
                      size.width * .055 * .5 -
                      MediaQuery
                          .of(context)
                          .padding
                          .top,
                  right: shouldLoadHomeUI
                      ? 42
                      : shouldAnimateIcon
                      ? size.width * .5 + 1.5
                      : size.width * .5 - size.width * .055 * .5,
                  child: GestureDetector(
                    onTap: () {
                      if (titleController.text.isEmpty ||
                          noteController.text.isEmpty) {
                        Get.snackbar("oopsie!", "field(s) cannot be empty!",
                          backgroundColor: Colors.black,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(21)
                        );
                        return;
                      }
                      dbHelper.insertData(
                          database!, titleController.text, noteController.text);
                      titleController.clear();
                      noteController.clear();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 555),
                      curve: Curves.linearToEaseOut,
                      width:
                      shouldLoadHomeUI ? size.width * 0.15 : size.width * .055,
                      height: shouldLoadHomeUI
                          ? size.width * 0.15
                          : shouldAnimateIcon
                          ? size.width * .15
                          : size.width * .055,
                      decoration: BoxDecoration(
                          color: const Color(0xff000000),
                          borderRadius: BorderRadius.circular(1000)),
                      child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 555),
                          curve: Curves.linearToEaseOut,
                          opacity: shouldLoadHomeUI ? 1 : 0,
                          child: const Icon(
                            Icons.save_as,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 999),
                  curve: Curves.linearToEaseOut,
                  bottom: shouldLoadHomeUI
                      ? -21
                      : shouldAnimateIcon
                      ? 21
                      : -21,
                  // top: size.height * .5 - size.width * .055 * .5,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 999),
                    curve: Curves.linearToEaseOut,
                    opacity: shouldLoadHomeUI
                        ? 0
                        : shouldAnimateIcon
                        ? 1
                        : 0,
                    child: Text(
                      "loose leaf",
                      style: TextStyle(
                          height: 0,
                          fontSize: size.width * .055,
                          fontFamily: "SF-Pro",
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
