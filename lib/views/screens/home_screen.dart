import 'package:flutter/material.dart';
import 'package:freshlink/views/widget/Recently_widget.dart';
import 'package:freshlink/views/widget/banner_widget.dart';
import 'package:freshlink/views/widget/category_text_widget.dart';
import 'package:freshlink/views/widget/home_product.dart';
import 'package:freshlink/views/widget/location_widget.dart';
import 'package:freshlink/views/widget/search_widget.dart'; // Import search widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2)); // Adjust delay as needed
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LocationWidget(), // Location widget at the top
                const SizedBox(height: 10),
              //  const SearchWidget(), // Your new search widget here
                const SizedBox(height: 10),
                const BannerWidget(), // Banner below search bar
                const SizedBox(height: 10),
                const CategoryTextWidget(),
                const SizedBox(height: 10),
                const HomeProductWidget(),
                const SizedBox(height: 10),
           ///     RecentlyScreen(),
              ],
            ),
          ),
        );
      },
    );
  }
}
