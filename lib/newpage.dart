import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 168, 168, 168),
      body: Text(
        "hai ",
        style: TextStyle(color: Colors.black, fontSize: 30),
      ),
    );
  }
}
