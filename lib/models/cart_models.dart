class CartModel {
  final String productName;
  final String productId;
  final List imageUrl;

  int productQuantity;
  final double price;
  //final String PackagingType;
  final String farmerID;

  CartModel({
    required this.productName,
    required this.productId,
    required this.imageUrl,
    required this.productQuantity,
    required this.price,
   // required this.PackagingType,
    required this.farmerID
  });
}
