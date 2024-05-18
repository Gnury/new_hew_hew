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
  final swiperController = SwiperController();
  final SerchController = TextEditingController();

  String searchQuery = "";

  void debouncedSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  Widget _searchBar() {
    return Row(
      children: [
        const Icon(
          Icons.search,
          color: Colors.black,
        ),
        Expanded(
          child: TextFormField(
            controller: SerchController,
            onChanged: (val) {
              EasyDebounce.debounce(
                'searchDebounce', // debounce identifier
                const Duration(milliseconds: 500), // debounce duration
                () => debouncedSearch(val), // function to be executed
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _createPostButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(
            Icons.add_circle,
            color: Color(0xfff9af23),
            size: 70,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePostPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F0F0),
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
            _searchBar(),
            PostCard(
              swiperController: swiperController,
              postDetails: const [],
            ),
          ],
        ),
      ),
      floatingActionButton: _createPostButton(),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //
      //   ],
      // ),
    );
  }
}
// }
