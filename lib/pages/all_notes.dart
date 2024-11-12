import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled3/classes/db_helper.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({super.key});

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  bool shouldShowLoading = false, shouldShowDeleteUI = false;
  DbHelper dbHelper = DbHelper();
  Database? database;
  List<Map<String, Object?>>? data = [];
  int deletionIndex = 0;

  init() async {
    await dbHelper.initDB();
    database = dbHelper.database;
    data = await dbHelper.fetchNotes(database!);
    setState(() {
      data = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    var size = Get.size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (b, value) {
        setState(() {
          shouldShowDeleteUI = false;
        });
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: data!.isEmpty
              ? () {}
              : () {
                  setState(() {
                    shouldShowLoading = true;
                  });
                  FirebaseDatabase.instance
                      .ref('notes')
                      .set(data)
                      .then((value) {
                    setState(() {
                      shouldShowLoading = false;
                    });
                    print("Data uploaded successfully");
                  }).catchError((error) {
                    setState(() {
                      shouldShowLoading = false;
                    });
                    print("Failed to upload data: $error");
                  });
                },
          backgroundColor: Colors.black,
          child: const Icon(
            CupertinoIcons.upload_circle,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "loose leaf",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: size.width * .055,
                fontFamily: "SF-Pro"),
          ),
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              CupertinoIcons.chevron_back,
              color: Colors.white,
            ),
          ),
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: data?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: index == 0
                          ? const EdgeInsets.fromLTRB(11, 11, 11, 5.5)
                          : const EdgeInsets.symmetric(
                              horizontal: 11.0, vertical: 5.5),
                      child: GestureDetector(
                        onTap: () {
                          if (shouldShowDeleteUI && deletionIndex == index) {
                            dbHelper.deleteNote(database!,
                                int.parse(data![index]["id"].toString()));
                            init();
                          }
                        },
                        onLongPress: () {
                          deletionIndex = index;
                          setState(() {
                            shouldShowDeleteUI = true;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 777),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: size.width,
                          decoration: BoxDecoration(
                              color:
                                  shouldShowDeleteUI && deletionIndex == index
                                      ? Colors.red
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(1000),
                              border: Border.all(width: 1)),
                          child: shouldShowDeleteUI && deletionIndex == index
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(31.0),
                                    child: Text(
                                      "delete leaf",
                                      style: TextStyle(
                                          fontSize: size.width * .055,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          height: 0),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(17),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(1000)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Text(
                                            " ${data![index]["title"].toString()} ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: size.width * .041),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            9, 17, 9, 0),
                                        child: Text(
                                          " ${data![index]["note"].toString()} ",
                                          style: TextStyle(
                                              height: 0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w200,
                                              fontSize: size.width * .041),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),
              Visibility(
                visible: shouldShowLoading,
                child: const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black,
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
