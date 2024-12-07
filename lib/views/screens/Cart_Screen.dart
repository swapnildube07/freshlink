import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshlink/models/provider/cart_provider.dart';
import 'package:freshlink/views/screens/inner_screen/payment_Screen.dart';

import 'inner_screen/checkout_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  int? _selectedIndex; // To track which item is selected
  bool _isExpanded = false; // To manage the visibility of options

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider); // Watching the cart provider
    final cartNotifier = ref.read(cartProvider.notifier);

    double shippingCharges = 10; // Flat shipping charge
    double totalPrice = 0;

    // Calculate the total price of all items
    cartData.values.forEach((item) {
      totalPrice += (item.price * item.productQuantity);
    });

    // Final total with shipping charges
    double finalTotal = totalPrice + shippingCharges;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              // Clear all items in the cart
              cartNotifier.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cart cleared!")),
              );
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: cartData.isEmpty
          ? const Center(
        child: Text(
          "Your cart is empty",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Cart Items List
            Expanded(
              child: ListView.builder(
                itemCount: cartData.length,
                itemBuilder: (context, index) {
                  final cartItem = cartData.values.toList()[index];

                  // Calculate individual product total
                  double productTotal = cartItem.price * cartItem.productQuantity;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle the visibility of the "Buy Now" and "Remove" buttons
                        if (_selectedIndex == index) {
                          _isExpanded = !_isExpanded;
                        } else {
                          _isExpanded = true;
                        }
                        _selectedIndex = index;
                      });
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  cartItem.imageUrl[0],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.productName,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Price: ₹${cartItem.price}",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      Text(
                                        "Quantity: ${cartItem.productQuantity}",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 8),
                                      // Shipping and total price per product
                                      Text(
                                        "Shipping Charges: ₹$shippingCharges",
                                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      Text(
                                        "Total: ₹${(productTotal + shippingCharges).toStringAsFixed(2)}",
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Only show these options when the item is clicked
                            Visibility(
                              visible: _isExpanded && _selectedIndex == index,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle "Buy Now"
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Proceeding to Buy Now")),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                        ),
                                        child: const Text("Buy Now"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Remove the item from the cart
                                          cartNotifier.removeItem(cartItem as String);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Item removed from cart")),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                        ),
                                        child: const Text("Remove"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Price Summary Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Price Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Total price without shipping
                  Text("Total Price: ₹${totalPrice.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  // Shipping charges
                  Text("Shipping Charges: ₹$shippingCharges"),
                  const Divider(height: 20, color: Colors.grey),
                  // Final total (price + shipping)
                  Text(
                    "Total Cost: ₹${finalTotal.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
         //       Navigate to the CheckoutScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(), // Replace with the actual Checkout screen
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Proceed to Checkout",
                style: TextStyle(fontSize: 18),
              ),
            )

          ],
        ),
      ),
    );
  }
}
