import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({super.key});

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  String? expandedOrderId;

  Future<void> _cancelOrder(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': 'Cancelled'});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled successfully!')),
      );
      setState(() {
        expandedOrderId = null; // Collapse the expanded order after canceling
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream =
    FirebaseFirestore.instance.collection('orders').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background curve and gradient
          Positioned(
            top: -50,
            left: -50,
            right: -50,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade700, Colors.green.shade400],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
            ),
          ),
          // Main Content
          Padding(
            padding: const EdgeInsets.only(top: 70), // Reduced gap here
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.green.shade100], // Lighter background
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _orderStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No orders available"));
                  }

                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      final data = document.data() as Map<String, dynamic>?;

                      if (data == null) {
                        return const ListTile(
                          title: Text("Error loading order"),
                        );
                      }

                      final orderId = document.id;
                      final productImage = data['image'] ?? '';
                      final price = data['productPrice'] ?? 0.0;
                      final quantity = data['productQuantity'] ?? 0;
                      final productName = data['productName'] ?? 'Unknown Product';
                      final status = data['status'] ?? 'Pending';
                      final isAccepted = data['accepted'] == true;
                      final orderDate =
                          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

                      return Card(
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Main Order Details
                            ListTile(
                              onTap: () {
                                setState(() {
                                  expandedOrderId = (expandedOrderId == orderId) ? null : orderId;
                                });
                              },
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(productImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                productName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity: $quantity'),
                                  Text('Price: ₹${price.toStringAsFixed(2)}'),
                                  Text(
                                    'Order Date: ${orderDate.toLocal().toString().split(' ')[0]}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Status: $status',
                                    style: TextStyle(
                                      color: status == 'Cancelled' ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                expandedOrderId == orderId
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                            ),
                            // Expanded Area with Features
                            if (expandedOrderId == orderId)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          isAccepted
                                              ? Icons.delivery_dining
                                              : Icons.access_time,
                                          color: isAccepted ? Colors.green : Colors.orange,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          isAccepted
                                              ? 'Order Accepted - Preparing for Delivery'
                                              : 'Order Pending',
                                          style: TextStyle(
                                            color: isAccepted
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Conditionally render button based on status
                                    if (status != 'Cancelled')
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Cancel Order'),
                                              content: const Text(
                                                  'Are you sure you want to cancel this order?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context).pop(false),
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context).pop(true),
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            _cancelOrder(context, orderId);
                                          }
                                        },
                                        child: const Text('Remove Order'),
                                      )
                                    else
                                      const Text(
                                        'Order Cancelled',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
