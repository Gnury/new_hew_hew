import 'dart:developer';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_hew_hew/pages/bottom_navigator_screen.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../components/add_image_button.dart';
import '../firebase/firebase_service_api.dart';
import '../models/user.dart';
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
  final swiperController = SwiperController();
  DateTime? selectDateTime;
  final bool getPost = false;
  CurrentUser? currentUser;
  FirebaseService userService = FirebaseService();

  int currentIndex = 0;
  bool isLimitTime = false;
  late final List<String> imageListOfProduct = [];

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    var thisUser = await userService.getUser();
    setState(() {
      if (thisUser == null) return;
      currentUser = thisUser;
    });
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
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
      );
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
      final docRef = FirebaseFirestore.instance.collection("posts").doc();

      await docRef.set({
        "post_title": titleController.text,
        "buy_place": buyPlaceController.text,
        "send_place": sendPlaceController.text,
        "coins": int.parse(coinsController.text),
        "due_date": selectDateTime?.toUtc(),
        "image_url_list": downloadUrls,
        "Timestamp": Timestamp.now(),
        "get_post": getPost,
        "name": currentUser?.name,
        "last_name": currentUser?.lastName,
        "image_url": currentUser?.imageUrl,
        "email": currentUser?.email,
        "id": docRef,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "receive_user_email": "",
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
                  color: Color(0xffF9AF23),
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
                              color: Color(0xffF9AF23),
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
                              color: Color(0xffF9AF23),
                            ),
                            Text(
                              'อัปโหลด',
                              style: TextStyle(
                                color: Color(0xffF9AF23),
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
                              color: Color(0xffF9AF23),
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
                              color: Color(0xffF9AF23),
                            ),
                            Text(
                              'ถ่ายภาพ',
                              style: TextStyle(
                                color: Color(0xffF9AF23),
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

  Widget _showDateTime() {
    if (selectDateTime == null) {
      return Container();
    }

    final dateFormat =
        DateFormat("EEEE dd MMMM hh:mm a").format(selectDateTime!);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF2F2F7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(dateFormat),
        ],
      ),
    );
  }

  onSelectDateTime() async {
    final selectedDateTime = await dateTimePicker();
    setState(() {
      selectDateTime = selectedDateTime;
    });
    print("datetimeseclect $selectDateTime");
  }

  dateTimePicker() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );
    return dateTime;
  }

  Future<bool> deductCoins(int userCoins) async {
    if (userCoins >= 10) {
      userCoins -= 10;
      await userService.updateCoin(email: currentUser?.email, coin: userCoins);
      return true;
    }
    return false;
  }

  Widget _form() {
    int userCoins = currentUser?.coins ?? 0;
    int postFee = 10;
    double maxAllowedCoins = userCoins * 0.8;
    int maxInputValue = (maxAllowedCoins - postFee).floor();
    String maxValueCanCreate = maxInputValue.toString();

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            //Product name
            TextField(
              controller: titleController,
              maxLines: null,
              maxLength: 100,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xFFA8A8A8),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xffF9AF23),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "ชื่อสินค้า",
                hintStyle: const TextStyle(
                  color: Color(0xFFA8A8A8),
                  fontSize: 14,
                  fontFamily: 'Mitr',
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),
            //Descriptions

            TextField(
              controller: buyPlaceController,
              maxLines: null,
              maxLength: 500,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xFFA8A8A8),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xffF9AF23),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "สถานที่ซื้อของ",
                hintStyle: const TextStyle(
                  color: Color(0xFFA8A8A8),
                  fontSize: 14,
                  fontFamily: 'Mitr',
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            //Descriptions

            TextField(
              controller: sendPlaceController,
              maxLines: null,
              maxLength: 500,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xFFA8A8A8),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xffF9AF23),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "สถานทีนัดรับ",
                hintStyle: const TextStyle(
                  color: Color(0xFFA8A8A8),
                  fontSize: 14,
                  fontFamily: 'Mitr',
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            TextField(
              controller: coinsController,
              maxLines: null,
              maxLength: 10,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int enteredValue = int.tryParse(value) ?? 0;

                if (enteredValue + postFee > maxAllowedCoins) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("ใช้เหรียญมากเกินไป"),
                        content: Text(
                            "คุณสามารถใช้เหรียญได้ไม่เกิน ${(maxAllowedCoins - postFee).floor()} เหรียญ\n(หลังหักค่าธรรมเนียมโพสต์ 10 เหรียญ)"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("ตกลง"),
                          ),
                        ],
                      ),
                    );
                  });
                  coinsController.text = maxInputValue.toString();
                  coinsController.selection = TextSelection.fromPosition(
                    TextPosition(offset: coinsController.text.length),
                  );
                }
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xFFA8A8A8),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Color(0xffF9AF23),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "ราคาโดยประมาณ (เหรียญ)",
                hintStyle: const TextStyle(
                  color: Color(0xFFA8A8A8),
                  fontSize: 14,
                  fontFamily: 'Mitr',
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
                suffixText: 'เหรียญ',
                suffixStyle: const TextStyle(
                  color: Color(0xffF9AF23),
                  fontSize: 14,
                  fontFamily: 'Mitr',
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              "*ต้องมีเหรียญมากกว่า $maxValueCanCreate เหรียญ*",
              style: const TextStyle(
                color: Colors.red,
                fontSize: 17,
              ),
            ),

            const SizedBox(
              height: 12,
            ),
            _showDateTime(),
            const SizedBox(
              height: 12,
            ),
            //time select
            _selectTimeButton(),
            const SizedBox(
              height: 12,
            ),
            //images
            _addImage(),
            const SizedBox(
              height: 12,
            ),
            _addImageButton(),

            const SizedBox(
              height: 24,
            ),
            _postButton()
          ],
        ),
      ),
    );
  }

  Widget _selectTimeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            onSelectDateTime();
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(370, 50),
            backgroundColor: const Color(0xffF9AF23),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              color: Color(0xFF172026),
              fontSize: 16,
              fontFamily: 'Mitr',
              fontWeight: FontWeight.w300,
              height: 0,
            ),
          ),
          child: const Text(
            "เลือกเวลาในการรับสินค้า",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _addImage() {
    return imageListOfProduct.isNotEmpty
        ? Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width - 64,
            width: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Swiper(
              controller: swiperController,
              itemCount: imageListOfProduct.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final picture = imageListOfProduct[index];
                return Image.file(
                  File(picture),
                  fit: BoxFit.cover,
                );
              },
              indicatorLayout: PageIndicatorLayout.COLOR,
              pagination: const SwiperPagination(),
              onIndexChanged: (index) {
                currentIndex = index;
              },
            ),
          )
        : const SizedBox(
            width: 12,
            height: 12,
          );
  }

  Widget _addImageButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AddImageButton(
          isImageContain: imageListOfProduct.isNotEmpty,
          onAddImagePressed: () {
            setState(() {
              showSelectImageOptions();
            });
          },
          onRemoveImagePressed: () {
            if (imageListOfProduct.isNotEmpty) {
              setState(() {
                imageListOfProduct.removeAt(currentIndex);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _postButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffF9AF23),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: const Size(100, 50),
        textStyle: const TextStyle(
          color: Color(0xFF172026),
          fontSize: 18,
          fontFamily: 'Mitr',
          fontWeight: FontWeight.bold,
          height: 0,
        ),
      ),
      onPressed: () async {
        int userCoins = currentUser?.coins ?? 0;
        int postFee = 10;
        int inputCoins = int.tryParse(coinsController.text) ?? 0;

        double maxAllowed = userCoins * 0.8;
        int maxUsable = userCoins - postFee;

        if (userCoins < postFee) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("เหรียญไม่พอ"),
              content: const Text("คุณต้องมีเหรียญอย่างน้อย 10 เหรียญเพื่อสร้างโพสต์"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ตกลง"),
                ),
              ],
            ),
          );
          return;
        }

        if (inputCoins > maxUsable || inputCoins > maxAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("จำนวนเหรียญไม่ถูกต้อง"),
              content: Text(
                  "คุณสามารถใช้เหรียญได้ไม่เกิน ${maxUsable < maxAllowed ? maxUsable : maxAllowed.floor()} เหรียญ\n(หลังหักค่าธรรมเนียมโพสต์ $postFee เหรียญ และจำกัดไม่เกิน 80% ของเหรียญที่มี)"
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ตกลง"),
                ),
              ],
            ),
          );
          return;
        }

        bool canDeduct = await deductCoins(userCoins);
        if (canDeduct) {
          uploadToDatabase();
          Navigator.pop(context);
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("เหรียญไม่พอ"),
              content: const Text("คุณต้องมีเหรียญอย่างน้อย 10 เหรียญเพื่อสร้างโพสต์"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ตกลง"),
                ),
              ],
            ),
          );
        }
      },
      child: const Text("POST"),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          color: Color(0xFFFF3131),
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
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    builder: (context) =>
                                        const BottomNavigatorScreen(),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
        title: const Row(
          children: [
            Spacer(),
            Text(
              'สร้างโพสต์',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            SizedBox(
              width: 45,
            ),
          ],
        ),
      ),
      //input field
      body: _form(),
    );
  }
}
