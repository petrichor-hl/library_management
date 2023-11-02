import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isCollapsed = false;
    return Drawer(
      child: Container(
        color: Colors.black,
      ),
    );
  }
}
