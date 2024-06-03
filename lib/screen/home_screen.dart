import 'package:flutter/material.dart';
import 'package:olxm_project/screen/body_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.deepPurple[100],
          title: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "OLMX",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                Image.asset(
                  "assets/image/logo.png",
                  width: 55.0,
                  height: 55.0,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ),
        body: const Body());
  }
}
