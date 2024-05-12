import 'package:card_swiper/card_swiper.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:new_hew_hew/components/post_card.dart';
import 'package:new_hew_hew/pages/create_post_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // final SwiperController swiperController = SwiperController();
  final SerchController = TextEditingController();

  // String searchQuery = "";

  // void debouncedSearch(String value) {
  //   setState(() {
  //     searchQuery = value;
  //   });
  // }

  // Widget PostListView(){
  //   // if(!titleName.contain(searchQuery)){return Container();}//search from data base
  //   return ListView.builder(itemBuilder: (context, index){
  //     return PostCard();
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/images/icon-hew-hew.png',
              fit: BoxFit.cover,
              height: 60,
            ),
            const Spacer(),
            const Text(
              'โพสต์รับหิ้ว',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const Spacer(),

            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.notifications_active,
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            TextFormField(
              controller: SerchController,
              // onChanged: (val) {
              //   EasyDebounce.debounce(
              //     'searchDebounce', // debounce identifier
              //     const Duration(
              //         milliseconds:
              //         500), // debounce duration
              //         () => debouncedSearch(
              //         val), // function to be executed
              //   );
              // },

            ),
            const Icon(
              Icons.search,
              color: Colors.black,
            ),
            PostCard(),
            // PostListView(),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const CreatePostPage(),
                      ),);
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
                            "LET’S CHECK",
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
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //
      //   ],
      // ),
    );
  }
}
