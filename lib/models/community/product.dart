class Product {
  int id;
  String name;
  String description;
  double price;
  String size;
  String color;
  SellerDetails seller;
  bool isOutOfStock;
  List<String> imagesPaths;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.size,
    required this.color,
    required this.seller,
    required this.imagesPaths,
    required this.isOutOfStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      size: json['size'],
      color: json['color'],
      seller: SellerDetails.fromJson(json['sellerDetails']),
      imagesPaths: List<String>.from(json['imagesPaths']),
      isOutOfStock: json['isOutOfStock'],
    );
  }
}

class SellerDetails {
  String sellerFullName;
  int sellerId;
  String sellerPhoneNumber;
  String sellerEmail;
  String fcmToken;
  int houseId;
  int estateId;
  String estateName;
  bool isAdmin;

  SellerDetails({
    required this.sellerFullName,
    required this.sellerId,
    required this.sellerPhoneNumber,
    required this.sellerEmail,
    required this.fcmToken,
    required this.houseId,
    required this.estateId,
    required this.estateName,
    required this.isAdmin,
  });

  factory SellerDetails.fromJson(Map<String, dynamic> json) {
    return SellerDetails(
      sellerFullName: json['sellerFullName'],
      sellerId: json['sellerId'],
      sellerPhoneNumber: json['sellerPhoneNumber'],
      sellerEmail: json['sellerEmail'],
      fcmToken: json['fcmToken'],
      houseId: json['houseId'],
      estateId: json['estateId'],
      estateName: json['estateName'],
      isAdmin: json['isAdmin'],
    );
  }
}
