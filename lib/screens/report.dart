import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:library_management/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:library_management/models/report_doc_gia.dart';

class BaoCaoDocGia extends StatefulWidget {
  const BaoCaoDocGia({required this.selectedYear, super.key});
  final int selectedYear;
  @override
  State<BaoCaoDocGia> createState() => _BaoCaoDocGiaState();
}

class _BaoCaoDocGiaState extends State<BaoCaoDocGia> {
  int _highestNum = 0;
  late List<TKDocGia> _readers;
  Color mainColor = const Color.fromARGB(255, 4, 104, 138);

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
          padding: const EdgeInsets.fromLTRB(50, 50, 70, 60),
          child: LineChart(_lineChartData()),
        );
      },
    );
  }

  LineChartData _lineChartData() {
    final List<int> countDocGia = _reportDocGiaInYear(_readers, widget.selectedYear);
    int topValue = _highestNum - _highestNum % 10 + 10;
    final List<FlSpot> list = <FlSpot>[];
    for (var i = 0; i < 12; i++) {
      list.add(FlSpot(i + 1, countDocGia[i].toDouble()));
      //if(highest_state < );
    }

    return LineChartData(
      //backgroundColor: Color.fromARGB(255, 2, 4, 44),
      titlesData: _buildAxes(),
      minX: 1,
      maxX: 12,
      baselineX: 1,
      minY: 0,
      maxY: topValue.toDouble(),
      lineTouchData: LineTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
            // TODO : Utilize touch event here to perform any operation
          },
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipRoundedRadius: 5,
            tooltipBorder: BorderSide(width: 2, color: Colors.black),
            showOnTopOfTheChartBoxArea: false,
            fitInsideHorizontally: true,
            tooltipMargin: 0,
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
                return const TouchedSpotIndicatorData(
                  line,
                  FlDotData(show: false),
                );
              },
            ).toList();
          },
          getTouchLineEnd: (_, __) => double.infinity),
      borderData: FlBorderData(border: const Border(bottom: BorderSide(), left: BorderSide())),
      lineBarsData: [
        LineChartBarData(
            color: mainColor,
            spots: list,
            isStepLineChart: false,
            isCurved: false,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              //gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [mainColor, Color.fromARGB(35, 4, 104, 138)]),
              color: Color.fromARGB(255, 4, 104, 138),
            ))
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
          sideTitles: SideTitles(showTitles: true, getTitlesWidget: defaultGetTitle, reservedSize: 30, interval: (topValue / 5).toDouble()),
        ),
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

  // tooltip giá trị
}
