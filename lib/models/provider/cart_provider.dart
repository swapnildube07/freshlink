import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshlink/models/cart_models.dart';

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
      (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  void addProductToCart(
      final String productName,
      final String productId,
      final List imageUrl,
      int productQuantity,
      final double price,
      //final String packagingType,
      final String farmerID,
      ) {
    if (state.containsKey(productId)) {
      // Increment quantity if product already exists
      final existingItem = state[productId]!;
      final updatedQuantity = existingItem.productQuantity + productQuantity;

      state = {
        ...state,
        productId: CartModel(
          productName: existingItem.productName,
          productId: existingItem.productId,
          imageUrl: existingItem.imageUrl,
          productQuantity: updatedQuantity,
          price: existingItem.price,
         // PackagingType: existingItem.PackagingType,
          farmerID: existingItem.farmerID
        ),
      };
    } else {
      // Add product if it doesn't exist
      state = {
        ...state,
        productId: CartModel(
          productName: productName,
          productId: productId,
          imageUrl: imageUrl,
          productQuantity: productQuantity,
          price: price,
          //PackagingType: packagingType,
          farmerID: farmerID
        ),
      };
    }
  }

  void removeItem(String productId) {
    if (state.containsKey(productId)) {
      state = {...state}..remove(productId);
    }
  }

  // New method to clear the entire cart
  void clearCart() {
    state = {};  // Reset the cart to an empty map
  }

  Map<String, CartModel> get getCartItems => state;
}
