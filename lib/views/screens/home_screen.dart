import 'package:flutter/material.dart';
import 'package:freshlink/views/widget/Recently_widget.dart';
import 'package:freshlink/views/widget/banner_widget.dart';
import 'package:freshlink/views/widget/category_text_widget.dart';
import 'package:freshlink/views/widget/home_product.dart';
import 'package:freshlink/views/widget/location_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Simulating a delay to represent loading data
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2)); // Adjust delay as needed
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(),
      builder: (context, snapshot) {
        // While waiting for data to load, show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Once data is loaded, show main content
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationWidget(),
                SizedBox(height: 10),
                BannerWidget(),
                SizedBox(height: 10),
                CategoryTextWidget(),
                SizedBox(height: 10),
                HomeProductWidget(),
                SizedBox(height: 10),
                RecentlyScreen(),
              ],
            ),
          ),
        );
      },
    );
  }
}
