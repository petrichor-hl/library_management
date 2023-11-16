import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_management/models/icons.dart';

class SideBarPage extends StatelessWidget {
  const SideBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    double space = 31;
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: 210,
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/logo/Asset 1.png',
                      width: 31,
                      height: 33.25,
                    ),
                    Text("Reader"),
                    SvgPicture.asset(
                      'assets/not_click.svg',
                      width: 16,
                      height: 16,
                    )
                  ],
                ),
                SizedBox(height: space),
                ListTile(
                  title: Text("Trang chủ"),
                  leading: iconsBlackList[0].img,
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(color: Colors.blue),
        )
      ],
    ));
  }
}
