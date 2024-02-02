import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vizai/batteryvoltageg.dart';
import 'package:vizai/hydralicpressuregauge.dart';
import 'package:vizai/loadvaluegauge.dart';
import 'package:vizai/map_page.dart';
import 'package:vizai/motorcurrentgauge.dart';
import 'package:vizai/motortempgauge.dart';
import 'dart:math' as math;
import 'package:vizai/loadpage.dart';

import 'package:vizai/variable.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> {
  void initState() {
    super.initState();
    fetchData(); // Fetch data directly when the widget is created
  }

  fetchData() async {
    print('Fetching users...');
    const url = 'http://13.127.214.1:3000/api/v1/VID_12348/vehicledata/2024-01-31/2024-01-31';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        DataHolder.users = json['user'];
        DataHolder.batteryValue = int.tryParse(DataHolder.users.isNotEmpty
                ? DataHolder.users[0]['BatteryVoltage'].toString()
                : '') ??
            0;
        DataHolder.LoadValue = int.tryParse(DataHolder.users.isNotEmpty
                ? DataHolder.users[0]['LoadValue'].toString()
                : '') ??
            0;
        DataHolder.MotorTemp = int.tryParse(DataHolder.users.isNotEmpty
                ? DataHolder.users[0]['MotorTemperature'].toString()
                : '') ??
            0;
        DataHolder.MotorCurrent = int.tryParse(DataHolder.users.isNotEmpty
                ? DataHolder.users[0]['MotorPower'].toString()
                : '') ??
            0;
        DataHolder.HydraulicPressure = int.tryParse(DataHolder.users.isNotEmpty
                ? DataHolder.users[0]['HydraulicPressure'].toString()
                : '') ??
            0;
        print("data ${DataHolder.data}");
      });
      print('Users fetched successfully');
    } else {
      print('Failed to fetch users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            title: Text(
              'V-PACS',
              style: TextStyle(
                  color: Color.fromARGB(235, 0, 0, 0),
                  fontSize: 29,
                  fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),
          body: YourCustomWidget()

          // Replace with your custom widget
          ),
    );
  }
}

class YourCustomWidget extends StatefulWidget {
  @override
  State<YourCustomWidget> createState() => _YourCustomWidgetState();
}

class _YourCustomWidgetState extends State<YourCustomWidget> {
  bool mapFullScreenView = false;

  void handleMapClick() {
    print("This is handleMapClick ${mapFullScreenView}");

    // mapFullScreenView = !mapFullScreenView;
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    setState(() {
      // mapFullScreenView = false;
      mapFullScreenView = !mapFullScreenView;
    });
    // });
  }

  // void handleMapClick1() {
  //   print("This is called ${mapFullScreenView}");
  //   mapFullScreenView = false;
  //   // WidgetsBinding.instance!.addPostFrameCallback((_) {
  //   // setState(() {
  //   //   mapFullScreenView = !mapFullScreenView;
  //   // });
  //   // });
  // }

  callback(newvalue) {
    print("This is callback ${newvalue}");
    setState(() {
      // mapFullScreenView = !mapFullScreenView;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: screenHeight * 0.28,
              right: screenWidth * 0.77,
              child: Text(
                "Battery",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.265,
              right: screenWidth * 0.81,
              child: Text(
                "%",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.28,
              right: screenWidth * 0.46,
              child: Text(
                "Load",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.265,
              right: screenWidth * 0.475,
              child: Text(
                "kg",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.28,
              right: screenWidth * 0.13,
              child: Text(
                "Pressure",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.265,
              right: screenWidth * 0.17,
              child: Text(
                "psi",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.12,
              right: screenWidth * 0.60,
              child: Text(
                "Power",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.12,
              right: screenWidth * 0.22,
              child: Text(
                "Motor - Temp",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.10,
              right: screenWidth * 0.30,
              child: Text(
                "°F",
                style: TextStyle(
                    fontSize: 10,
                    color: Color.fromARGB(221, 0, 0, 0),
                    fontWeight: FontWeight.w500),
              ),
            ),
            //////////////////////////////////////////////
            ///
            Divider(
              height: 800,
              color: Color.fromARGB(255, 218, 218, 218),
            ),
            Positioned(
              bottom: screenHeight * 0.57,
              right: screenWidth * 0.85,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BatteryValuePage()));
                },
                child: Image.asset(
                  'images/Alerts.png',
                  width: screenWidth * 0.07,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.51,
              right: screenWidth * 0.84,
              child: Container(
                width: 15.0,
                height: 15.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
              ),
            ),
            /////////////////////////////////////////////////////////////////////////
            Positioned(
              bottom: screenHeight * 0.47,
              right: screenWidth * 0.85,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BatteryValuePage()));
                },
                child: Image.asset(
                  'images/Faults.png',
                  width: screenWidth * 0.07,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            /////////////////////////////////////////////////////////////////////////
            Positioned(
              top: screenHeight * 0.51,
              right: screenWidth * 0.19,
              child: MotorCurrentGauge(DataHolder.MotorCurrent),
            ),
            Positioned(
              bottom: screenHeight * 0.15,
              right: screenWidth * 0.045,
              child: LoadValueGauge(DataHolder.LoadValue),
            ),
            Positioned(
              bottom: screenHeight * 0.15,
              right: screenWidth * 0.38,
              child: BatteryVoltageGauge(DataHolder.batteryValue),
            ),
            Positioned(
              bottom: screenHeight * 0.15,
              left: screenWidth * 0.355,
              child: HydraulicPressureGauge(DataHolder.HydraulicPressure),
            ),
            Positioned(
              top: screenHeight * 0.51,
              left: screenWidth * 0.24,
              child: MotorTempGauge(DataHolder.MotorTemp),
            ),
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ///
            Divider(
              height: 370,
              color: Color.fromARGB(255, 218, 218, 218),
            ),

///////////////////////////////////////////////////////////////////////
            ///
            Positioned(
                left: screenHeight * 0.01,
                child: Image.asset('images/Vehicle.png')),
            Positioned(
                right: screenHeight * 0.17,
                child: Image.asset('images/Vehicle2.png')),
            Positioned(
                right: screenHeight * 0.01,
                child: Image.asset('images/Vehicle2.png')),
            Positioned(
              bottom: screenHeight * 0.31,
              right: screenWidth * 0.45,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoadWeightPage()));
                },
                child: Image.asset(
                  'images/Load.png',
                  width: screenWidth * 0.09,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.31,
              right: screenWidth * 0.78,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BatteryValuePage()));
                },
                child: Image.asset(
                  'images/Battery.png',
                  width: screenWidth * 0.10,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.31,
              right: screenWidth * 0.15,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HydrPage()));
                },
                child: Image.asset(
                  'images/hydr.png',
                  width: screenWidth * 0.09,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.15,
              right: screenWidth * 0.61,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MotorCurrentPage()));
                },
                child: Image.asset(
                  'images/power.png',
                  width: screenWidth * 0.07,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.15,
              right: screenWidth * 0.26,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MotorPage()));
                },
                child: Image.asset(
                  'images/temp.png',
                  width: screenWidth * 0.10,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),

            Positioned(
              bottom: screenHeight * 0.02,
              right: screenWidth * 0.45,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MotorCurrentPage()));
                },
                child: Image.asset(
                  'images/bottommenu.png',
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.02,
              right: screenWidth * 0.73,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MotorCurrentPage()));
                },
                child: Image.asset(
                  'images/homeicon.png',
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.02,
              right: screenWidth * 0.6,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MotorCurrentPage()));
                },
                child: Image.asset(
                  'images/statics.png',
                  width: screenWidth * 0.122,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.02,
              right: screenWidth * 0.47,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MotorCurrentPage()));
                },
                child: Image.asset(
                  'images/usericon.png',
                  width: screenWidth * 0.122,
                  height: screenHeight * 0.07, // Adjusted image size
                ),
              ),
            ),
            Positioned(
              top: 665,
              right: 30,
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
                shape: CircleBorder(),
                backgroundColor: Color.fromARGB(235, 243, 207, 3),
              ),
            ),
///////////////////////////////////////////////////////////////////////////////////////////////////////////////map page below

            Align(
              alignment: AlignmentDirectional(0.4, -0.3),
              child: Container(
                color: Color.fromARGB(255, 255, 255, 255),
                height: mapFullScreenView ? screenHeight - 1 : 120,
                width: mapFullScreenView ? screenWidth : 260,
                child: Map_Page(
                  handleMapClick: handleMapClick,
                  callback: this.callback,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MotorPage extends StatelessWidget {
  const MotorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("motorpagevalue"),
      ),
    );
  }
}

class MotorCurrentPage extends StatelessWidget {
  const MotorCurrentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("motorcurrentpage"),
      ),
    );
  }
}

class BatteryValuePage extends StatelessWidget {
  const BatteryValuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Batteryvaluepage"),
      ),
    );
  }
}

class HydrPage extends StatelessWidget {
  const HydrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hydrvaluepage"),
      ),
    );
  }
}
