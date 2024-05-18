import 'package:flutter/material.dart';
import 'package:new_hew_hew/pages/feed_page.dart';

void main() {
  runApp(const MyApp());
  // WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FeedPage(),
      ),
    );

  }
}
