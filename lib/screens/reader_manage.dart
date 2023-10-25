import 'package:flutter/material.dart';

class ReaderManage extends StatefulWidget {
  const ReaderManage({super.key});

  @override
  State<ReaderManage> createState() => _ReaderManageState();
}

class _ReaderManageState extends State<ReaderManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ColoredBox(
        color: Colors.amber,
        child: SizedBox.expand(),
      ),
    );
  }
}
