import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/utils/extension.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/report_the_loai_muon.dart';

class BaoCaoTheLoaiSachMuon extends StatefulWidget {
  const BaoCaoTheLoaiSachMuon({required this.selectedYear, super.key});

  final int selectedYear;
  @override
  State<BaoCaoTheLoaiSachMuon> createState() => _BaoCaoTheLoaiSachMuonState();
}

class _BaoCaoTheLoaiSachMuonState extends State<BaoCaoTheLoaiSachMuon> {
  late List<TKTheLoai> _bookCategory;

  var isHoverYearBtn = false;
  //màu chính và màu phụ
  Color mainColor = const Color.fromARGB(255, 4, 104, 138);
  Color secondaryColor = const Color.fromARGB(255, 229, 239, 243);
  Color thirdColor = const Color.fromARGB(255, 72, 184, 233);

  late final Future<void> _listCategory = _getCategory();

  Map<String, double> _reportTLSachMuonInYear(List<TKTheLoai> list, int selectedYear) {
    Map<String, double> emptyList = {};
    for (TKTheLoai tkTLSachMuon in list) {
      if (tkTLSachMuon.year == selectedYear) {
        emptyList[tkTLSachMuon.theLoai.capitalizeFirstLetter()] = tkTLSachMuon.quanity.toDouble();
      }
    }
    print(emptyList);
    return emptyList;
  }

  Future<void> _getCategory() async {
    await Future.delayed(kTabScrollDuration);
    _bookCategory = await dbProcess.queryTheLoaiSachMuonTheoNam();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _listCategory,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_bookCategory == null) {
            return Dialog(
                backgroundColor: Colors.white,
                child: SizedBox(
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Không có cuốn sách nào được mượn',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          )
                        ],
                      ),
                    )));
          } else {
            return Dialog(
              backgroundColor: Colors.white,
              child: SizedBox(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Biểu đồ các thể loại chiếm trong sách mượn',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          )
                        ],
                      ),
                      const Gap(10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 70, 60),
                        child: Center(
                          child: PieChart(
                            dataMap: _reportTLSachMuonInYear(_bookCategory, widget.selectedYear)!,
                            animationDuration: const Duration(milliseconds: 800),
                            chartLegendSpacing: 32,
                            chartRadius: MediaQuery.of(context).size.width / 3.2,
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 32,
                            legendOptions: const LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.right,
                              showLegends: true,
                              legendShape: BoxShape.circle,
                              legendTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  // Lay mau ngau nhien
  Color getRandomColor() {
    return Color((List.generate(3, (index) => index * 100 + 100)..shuffle()).first);
  }
}
