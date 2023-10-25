import 'package:flutter/material.dart';

class BookManage extends StatefulWidget {
  const BookManage({super.key});

  @override
  State<BookManage> createState() => _BookManageState();
}

class _BookManageState extends State<BookManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ColoredBox(
        color: Colors.blueGrey,
        child: SizedBox.expand(),
      ),
    );
  }
}
