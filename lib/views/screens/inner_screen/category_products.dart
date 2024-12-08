import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widget/product_details.dart';

class CategoryProductsScreen extends StatefulWidget {
  final dynamic categoryData;

  const CategoryProductsScreen({super.key, this.categoryData});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('Products')
        .where('category', isEqualTo: widget.categoryData['categoryName'])
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryData['categoryName'],
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2 ,),
        ),
        backgroundColor: Colors.green[500],
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Products Found\nIn This Category',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75, // Adjust based on desired image size
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to Product Details Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        productData: productData,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  shadowColor: Colors.grey.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Container with adjusted height and fit
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.network(
                          productData['ImageUrlList'][0], // First image in list
                          height: 120, // Adjust height as needed
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              productData['productName'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Product Price
                            Text(
                              '₹${productData['productPrice']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}