import 'dart:developer';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'feed_page.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final titleController = TextEditingController();
  final buyPlaceController = TextEditingController();
  final sendPlaceController = TextEditingController();
  final coinsController = TextEditingController();
  int timeSelected = 0;

  late final List<String> imageListOfProduct = [];

  final ImagePicker _picker = ImagePicker();

  int? limitTime;

  final _formImage = GlobalKey<FormState>();

  Widget adaptiveAction(
      {required BuildContext context,
      required VoidCallback onPressed,
      required Widget child}) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
    }
  }

  Future<void> uploadToDatabase() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child("images");
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    List<String> downloadUrls = [];
    log("imageListOfProduct $imageListOfProduct");
    try {
      for (int i = 0; i < imageListOfProduct.length; i++) {
        log("imageListOfProduct ${imageListOfProduct[i]}");
        final fileImage = File(imageListOfProduct[i]);
        final storageRef =
            FirebaseStorage.instance.ref().child('images/${fileImage.path}');
        UploadTask uploadTask = storageRef.putFile(fileImage);
        await uploadTask.whenComplete(() {});

        // final uploadUrl = await referenceImageToUpload.putFile(storageRef);
        final downloadUrl = await storageRef.getDownloadURL();
        log("url $downloadUrl");
        downloadUrls.add(downloadUrl);
      }
    } catch (error) {
      return;
    }

    if (titleController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("posts").doc().set({
        "Timestamp": Timestamp.now(),
      });

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FeedPage(),
          ),
        );
      }
    }
  }

  Future pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() {
        imageListOfProduct.add(image.path);
        Navigator.pop(context);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickCameraImage() async {
    try {
      final picture = await _picker.pickImage(source: ImageSource.camera);
      if (picture == null) return;

      setState(() {
        imageListOfProduct.add(picture.path);
        Navigator.pop(context);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future showSelectImageOptions() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(24),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "เพิ่มรูปภาพ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6229EE),
                  fontSize: 20,
                  fontFamily: 'Mitr',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Form(
                key: _formImage,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFF6229EE),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library,
                              color: Color(0xFF6229EE),
                            ),
                            Text(
                              'อัปโหลด',
                              style: TextStyle(
                                color: Color(0xFF6229EE),
                                fontSize: 16,
                                fontFamily: 'Mitr',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        pickCameraImage();
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFF6229EE),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Color(0xFF6229EE),
                            ),
                            Text(
                              'ถ่ายภาพ',
                              style: TextStyle(
                                color: Color(0xFF6229EE),
                                fontSize: 16,
                                fontFamily: 'Mitr',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTimeSelect(int o) {
    setState(() {
      limitTime = o;
    });
  }

  void selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        final now = DateTime.now();
        final limit = DateTime(
          now.year,
          now.month,
          now.day,
          newTime.hour,
          newTime.minute,
        );
        timeSelected = limit.millisecondsSinceEpoch;
      });
    }
  }

  bool useCoinToCreatePost(int? price, int? coins){
    if (price == null && coins == null) return false;
    var percent = price! * 0.85;
    if (coins! >= percent) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Container(
                  height: 245,
                  padding: const EdgeInsets.all(24),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "ยกเลิกโพสต์",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF6229EE),
                          fontSize: 20,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'คุณกำลังยกเลิกโพสต์\nต้องการดำเนินการต่อหรือไม่?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF36485C),
                          fontSize: 16,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.w300,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context, "No");
                              },
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1,
                                        color: Color(0xFF00BF63),
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    )),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ยกเลิก',
                                      style: TextStyle(
                                        color: Color(0xFF00BF63),
                                        fontSize: 16,
                                        fontFamily: 'Mitr',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const FeedPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: ShapeDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.74, -0.67),
                                    end: Alignment(-0.74, 0.67),
                                    colors: [
                                      Color(0xFFFF3131),
                                      Color(0xFFFF5757)
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ยืนยัน',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Mitr',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.black,
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/icon-hew-hew.png',
              fit: BoxFit.cover,
              height: 60,
            ),
            const Text(
              'โพสต์รับหิ้ว',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      //todo input field
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  //Product name
                  Expanded(
                    child: TextField(
                      controller: titleController,
                      maxLines: null,
                      maxLength: 100,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFF2F2F7),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFF6229EE),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: "ชื่อสินค้า",
                        hintStyle: const TextStyle(
                          color: Color(0xFFC7C7CC),
                          fontSize: 14,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.w300,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),
              //Descriptions
              Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextField(
                      controller: buyPlaceController,
                      maxLines: null,
                      maxLength: 500,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFF2F2F7),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFF6229EE),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText:
                            "สถานที่ซื้อของ",
                        hintStyle: const TextStyle(
                          color: Color(0xFFC7C7CC),
                          fontSize: 14,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.w300,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              //Descriptions
              Row(
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextField(
                      controller: sendPlaceController,
                      maxLines: null,
                      maxLength: 500,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFFF2F2F7),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xFF6229EE),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText:
                        "สถานทีนัดรับ",
                        hintStyle: const TextStyle(
                          color: Color(0xFFC7C7CC),
                          fontSize: 14,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.w300,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //todo time select
              // isLimitTime
              //     ? const SizedBox(
              //   height: 12,
              // )
              //     : Form(
              //   key: _formKey,
              //   child: Row(
              //     children: [
              //       const SizedBox(
              //         width: 12,
              //       ),
              //       Expanded(
              //         child: Row(
              //           children: [
              //             const SizedBox(width: 12,),
              //             Text.rich(
              //               TextSpan(
              //                 children: [
              //                   widget.timeSelected != null
              //                       ? TextSpan(
              //                     text: DateFormat("dd EEEE MMMM y h:m")
              //                         .format(
              //                       DateTime.fromMillisecondsSinceEpoch(
              //                         widget.timeSelected!,
              //                       ),
              //                     ),
              //                     style: const TextStyle(
              //                       color: Color(0xFF172026),
              //                       fontSize: 14,
              //                       fontFamily: 'Mitr',
              //                       fontWeight: FontWeight.w300,
              //                       height: 0,
              //                     ),
              //                   )
              //                       : const WidgetSpan(
              //                     child: SizedBox(),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       const SizedBox(
              //         width: 12,
              //       ),
              //     ],
              //   ),
              // ),
              //
              // //todo images
              // imageListOfProduct.isNotEmpty
              //     ? Container(
              //   alignment: Alignment.center,
              //   height: MediaQuery.of(context).size.width - 64,
              //   width: 320,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(100),
              //   ),
              //   child: Swiper(
              //     controller: swiperController,
              //     itemCount: widget.imageListOfProduct.length,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       final picture = widget.imageListOfProduct[index];
              //       return Image.file(
              //         File(picture),
              //         fit: BoxFit.cover,
              //       );
              //     },
              //     indicatorLayout: PageIndicatorLayout.COLOR,
              //     pagination: const SwiperPagination(),
              //     onIndexChanged: (index) {
              //       currentIndex = index;
              //     },
              //   ),
              // )
              //     : const SizedBox(
              //   width: 12,
              //   height: 12,
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              // AddImageButton(
              //   isImageContain: widget.imageListOfProduct.isNotEmpty,
              //   onAddImagePressed: () {
              //     setState(() {
              //       showOptions();
              //     });
              //   },
              //   onRemoveImagePressed: () {
              //     if (widget.imageListOfProduct.isNotEmpty) {
              //       setState(() {
              //         widget.imageListOfProduct.removeAt(currentIndex);
              //       });
              //     }
              //   },
              // ),
              //todo price,coins
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //price
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: coinsController,
                          maxLines: null,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0xFFF2F2F7),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0xFF6229EE),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText:
                            "ราคาโดยประมาณ",
                            hintStyle: const TextStyle(
                              color: Color(0xFFC7C7CC),
                              fontSize: 14,
                              fontFamily: 'Mitr',
                              fontWeight: FontWeight.w300,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //TODO Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // bool isChecked = useCoinToCreatePost(123, 123);//todo implement data
                        // if(isChecked){
                        //   uploadToDatabase();
                        // }
                      },
                      child: Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: ShapeDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF6229EE), Color(0xFF9267FE)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "POST!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Mitr",
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
