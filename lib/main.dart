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
    const url =
        'http://13.127.214.1:3000/api/v1/VID_12348/vehicledata/2024-01-31/2024-01-31';
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
    var _currentIndex = 1;
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
        body: YourCustomWidget(),
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              var _currentIndex = index;
            });
          },
        ),

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
    var _currentIndex = 1;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: screenHeight * 0.21,
              right: screenWidth * 0.77,
              child: Text(
                "Battery",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.19,
              right: screenWidth * 0.815,
              child: Text(
                "V",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.21,
              right: screenWidth * 0.46,
              child: Text(
                "Load",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.19,
              right: screenWidth * 0.475,
              child: Text(
                "kg",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.21,
              right: screenWidth * 0.13,
              child: Text(
                "Pressure",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.19,
              right: screenWidth * 0.17,
              child: Text(
                "psi",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.059,
              right: screenWidth * 0.60,
              child: Text(
                "Power",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.059,
              right: screenWidth * 0.22,
              child: Text(
                "Motor - Temp",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.04,
              right: screenWidth * 0.30,
              child: Text(
                "°F",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.04,
              right: screenWidth * 0.63,
              child: Text(
                "W",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color.fromARGB(
                      255, 253, 253, 253), // Set the underline color
                ),
              ),
            ),
            //////////////////////////////////////////////
            ///
            Align(
              alignment: AlignmentDirectional(0.5, 0.1),
              child: Divider(
                color: Color.fromARGB(255, 218, 218, 218),
              ),
            ),
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
              bottom: screenHeight * 0.365,
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
            Positioned(
              bottom: screenHeight * 0.40,
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
              top: screenHeight * 0.465,
              right: screenWidth * 0.20,
              child: MotorCurrentGauge(DataHolder.MotorCurrent),
            ),
            Positioned(
              bottom: screenHeight * 0.07,
              right: screenWidth * 0.045,
              child: LoadValueGauge(DataHolder.LoadValue),
            ),
            Positioned(
              bottom: screenHeight * 0.07,
              right: screenWidth * 0.38,
              child: BatteryVoltageGauge(DataHolder.batteryValue),
            ),
            Positioned(
              bottom: screenHeight * 0.07,
              left: screenWidth * 0.355,
              child: HydraulicPressureGauge(DataHolder.HydraulicPressure),
            ),
            Positioned(
              top: screenHeight * 0.464,
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
              bottom: screenHeight * 0.23,
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
              bottom: screenHeight * 0.23,
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
              bottom: screenHeight * 0.23,
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
              bottom: screenHeight * 0.08,
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
              bottom: screenHeight * 0.08,
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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////map page below

            Align(
              alignment: AlignmentDirectional(0.5, -0.2),
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

class MyBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      backgroundColor: Colors.white,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(left: 40.0),
            width: 200.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(35.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(
                  flex: 3,
                  child: Icon(
                    Icons.home_filled,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Icon(
                    Icons.equalizer,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 40.0,
                        color: Colors.white,
                      ),
                      // Notification dot
                      Positioned(
                        top: 0,
                        right: 18.0,
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(left: 70.0),
            width: 60.0,
            height: 60.0,
            child: GestureDetector(
              onTap: () {
                // Handle the onTap for the "Add" button
              },
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow, // Background color for the Add icon
                ),
                child: const Icon(
                  Icons.add,
                  size: 40.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          label: "",
        ),
      ],
    );
  }
}
