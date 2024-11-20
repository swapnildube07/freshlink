import 'package:flutter/material.dart';
import '../screens/inner_screen/Product.dart';
import '../screens/inner_screen/recently_visited_service.dart';

class RecentlyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: RecentlyVisitedService.getRecentlyVisitedProducts(),
      builder: (context, snapshot) {
        // Handling loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handling error state
        else if (snapshot.hasError) {
          return const Center(child: Text("Error loading recently viewed products"));
        }

        // Handling no data or empty list
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No recently viewed products"));
        }

        // Fetched products
        final products = snapshot.data!;

        // Debugging statement to check the fetched data
        print("Fetched products: ${products.length}");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Recently Viewed",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 120, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  // Debugging statement to check product data
                  print("Product name: ${product.productName}, Image URL: ${product.imageUrlList}");

                  // Ensuring image URL is valid
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        product.imageUrlList.isNotEmpty
                            ? Image.network(
                          product.imageUrlList[0],
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/placeholder_image.png',
                              width: 80,
                              height: 80,
                            );
                          },
                        )
                            : Image.asset(
                          'assets/placeholder_image.png',
                          width: 80,
                          height: 80,
                        ),
                        SizedBox(height: 5),
                        Text(
                          product.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
