class Product {
  final String id;
  final String productName;
  final double productPrice;
  final List<String> imageUrlList;
  final String packagingType;
  final double shippingCharge;
  final int deliveryDays;
  final String qualityGrades;
  final String category;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.imageUrlList,
    required this.packagingType,
    required this.shippingCharge,
    required this.deliveryDays,
    required this.qualityGrades,
    required this.category,
  });

  // Factory method to create a Product instance from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      productName: json['productName'] ?? '',
      productPrice: (json['productPrice'] ?? 0).toDouble(),
      imageUrlList: List<String>.from(json['imageUrlList'] ?? []),
      packagingType: json['packagingType'] ?? '',
      shippingCharge: (json['shippingCharge'] ?? 0).toDouble(),
      deliveryDays: json['deliveryDays'] ?? 0,
      qualityGrades: json['qualityGrades'] ?? '',
      category: json['category'] ?? '',
    );
  }

  // Method to convert a Product instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'imageUrlList': imageUrlList,
      'packagingType': packagingType,
      'shippingCharge': shippingCharge,
      'deliveryDays': deliveryDays,
      'qualityGrades': qualityGrades,
      'categoryName': category,
    };
  }
}
