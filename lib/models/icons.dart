import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconsLibrary {
  String title;
  SvgPicture img;
  IconsLibrary({required this.title, required this.img});
}

final List<IconsLibrary> iconsBlackList = [
  IconsLibrary(
      title: "Trang chủ",
      img: SvgPicture.asset("assets/icons/black_version/ic_home.svg")),
  IconsLibrary(
      title: "Độc giả",
      img: SvgPicture.asset('assets/icons/black_version/ic_doc_gia.svg')),
  IconsLibrary(
      title: "Quản lý sách",
      img: SvgPicture.asset('assets/icons/black_version/ic_qly_sach.svg')),
  IconsLibrary(
      title: "Mượn trả",
      img: SvgPicture.asset('assets/icons/black_version/ic_muon_tra.svg')),
];
