import 'package:flutter/material.dart';
import 'package:library_management/components/my_search_bar.dart';

class TatCaSach extends StatefulWidget {
  const TatCaSach({
    super.key,
    required this.openThemSachMoiForm,
  });

  final void Function() openThemSachMoiForm;

  @override
  State<TatCaSach> createState() => _TatCarSachDState();
}

class _TatCarSachDState extends State<TatCaSach> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: SizedBox(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MySearchBar(
                controller: TextEditingController(),
                onSearch: () {},
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Tất cả Sách',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: widget.openThemSachMoiForm,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Thêm mới sách'),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Text(
                                  'Mã Sách',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  'Tên Đầu sách',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  'Lần Tái bản',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'NXB',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          // children: List.generate(
                          //   _enterbookCards.length,
                          //   (index) {
                          //     return Row(
                          //       children: [
                          //         Expanded(
                          //           child: Padding(
                          //             padding: const EdgeInsets.only(
                          //               right: 15,
                          //             ),
                          //             child: Text(_enterbookCards[index].maCTPN.toString()),
                          //           ),
                          //         ),
                          //         Expanded(
                          //           child: Padding(
                          //             padding: const EdgeInsets.only(
                          //               right: 15,
                          //             ),
                          //             child: Text(_enterbookCards[index].maCTPN.toString()),
                          //           ),
                          //         ),
                          //         Expanded(
                          //           child: Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //               horizontal: 15,
                          //             ),
                          //             child: Text(_enterbookCards[index].soLuong.toString()),
                          //           ),
                          //         ),
                          //         Expanded(
                          //           child: Padding(
                          //             padding: const EdgeInsets.only(
                          //               left: 15,
                          //             ),
                          //             child: Text(_enterbookCards[index].donGia.toVnCurrencyWithoutSymbolFormat()),
                          //           ),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
