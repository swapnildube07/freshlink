import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshlink/models/cart_models.dart';

final cartProvider = StateNotifierProvider<CartNotifier , Map<String, CartModel>>((ref) => CartNotifier());


class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  void addProductTOCart(
    final String productName,
    final String productId,
    final List imageUrl,
    int productQuantity,
    final double price,
    final String PackagingType,
  ) {
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: CartModel(
            productName: state[productName]!.productName,
            productId: state[productName]!.productName,
            imageUrl: state[imageUrl]!.imageUrl,
            productQuantity: state[productQuantity]!.productQuantity,
            price:  state[price]!.price,
            PackagingType: state[PackagingType]!.PackagingType)
      };
    }else{
      state = {
        ...state,
        productId: CartModel(productName: productName, productId: productId, imageUrl: imageUrl, productQuantity: productQuantity, price: price, PackagingType: PackagingType)
      };
    }
  }
}
