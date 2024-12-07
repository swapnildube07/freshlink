import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshlink/models/provider/cart_provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    int? _selectedIndex; // To track which item is selected
    bool _isExpanded = false; // To manage the visibility of options
    final cartData = ref.watch(cartProvider); // Watching the cart provider
    final cartNotifier = ref.read(cartProvider.notifier);

    double shippingCharges = 10; // Flat shipping charge
    double totalPrice = 0;

    // Calculate the total price of all items in the cart
    cartData.values.forEach((item) {
      totalPrice += (item.price * item.productQuantity);
    });

    // Final total with shipping charges
    double finalTotal() => totalPrice + shippingCharges;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.green,
      ),
      body: cartData.isEmpty
          ? const Center(child: Text("Your cart is empty!"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartData.length,
                itemBuilder: (context, index) {
                  final cartItem = cartData.values.toList()[index];
                  double productTotal =
                      cartItem.price * cartItem.productQuantity;

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Image.network(
                            cartItem.imageUrl[0],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.productName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Price: ₹${cartItem.price}",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  "Quantity: ${cartItem.productQuantity}",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                // Shipping and total price per product
                                Text(
                                  "Shipping: ₹$shippingCharges",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  "Total: ₹${(productTotal + shippingCharges).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Price: ₹${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Shipping Charges: ₹$shippingCharges",
                    style:
                    const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Final Total: ₹${finalTotal().toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true; // Show loading indicator
                });
                DocumentSnapshot userDoc = await _firestore
                    .collection('buyers')
                    .doc(_auth.currentUser!.uid)
                    .get();
                final orderID = Uuid().v4(); // Generate a unique Order ID
                try {
                  // For each product in the cart, create an order entry
                  for (var item in cartData.values) {
                    double productTotal =
                        item.price * item.productQuantity;

                    // Add each product's details to Firestore
                    await _firestore
                        .collection('orders')
                        .doc(orderID)
                        .set({
                      'OrderID': orderID,
                      'productID': item.productId,
                      'productName': item.productName,
                      'productPrice': item.price,
                      'productQuantity': item.productQuantity,
                      'totalPrice': productTotal + shippingCharges,
                      // Include shipping cost in total
                      'status': 'Pending',
                      // Default order status
                      'createdAt': FieldValue.serverTimestamp(),
                      'FullName': (userDoc.data() as Map<String,
                          dynamic>)['FullName'],
                      'MobileNumber': (userDoc.data() as Map<
                          String,
                          dynamic>)['MobileNumber'],
                      'Email': (userDoc.data() as Map<String,
                          dynamic>)['email'],
                      'buyerID': (userDoc.data() as Map<String,
                          dynamic>)['buyerID'],
                      'farmerID': item.farmerID
                    }).whenComplete(() {
                      setState(() {
                        _isLoading = false; // Hide loading indicator
                      });
                    });
                  }

                  // Show success message with green background
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Order placed successfully!"),
                      backgroundColor: Colors.green, // Green color
                    ),
                  );
                } catch (e) {
                  // Handle error if something goes wrong
                  setState(() {
                    _isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                        Text("Failed to place order. Try again.")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text(
                "Place Order",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
