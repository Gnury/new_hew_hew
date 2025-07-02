import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'login_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  List<CurrentUser>? users;
  List<CurrentUser>? _filterData;
  String searchQuery = "";
  Timer? debounce;

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future<void> _updateUserCoins(String email, int delta) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(email);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDoc);
      final currentCoins = snapshot.data()?['coins'] ?? 0;
      transaction.update(userDoc, {'coins': currentCoins + delta});
    });
  }

  Future<void> _setUserCoins(String email, int newCoins) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .update({'coins': newCoins});
  }

  void _showAddCoinPopup(BuildContext context, CurrentUser user) {

    final TextEditingController coinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('เพิ่มเหรียญให้ ${user.email}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: coinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'จำนวนเหรียญ'),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [5, 10, 50, 100, 1000].map((amount) {
                  return ElevatedButton(
                    onPressed: () {
                      final current = int.tryParse(coinController.text) ?? 0;
                      final newAmount = current + amount;
                      coinController.text = newAmount.toString();
                    },
                    child: Text('+ $amount'),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () {
                final coinsToAdd = int.tryParse(coinController.text);
                if (coinsToAdd != null) {
                  _updateUserCoins(user.email, coinsToAdd);
                  Navigator.pop(context);
                }
              },
              child: const Text('ยืนยันเพิ่มเหรียญ'),
            ),
          ],
        );
      },
    );
  }

  void _showEditCoinPopup(BuildContext context, CurrentUser user) {
    final controller = TextEditingController(text: user.coins?.toString() ?? '0');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('แก้ไขเหรียญของ ${user.email}'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'จำนวนเหรียญใหม่'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newCoins = int.tryParse(controller.text);
                if (newCoins != null) {
                  Navigator.pop(context);
                  _setUserCoins(user.email, newCoins);
                }
              },
              child: const Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: "ค้นหาด้วยชื่อหรืออีเมล",
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xffF9AF23)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xffF9AF23)),
          ),
        ),
        onChanged: (val) {
          searchQuery = val.toLowerCase();
          _debouncedSearch(val);
        },
      ),
    );
  }

  void _debouncedSearch(String val) {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      if (users == null) return;

      final query = val.toLowerCase();
      final filtered = users!.where((user) {
        final email = user.email.toLowerCase();
        final name = '${user.name ?? ""} ${user.lastName ?? ""}'.toLowerCase();
        return email.contains(query) || name.contains(query);
      }).toList();

      setState(() {
        searchQuery = query;
        _filterData = filtered;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffF5F0F0),
      appBar: AppBar(
        title: const Text("HEW-HEW ADMIN"),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            
                final users = snapshot.data!.docs
                    .map((doc) => CurrentUser.fromJson(doc))
                    .toList();

                this.users = users;

                List<CurrentUser> displayList = searchQuery.isEmpty
                    ? users
                    : _filterData ?? [];
            
                return ListView.builder(
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final user = displayList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${user.name ?? "-"} ${user.lastName ?? "-"}', style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text('Email: ${user.email }'),
                                  Text('เบอร์โทร: ${user.phoneNumber ?? "-"}'),
                                  Text('เหรียญ: ${user.coins ?? 0}'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _showAddCoinPopup(context, user),
                                  child: const Text('เพิ่มเหรียญ'),
                                ),
                                const SizedBox(height: 4),
                                TextButton(
                                  onPressed: () => _showEditCoinPopup(context, user),
                                  child: const Text('แก้ไขเหรียญ'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
