import 'package:course_up/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:course_up/components/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 6, 83),
      appBar: const CustomAppBar(),
      body: const HomeBody(),
    );
  }
}
