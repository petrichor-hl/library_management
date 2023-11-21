import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:library_management/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:library_management/models/report_doc_gia.dart';
import 'package:library_management/screens/report_docgia_chitiet.dart';

class BaoCaoDocGia extends StatefulWidget {
  const BaoCaoDocGia({required this.selectedYear, super.key});
  final int selectedYear;
  @override
  State<BaoCaoDocGia> createState() => _BaoCaoDocGiaState();
}

class _BaoCaoDocGiaState extends State<BaoCaoDocGia> {
  int _highestNum = 0;
  late List<TKDocGia> _readers;

  //màu chính và màu phụ
  Color mainColor = const Color.fromARGB(255, 4, 104, 138);
  Color secondaryColor = const Color.fromARGB(255, 229, 239, 243);
  Color thirdColor = const Color.fromARGB(255, 72, 184, 233);

  //Tính tổng độc giả theo 12 tháng trong năm
  //Truyền vào danh sách độc giả và năm được chọn
  List<int> _reportDocGiaInYear(List<TKDocGia> list, int selectedYear) {
    List<int> reportList = List<int>.filled(12, 0, growable: false);
    for (TKDocGia tkDocGia in list) {
      if (tkDocGia.year == selectedYear) {
        reportList[tkDocGia.month - 1]++;
      }
    }
    _highestNum = reportList.reduce((curr, next) => curr > next ? curr : next);
    return reportList;
  }

  late final Future<void> _listChartReaders = _getDocGia();
  Future<void> _getDocGia() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _readers = await dbProcess.queryDocGiaTheoThang();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _listChartReaders,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(50, 10, 70, 60),
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Số lượng các độc giả mới được thêm vào',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(child: LineChart(_lineChartData()))
            ],
          ),
        );
      },
    );
  }

  //
  // Dữ liệu cho chart Line
  //
  LineChartData _lineChartData() {
    final List<int> countDocGia = _reportDocGiaInYear(_readers, widget.selectedYear);
    int topValue = _highestNum - _highestNum % 10 + 10;
    late int showingTooltipSpot = -1;
    final List<FlSpot> list = <FlSpot>[];
    final LineChartBarData _lineChartBarData = _linesData(list, mainColor);
    for (var i = 0; i < 12; i++) {
      list.add(FlSpot(i + 1, countDocGia[i].toDouble()));
    }

    return LineChartData(
      titlesData: _buildAxes(),
      minX: 1,
      maxX: 12,
      baselineX: 1,
      minY: 0,
      maxY: topValue.toDouble(),
      showingTooltipIndicators: showingTooltipSpot != -1
          ? [
              ShowingTooltipIndicators([
                LineBarSpot(_lineChartBarData, showingTooltipSpot, _lineChartBarData.spots[showingTooltipSpot]),
              ])
            ]
          : [],
      //Xử lí khi tương tác với dữ liệu
      lineTouchData: LineTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) async {
            if (touchResponse?.lineBarSpots != null && event is FlTapUpEvent) {
              setState(() {
                final spotIndex = touchResponse?.lineBarSpots?[0].spotIndex ?? -1;
                if (spotIndex == showingTooltipSpot) {
                  showingTooltipSpot = -1;
                } else {
                  showingTooltipSpot = spotIndex;
                }
              });
            }
          },
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: secondaryColor,
            tooltipRoundedRadius: 5,
            tooltipBorder: const BorderSide(width: 1, color: Colors.transparent),
            showOnTopOfTheChartBoxArea: true,
            fitInsideHorizontally: true,
            tooltipMargin: -50,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map(
                (LineBarSpot touchedSpot) {
                  const textStyle = TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  );
                  return LineTooltipItem(
                    list[touchedSpot.spotIndex].y.toStringAsFixed(2),
                    textStyle,
                  );
                },
              ).toList();
            },
          ),
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
            return indicators.map(
              (int index) {
                const line = FlLine(color: Colors.grey, strokeWidth: 1, dashArray: [2, 7]);
                return TouchedSpotIndicatorData(
                  line,
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                      radius: 5,
                      color: secondaryColor,
                    ),
                  ),
                );
              },
            ).toList();
          },
          getTouchLineEnd: (_, __) => double.infinity),
      borderData: FlBorderData(border: const Border(bottom: BorderSide(width: 1), left: BorderSide(width: 1))),
      lineBarsData: [
        _lineChartBarData,
      ],
      gridData: FlGridData(
        drawHorizontalLine: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(
          color: mainColor,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

// Tạo viền và giá trị dưới
  FlTitlesData _buildAxes() {
    int topValue = _highestNum - _highestNum % 10 + 10;
    return FlTitlesData(
        show: true,
        // Build X axis.
        bottomTitles: AxisTitles(sideTitles: _bottomTitles),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: defaultGetTitle,
              reservedSize: 30,
              interval: (topValue / 5).toDouble(),
            ),
            axisNameWidget: const Text('ĐỘC GIẢ')),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)));
  }

// Chi tiết giá trị thanh dưới
  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 1:
              text = 'Th1';
              break;
            case 2:
              text = 'Th2';
              break;
            case 3:
              text = 'Th3';
              break;
            case 4:
              text = 'Th4';
              break;
            case 5:
              text = 'Th5';
              break;
            case 6:
              text = 'Th6';
              break;
            case 7:
              text = 'Th7';
              break;
            case 8:
              text = 'Th8';
              break;
            case 9:
              text = 'Th9';
              break;
            case 10:
              text = 'Th10';
              break;
            case 11:
              text = 'Th11';
              break;
            case 12:
              text = 'Th12';
              break;
          }

          return Text(text);
        },
      );

  // Dữ liệu một line
  LineChartBarData _linesData(List<FlSpot> listA, Color colorA) {
    return LineChartBarData(
        color: mainColor,
        spots: listA,
        isStepLineChart: false,
        isCurved: false,
        barWidth: 2,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          //gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [mainColor, Color.fromARGB(35, 4, 104, 138)]),
          color: colorA,
        ));
  }
}
