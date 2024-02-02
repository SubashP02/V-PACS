import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:vizai/main.dart';

void main() {
  runApp(LoadWeightPage());
}

class LoadWeightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLoadWeightHomePage(title: 'Load Weight'),
    );
  }
}

class MyLoadWeightHomePage extends StatefulWidget {
  MyLoadWeightHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyLoadWeightHomePageState createState() => _MyLoadWeightHomePageState();
}

class _MyLoadWeightHomePageState extends State<MyLoadWeightHomePage> {
  List<LoadValue> _chartData = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  bool isImageActive = true;
  double loadvalue = 500; // Initial value
  List<double> _loadData = [];

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://13.127.214.1:3000/api/v1/VID_12348/vehicledata/2024-01-31/2024-01-31'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final List<dynamic> user = responseData['user'];

        if (user.isNotEmpty) {
          _loadData.add(user[0]['LoadValue'].toDouble());
          _loadData.add(user[1]['LoadValue'].toDouble());
          _loadData.add(user[2]['LoadValue'].toDouble());
          _loadData.add(user[3]['LoadValue'].toDouble());
          _loadData.add(user[4]['LoadValue'].toDouble());

          setState(() {
            _chartData = getLoadWeightData(loadvalue);
          });
        }
      } else {
        throw Exception(
            'API request failed with status: ${responseData['connection_status']}');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: -50,
              left: 0,
              child: Image.asset(
                'images/Background.png',
                width: screenWidth,
                height: screenHeight * 0.22,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: screenHeight * 0.05,
              left: screenWidth * 0.06,
              right: 0,
              child: Image.asset(
                'images/Vizai_Monitor.png',
                width: screenWidth * 0.16,
                height: screenHeight * 0.1,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned(
              top: screenHeight * 0.0,
              left: screenWidth * 0.02,
              child: Image.asset(
                'images/Home.png',
                width: screenWidth * 0.14,
                height: screenHeight * 0.1,
              ),
            ),
            Positioned(
              top: screenHeight * 0.01,
              right: screenWidth * 0.04,
              child: Image.asset(
                'images/Profile.png',
                width: screenWidth * 0.12,
                height: screenHeight * 0.08,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Column(
              children: [
                SizedBox(height: screenHeight * 0.2),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: screenWidth * 0.05),
                        Transform.scale(
                          scale: 1.2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()),
                              );
                            },
                            child: Image.asset('images/back.png'),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.06),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Load',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: screenWidth * 0.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Vehicle ID',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(102, 102, 102, 1),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: screenWidth * 0.08),
                        Row(
                          children: [
                            Text(
                              '5000',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: screenWidth * 0.1,
                                fontWeight: FontWeight.bold,
                                color: isImageActive
                                    ? Color.fromRGBO(236, 186, 29, 1)
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.005),
                            Text(
                              'lbs',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.bold,
                                color: isImageActive
                                    ? Color.fromARGB(255, 90, 90, 90)
                                    : Color.fromRGBO(18, 18, 18, 1),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: screenWidth * 0.08,
                            height: screenHeight * 0.015),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: isImageActive,
                              child: Transform.scale(
                                scale: 1.4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isImageActive = !isImageActive;
                                    });
                                  },
                                  child:
                                      Image.asset('images/active.png'),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !isImageActive,
                              child: Transform.scale(
                                scale: 1.3,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isImageActive = !isImageActive;
                                    });
                                  },
                                  child:
                                      Image.asset('images/inactive.png'),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.007),
                            Text(
                              isImageActive ? 'Now' : '1 min ago',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(85, 85, 85, 1)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.025),
                Container(
                  child: Row(
                    children: [
                      SizedBox(width: screenWidth * 0.02),
                      Image.asset('images/7d.png'),
                      SizedBox(width: screenWidth * 0.02),
                      Image.asset('images/custom.png'),
                      SizedBox(width: screenWidth * 0.02),
                      Image.asset('images/from.png'),
                      SizedBox(width: screenWidth * 0.01),
                      Image.asset('images/mid.png'),
                      SizedBox(width: screenWidth * 0.005),
                      Image.asset('images/to.png'),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          screenWidth * 0.05), // Adjust space on both sides
                  child: Container(
                    height: screenHeight * 0.5,
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Load Weight'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: _tooltipBehavior,
                      primaryXAxis: DateTimeAxis(
                        title: AxisTitle(text: 'Date'),
                        majorGridLines: MajorGridLines(width: 0),
                        minorGridLines: MinorGridLines(width: 0),
                        majorTickLines: MajorTickLines(size: 0),
                        minorTickLines: MinorTickLines(size: 0),
                        labelIntersectAction: AxisLabelIntersectAction.hide,
                        dateFormat: DateFormat.MMMd(),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Load Weight (lbs)'),
                        isVisible: false,
                      ),
                      series: <LineSeries<LoadValue, DateTime>>[
                        LineSeries<LoadValue, DateTime>(
                          name: 'Load_Weight',
                          dataSource: _chartData,
                          xValueMapper: (LoadValue data, _) => data.date,
                          yValueMapper: (LoadValue data, _) =>
                              data.apiPercentage,
                          enableTooltip: true,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<LoadValue> getLoadWeightData(double apiPercentage) {
    final List<LoadValue> chartData = [
      LoadValue(DateTime(2024, 5, 6), _loadData[0]),
      LoadValue(DateTime(2024, 5, 7), _loadData[1]),
      LoadValue(DateTime(2024, 5, 8), _loadData[2]),
      LoadValue(DateTime(2024, 5, 9), _loadData[3]),
      LoadValue(DateTime(2024, 5, 10), _loadData[4]),
    ];
    return chartData;
  }
}

class LoadValue {
  LoadValue(this.date, this.apiPercentage);

  final DateTime date;
  final double apiPercentage;

  factory LoadValue.fromJson(Map<String, dynamic> json) {
    return LoadValue(
      DateTime.parse(json['date']),
      json['apiPercentage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'apiPercentage': apiPercentage,
      };
}
