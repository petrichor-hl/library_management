import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/screens/regulations/regulation_item.dart';

class Regulations extends StatelessWidget {
  const Regulations({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quy định',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(4),
            RegulationItem(content: '1. Số ngày mượn tối đa của một cuốn sách: ', regulation: 'SoNgayMuonToiDa'),
            RegulationItem(content: '2. Số sách được mượn tối đa của một độc giả: ', regulation: 'SoSachMuonToiDa'),
            RegulationItem(content: '3. Mức tiền phạt cho mỗi cuốn sách mượn quá hạn: ', regulation: 'MucThuTienPhat'),
            RegulationItem(content: '4. Số tuổi tối thiểu của được phép mượn sách:', regulation: 'TuoiToiThieu'),
            RegulationItem(content: '5. Phí tạo thẻ cho độc giả: ', regulation: 'PhiTaoThe'),
            RegulationItem(content: '6. Thời gian hiệu lực của thẻ độc giả: ', regulation: 'ThoiHanThe'),
            //   const Divider(),
            //   Expanded(
            //     child: StatefulBuilder(builder: (ctx, setStateNoiQuy) {
            //       return MouseRegion(
            //         onEnter: (event) => setStateNoiQuy(
            //           () => isHoverNoiQuy = true,
            //         ),
            //         onHover: (_) => setStateNoiQuy(
            //           () => isHoverNoiQuy = true,
            //         ),
            //         onExit: (_) => setStateNoiQuy(
            //           () => isHoverNoiQuy = false,
            //         ),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.stretch,
            //           children: [
            //             Row(
            //               children: [
            //                 const Text(
            //                   'Nội quy thư viện',
            //                   style: TextStyle(
            //                     fontSize: 32,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //                 const Spacer(),
            //                 AnimatedSwitcher(
            //                   /* Thời gian hiệu ứng xuất hiện */
            //                   duration: const Duration(milliseconds: 150),
            //                   /* Thời gian hiệu ứng biến mất */
            //                   reverseDuration: const Duration(milliseconds: 300),
            //                   transitionBuilder: (child, animation) => ScaleTransition(
            //                     scale: animation,
            //                     child: child,
            //                   ),
            //                   child: isHoverNoiQuy
            //                       ? IconButton(
            //                           onPressed: () {},
            //                           icon: const Icon(Icons.edit_rounded),
            //                           style: IconButton.styleFrom(
            //                             shape: RoundedRectangleBorder(
            //                               borderRadius: BorderRadius.circular(10),
            //                             ),
            //                             padding: const EdgeInsets.all(10),
            //                             foregroundColor: Colors.white,
            //                             backgroundColor: Theme.of(context).colorScheme.primary,
            //                           ),
            //                         )
            //                       : const SizedBox(),
            //                 ),
            //               ],
            //             ),
            //             const Gap(4),
            //             Expanded(
            //               child: SingleChildScrollView(
            //                 child: Text(
            //                   ThamSoQuyDinh.getThamSo('NoiQuy'),
            //                   style: const TextStyle(
            //                     fontSize: 20,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     }),
            //   )
          ],
        ),
      ),
    );
  }
}
