import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> users = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 150.0),
            // Adjust the bottom space as needed
            child: YourCustomWidget(users),

            // Replace with your custom widget
          ), // You can replace this with your custom widget
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              fetchData();
            },
            backgroundColor: Color.fromARGB(255, 233, 211, 170),
            child: const Icon(Icons.refresh, color: Colors.black)),
      ),
    );
  }

  fetchData() async {
    print('Fetching users...');
    const url =
        'https://run.mocky.io/v3/c355b22b-9e3e-41b1-84ab-27c2ee828a76?result=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        users = json['results'];
      });
      print('Users fetched successfully');
    } else {
      print('Failed to fetch users');
    }
  }
}

class YourCustomWidget extends StatefulWidget {
  final List<dynamic> users;
  YourCustomWidget(this.users);

  @override
  State<YourCustomWidget> createState() => _YourCustomWidgetState();
}

class _YourCustomWidgetState extends State<YourCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightForFinite(width: 343, height: 450),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 232, 189),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 160,
            left: 50,
            child: Text(
              "Battery",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
              bottom: 30,
              left: 17,
              child: InkWell(
                onTap: () {},
                child: Image.asset(
                  "images/Load.png",
                  width: 100,
                  height: 100,
                ),
              )),
          Positioned(
            bottom: 20,
            left: 50,
            child: Text(
              "Load",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            bottom: 160,
            right: 136,
            child: Text(
              "Temperature",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            bottom: 147,
            right: 150,
            child: Text(
              "(motor)",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            bottom: 160,
            right: 120,
            child: Image.asset(
              "images/temp.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 160,
            right: 29,
            child: Text(
              "Temperature",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            bottom: 147,
            right: 44,
            child: Text(
              "(motor)",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 230,
            child: Image.asset(
              "images/Odo.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 35,
            child: Text(
              "Odometer",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            right: 120,
            bottom: 23,
            child: Image.asset(
              "images/hydr.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 143,
            child: Text(
              "Hydraulic",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 145,
            child: Text(
              "Pressure",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            bottom: 160,
            left: 233,
            child: Image.asset(
              "images/batterytemp.png",
              width: 100,
              height: 100,
            ),
          ),

          Positioned(
            bottom: 160,
            left: 17,
            child: Image.asset(
              "images/Battery.png",
              width: 100,
              height: 100,
            ),
          ),
          const Positioned(
            top: 15,
            left: 20,
            child: Text(
              "Vehicle log",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Positioned(
            top: 47,
            left: 21,
            child: Text(
              "Vehicle V1",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 117, 117, 117),
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Positioned(
            top: 130,
            left: 100,
            child: Text(
              "kmph",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Positioned(
            top: 130,
            left: 227,
            child: Text(
              "%",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 0, 0, 0),
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Positioned(
            top: 150,
            left: 79,
            child: Text(
              "Speedometer",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 117, 117, 117),
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Positioned(
            top: 150,
            left: 200,
            child: Text(
              "Battery Info",
              style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 117, 117, 117),
                  fontWeight: FontWeight.w500),
            ),
          ),
          // Add more Positioned widgets for additional images

          // Your existing ListView.builder and other widgets
          ListView.builder(
            itemCount: widget.users.length,
            itemBuilder: (context, index) {
              final user = widget.users[index];
              final sp = user['details']['speed'];
              final bat = user['details']['battery'];
              return ListTile(
                title: Row(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(right: 70, top: 150)),
                    Text(
                      sp,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 200, 97),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 60)),
                    Text(
                      bat,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 200, 97),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
