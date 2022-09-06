import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:intl/intl.dart';

class StatisticsGraph extends StatefulWidget {
  const StatisticsGraph({Key? key}) : super(key: key);

  @override
  State<StatisticsGraph> createState() => _StatisticsGraphState();
}

class _StatisticsGraphState extends State<StatisticsGraph> {
  num kh = 0;
  num ro = 0;
  num tm = 0;
  num gr = 0;
  num mo = 0;
  num tu = 0;
  num we = 0;
  num th = 0;
  num fr = 0;
  num sa = 0;
  num su = 0;
  var _tooltipBehavior, _tooltipBehavior2, _tooltipBehavior3;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior2 = TooltipBehavior(enable: true);
    _tooltipBehavior3 = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff2986cc),
          title: const Text('احصائيات'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("problems").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("data");
            }
            if (snapshot.hasData) {
              for (int z = 0;
                  z < (snapshot.data as QuerySnapshot).docs.length;
                  z++) {
                int fa = int.parse(
                    (snapshot.data as QuerySnapshot).docs[z]['Request_num']);
                print((DateTime.fromMillisecondsSinceEpoch(166112262000)));
                var v = DateFormat('EEEE')
                    .format(DateTime.fromMillisecondsSinceEpoch(fa));
                if ((snapshot.data as QuerySnapshot).docs[z]['Branch'] ==
                    "الخلفاوي") {
                  ++kh;
                }
                if ((snapshot.data as QuerySnapshot).docs[z]['Branch'] ==
                    "روض الفرج") {
                  ++ro;
                }
                if ((snapshot.data as QuerySnapshot).docs[z]['Status'] ==
                    "تم") {
                  ++tm;
                }
                if ((snapshot.data as QuerySnapshot).docs[z]['Status'] ==
                    "جار") {
                  ++gr;
                }
                if (v == "Monday") {
                  ++mo;
                }
                if (v == "Tuesday") {
                  ++tu;
                }
                if (v == "Wednesday") {
                  ++we;
                }
                if (v == "Thursday") {
                  ++th;
                }
                if (v == "Friday") {
                  ++fr;
                }
                if (v == "Saturday") {
                  ++sa;
                }
                if (v == "Sunday") {
                  ++su;
                }
              }
              List<_PieData> dataBranch = [
                _PieData("الخلفاوي", kh, "الخلفاوي"),
                _PieData("روض الفرج", ro, "روض الفرج")
              ];
              List<_PieData> dataStatus = [
                _PieData("تم", tm, "تم"),
                _PieData("جار", gr, "جار")
              ];
              List<SalesData> Month = [
                SalesData('Monday', mo),
                SalesData('Tuesday', tu),
                SalesData('Wednesday', we),
                SalesData('Thursday', th),
                SalesData('Friday', fr),
                SalesData('Saturday', sa),
                SalesData('Sunday', su),
              ];
              return ListView(children: [
                Column(children: [
                  //Initialize the chart widget
                  SfCircularChart(
                      title: ChartTitle(text: 'المشاكل فى الفرعين'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: _tooltipBehavior,
                      series: <PieSeries<_PieData, String>>[
                        PieSeries<_PieData, String>(
                            explode: true,
                            explodeIndex: 0,
                            dataSource: dataBranch,
                            xValueMapper: (_PieData data, _) => data.xData,
                            yValueMapper: (_PieData data, _) => data.yData,
                            dataLabelMapper: (_PieData data, _) => data.text,
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                            ),
                            enableTooltip: true),
                      ]),
                  SfCircularChart(
                      palette: [Colors.green, Colors.yellow],
                      title: ChartTitle(text: 'حالات المشاكل'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: _tooltipBehavior2,
                      series: <PieSeries<_PieData, String>>[
                        PieSeries<_PieData, String>(
                            explode: true,
                            explodeIndex: 0,
                            dataSource: dataStatus,
                            xValueMapper: (_PieData data, _) => data.xData,
                            yValueMapper: (_PieData data, _) => data.yData,
                            dataLabelMapper: (_PieData data, _) => data.text,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                            enableTooltip: true),
                      ]),
                  SfCartesianChart(
                      enableAxisAnimation: true,
                      palette: [
                        Colors.green,
                        Colors.deepOrange,
                        Colors.indigo,
                        Colors.yellowAccent,
                        Colors.cyan,
                        Colors.red,
                        Colors.lime
                      ],
                      // Initialize category axis
                      primaryXAxis: CategoryAxis(
                        isVisible: true,
                      ),
                      tooltipBehavior: _tooltipBehavior3,
                      series: <ColumnSeries<SalesData, String>>[
                        ColumnSeries<SalesData, String>(
                            // Bind data source
                            dataSource: Month,
                            xValueMapper: (SalesData sales, _) => sales.year,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            enableTooltip: true)
                      ])
                ]),
              ]);
            }
            return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 12),
                  Text('Loading..')
                ],
              ),
            );
          },
        ));
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);

  final String xData;
  final num yData;
  final String text;
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final num sales;
}
