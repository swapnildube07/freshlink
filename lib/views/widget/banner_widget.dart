import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  int _currentBannerIndex = 0; // To track current banner index for indicator

  // Fetch banners from Firestore
  Future<void> getBanners() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('banners').get();
      List<String> storagePaths = querySnapshot.docs.map((doc) {
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
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching banners: $e");
      setState(() {
        _isLoading = false;
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
        : Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Carousel Slider with updated height and styling
        CarouselSlider(
          items: _bannerList.map((e) {
            return Builder(builder: (context) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    e,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
                ),
              );
            });
          }).toList(),
          options: CarouselOptions(
            height: 200, // Adjusted height to make it smaller
            aspectRatio: 16 / 9,
            viewportFraction: 0.9,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index; // Update current banner index
              });
            },
          ),
        ),
        const SizedBox(height: 10), // Space between banner and indicators

        // Dot Indicators below the banner
        AnimatedSmoothIndicator(
          activeIndex: _currentBannerIndex,
          count: _bannerList.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            dotColor: Colors.grey.shade300,
            activeDotColor: Colors.green, // Active indicator color
          ),
        ),
      ],
    );
  }
}
