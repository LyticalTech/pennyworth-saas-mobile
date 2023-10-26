import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residents/models/other/firebase_resident.dart';

class Product {
  final String name;
  final String? id, description, color;
  final List<String> images;
  final double price;
  final double? size;
  final FirebaseResident? seller;
  final String sellerId;
  final bool outOfStock;

  Product({
    this.seller,
    required this.images,
    required this.name,
    required this.price,
    required this.sellerId,
    this.id,
    this.description,
    this.color,
    this.size,
    this.outOfStock = false
  });

  factory Product.fromSnapshot(DocumentSnapshot snapshot) {
    return Product(
      id: snapshot.id,
      name: snapshot["name"],
      description: snapshot["description"],
      color: snapshot["color"],
      images: (snapshot["images"] as List).map((item) => item as String).toList(),
      price: snapshot["price"],
      size: snapshot["size"],
      outOfStock: snapshot["out_of_stock"] ?? false,
      seller: FirebaseResident.fromJson(snapshot["seller"]),
      sellerId: snapshot['sellerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "color": color,
      "images": images,
      "price": price,
      "size": size,
      "out_of_stock": outOfStock,
      "seller": seller?.toSnapshot(),
      "sellerId": sellerId
    };
  }
}