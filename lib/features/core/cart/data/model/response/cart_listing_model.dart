part of 'response.dart';

class CartListingModel {
    int? id;
    int? userId;
    DateTime? date;
    List<Product>? products;
    int? v;

    CartListingModel({
        this.id,
        this.userId,
        this.date,
        this.products,
        this.v,
    });

    CartListingModel copyWith({
        int? id,
        int? userId,
        DateTime? date,
        List<Product>? products,
        int? v,
    }) => 
        CartListingModel(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            date: date ?? this.date,
            products: products ?? this.products,
            v: v ?? this.v,
        );

    factory CartListingModel.fromJson(Map<String, dynamic> json) => CartListingModel(
        id: json["id"],
        userId: json["userId"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "date": date?.toIso8601String(),
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
        "__v": v,
    };
}

class Product {
    int? productId;
    int? quantity;

    Product({
        this.productId,
        this.quantity,
    });

    Product copyWith({
        int? productId,
        int? quantity,
    }) => 
        Product(
            productId: productId ?? this.productId,
            quantity: quantity ?? this.quantity,
        );

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "quantity": quantity,
    };
}
