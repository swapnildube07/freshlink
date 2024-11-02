import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<String> _bannerList = [];
  bool _isLoading = true;

  // Fetch banners from Firestore
  Future<void> getBanners() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('banners').get();
      List<String> storagePaths = querySnapshot.docs.map((doc) {
        print("Document data: ${doc.data()}"); // Debug print statement
        return doc['image'] as String;
      }).toList();

      for (String path in storagePaths) {
        String imageUrl;
        if (path.startsWith("https://")) {
          imageUrl = path;
        } else {
          imageUrl = await _storage.ref(path).getDownloadURL();
        }
        _bannerList.add(imageUrl);
      }

      setState(() {
        _isLoading = false; // Stop loading after fetching banners
      });

      print("Banner URLs: $_bannerList");
    } catch (e) {
      print("Error fetching banners: $e");
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBanners(); // Fetch banners on initialization
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _bannerList.isEmpty
        ? const Center(child: Text("No banners available"))
        : CarouselSlider(
      items: _bannerList.map((e) {
        return Builder(builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Image.network(e, fit: BoxFit.cover),
          );
        });
      }).toList(),
      options: CarouselOptions(
        height: 400,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
