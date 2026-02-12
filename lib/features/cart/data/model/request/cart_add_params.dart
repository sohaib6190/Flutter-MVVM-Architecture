
class CartAddParams {
    int? id;
    int? userId;
    List<ProductParams>? products;

    CartAddParams({
        this.id,
        this.userId,
        this.products,
    });

    CartAddParams copyWith({
        int? id,
        int? userId,
        List<ProductParams>? products,
    }) => 
        CartAddParams(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            products: products ?? this.products,
        );

  
    Map<String, dynamic> toJson() => {
      if (id != null) "id": id,
      if (userId != null) "userId": userId,
      if (products != null) "products": List<dynamic>.from(products!.map((x) => x.toJson())),
    };
}

class ProductParams {
    int? id;
    String? title;
    double? price;
    String? description;
    String? category;
    String? image;

    ProductParams({
        this.id,
        this.title,
        this.price,
        this.description,
        this.category,
        this.image,
    });

    ProductParams copyWith({
        int? id,
        String? title,
        double? price,
        String? description,
        String? category,
        String? image,
    }) => 
        ProductParams(
            id: id ?? this.id,
            title: title ?? this.title,
            price: price ?? this.price,
            description: description ?? this.description,
            category: category ?? this.category,
            image: image ?? this.image,
        );



    Map<String, dynamic> toJson() => {
      if (id != null) "id": id,
      if (title != null) "title": title,
      if (price != null) "price": price,
      if (description != null) "description": description,
      if (category != null) "category": category,
      if (image != null) "image": image,
    };
}
