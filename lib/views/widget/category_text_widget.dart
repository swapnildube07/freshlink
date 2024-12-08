import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshlink/views/screens/Categories_Screen.dart';
import 'package:get/get.dart';

class CategoryTextWidget extends StatefulWidget {
  const CategoryTextWidget({super.key});

  @override
  State<CategoryTextWidget> createState() => _CategoryTextWidgetState();
}

class _CategoryTextWidgetState extends State<CategoryTextWidget> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryStream = FirebaseFirestore.instance.collection('Categories').snapshots();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories List with StreamBuilder
            StreamBuilder<QuerySnapshot>(
              stream: _categoryStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong', style: TextStyle(color: Colors.red)));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container(
                  height: 60,
                  child: Row(
                    children: [
                      // Category Chips with Icons
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final categoryData = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  // Add navigation or category-specific actions here
                                },
                                child: Chip(
                                  backgroundColor: Colors.green,
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                  avatar: Icon(
                                    Icons.category, // Replace with category-specific icons if available
                                    size: 20,
                                    color: Colors.white70,
                                  ),
                                  label: Text(
                                    categoryData['categoryName'].toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Forward Icon with Circular Background
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            Get.to(CategoriesScreen());
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
