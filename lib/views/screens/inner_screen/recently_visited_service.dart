import 'package:freshlink/views/screens/inner_screen/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecentlyVisitedService {
  static const String _recentlyViewedKey = 'recently_viewed_products';

  // Method to add a product to the recently visited list
  static Future<void> addProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentlyVisited = prefs.getStringList(_recentlyViewedKey) ?? [];

    // Convert the product to JSON string and remove duplicates
    String productJson = jsonEncode(product.toJson());
    recentlyVisited.remove(productJson);

    // Insert the product at the beginning of the list
    recentlyVisited.insert(0, productJson);

    // Limit the list to the latest 10 items
    if (recentlyVisited.length > 10) {
      recentlyVisited = recentlyVisited.sublist(0, 10);
    }

    // Save the updated list back to SharedPreferences
    await prefs.setStringList(_recentlyViewedKey, recentlyVisited);
  }

  // Method to retrieve the list of recently visited products
  static Future<List<Product>> getRecentlyVisitedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentlyVisited = prefs.getStringList(_recentlyViewedKey) ?? [];

    // Decode JSON strings to Product objects
    return recentlyVisited.map((item) {
      return Product.fromJson(jsonDecode(item));
    }).toList();
  }
}
