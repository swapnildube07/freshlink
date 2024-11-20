import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic productData;
  const ProductDetailsScreen({super.key, required this.productData});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  int _selectedQuantity = 1;
  String _selectedUnit = "Kg";
  bool _isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    final productData = widget.productData;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          productData['productName'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Description Section
            Text(
              productData['productName'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              productData['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Product Images Carousel with Smooth Indicator
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider(
                  items: (productData['ImageUrlList'] as List<dynamic>)
                      .map((url) => Image.network(url, fit: BoxFit.cover, width: MediaQuery.of(context).size.width))
                      .toList(),
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedSmoothIndicator(
                    activeIndex: _currentImageIndex,
                    count: (productData['ImageUrlList'] as List<dynamic>).length,
                    effect: const WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Price and Quantity Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(FontAwesomeIcons.tag, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "\$${productData['productPrice']}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Qty: "),
                    DropdownButton<int>(
                      value: _selectedQuantity,
                      items: List.generate(10, (index) => index + 1)
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString()),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedQuantity = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _selectedUnit,
                      items: ["Kg", "Litre"].map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUnit = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Shipping and Delivery Information Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.truck, color: Colors.deepPurple, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Shipping Charge: \$${productData['ShippingCharge']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.clock, color: Colors.deepPurple, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Expected Delivery: ${productData['DeliveryDays']} Days",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Highlights Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Product Highlights",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.star, color: Colors.green, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Quality Grades: ${productData['QualityGrades']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.boxOpen, color: Colors.green, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Packaging Type: ${productData['PackagingType']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.layerGroup, color: Colors.blue, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Category: ${productData['category'] ?? 'N/A'}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar with Add to Cart and Buy Now buttons
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_isAddedToCart) {
                    Navigator.pushNamed(context, '/cart');
                  } else {
                    setState(() {
                      _isAddedToCart = true;
                    });
                    // Add to cart logic
                  }
                },
                icon: Icon(
                  _isAddedToCart ? FontAwesomeIcons.shoppingCart : FontAwesomeIcons.cartPlus,
                  color: Colors.white,
                ),
                label: Text(_isAddedToCart ? "Go to Cart" : "Add to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/checkout');
                },
                icon: const Icon(FontAwesomeIcons.creditCard, color: Colors.white),
                label: const Text("Buy Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating Chat Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to open chat goes here
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
