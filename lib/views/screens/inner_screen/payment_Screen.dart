import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:freshlink/views/screens/inner_screen/stripe_service.dart';
import 'checkout_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isPayOnDelivery = false;
  bool isPayWithCard = false; // Toggle for Pay with Card option
  bool isPayWithUPay = false; // Toggle for Pay with UPay option
  bool isLoading = false; // Show loading indicator during payment process
  CardFieldInputDetails? cardDetails;

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey =
    "pk_test_51QTNwwE6LP0EGzPeQCxQVtufj1nE0t8fkLwbUWfpRnNRVvEXBhH9P1S38MKpX0HvmWRK3tLngMux39wE0VFjno3m00xnu6WaMQ";
    Stripe.instance.applySettings();
  }

  Future<void> processStripePayment() async {
    if (cardDetails == null || !cardDetails!.complete) {
      _showSnackBar("Invalid Card Details", isError: true);
      return;
    }

    setState(() {
      isLoading = true; // Start loading during payment process
    });

    try {
      await StripeService.instance.makePayment();
      setState(() {
        isLoading = false;
      });
      _showSnackBar("Payment Successful", isError: false);
      _navigateToCheckout();
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar("Payment Failed: ${error.toString()}", isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navigateToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CheckoutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fast and Secure Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Payment Methods Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Select Payment Method",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pay on Delivery Option
                  ListTile(
                    leading: const Icon(Icons.local_shipping),
                    title: const Text(
                      'Pay on Delivery',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      setState(() {
                        isPayOnDelivery = !isPayOnDelivery;
                        isPayWithCard = false;
                        isPayWithUPay = false;
                      });
                    },
                    trailing: Switch(
                      value: isPayOnDelivery,
                      onChanged: (value) {
                        setState(() {
                          isPayOnDelivery = value;
                          isPayWithCard = false;
                          isPayWithUPay = false;
                        });
                      },
                    ),
                  ),
                  const Divider(),

                  // Pay with Card Option
                  ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: const Text(
                      'Pay with Card',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      setState(() {
                        isPayWithCard = !isPayWithCard;
                        isPayOnDelivery = false;
                        isPayWithUPay = false;
                      });
                    },
                    trailing: Switch(
                      value: isPayWithCard,
                      onChanged: (value) {
                        setState(() {
                          isPayWithCard = value;
                          isPayOnDelivery = false;
                          isPayWithUPay = false;
                        });
                      },
                    ),
                  ),
                  const Divider(),

                  // Pay with UPI Option
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text(
                      'Pay with UPI',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      setState(() {
                        isPayWithUPay = !isPayWithUPay;
                        isPayOnDelivery = false;
                        isPayWithCard = false;
                      });
                    },
                    trailing: Switch(
                      value: isPayWithUPay,
                      onChanged: (value) {
                        setState(() {
                          isPayWithUPay = value;
                          isPayOnDelivery = false;
                          isPayWithCard = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Proceed Button for Pay on Delivery
            if (isPayOnDelivery)
              ElevatedButton(
                onPressed: _navigateToCheckout,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  backgroundColor: Colors.green[700],
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 18),
                ),
              ),

            // Pay with Card Option UI
            if (isPayWithCard)
              Column(
                children: [
                  const SizedBox(height: 20),
                  // First row: Card Number
                  TextField(
                    controller: cardNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      hintText: 'Enter your card number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  // Second row: Expiry and CVC
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: expiryDateController,
                          decoration: const InputDecoration(
                            labelText: 'MM/YY',
                            hintText: 'MM/YY',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: cvcController,
                          decoration: const InputDecoration(
                            labelText: 'CVC',
                            hintText: 'CVC',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: processStripePayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      backgroundColor: Colors.green[700],
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Pay with Card',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),

            // UPI Success Simulation
            if (isPayWithUPay)
              ElevatedButton(
                onPressed: () {
                  // Show SnackBar and navigate to checkout
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        "Payment Successful",
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    ),
                  );
                  _navigateToCheckout();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  backgroundColor: Colors.lightGreen,
                ),
                child: const Text(
                  'Pay with UPI',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
