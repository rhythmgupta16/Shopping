class ProductDetailsData {
  String name;
  String imageOne;
  String imageTwo;
  String imageThree;
  String rating;
  String ratingCount;
  String price;
  String currency;
  List<Review> reviews;
  List<Tags> tags;

  ProductDetailsData(
    this.name,
    this.imageOne,
    this.imageTwo,
    this.imageThree,
    this.rating,
    this.ratingCount,
    this.price,
    this.currency,
    this.reviews,
    this.tags,
  );

  factory ProductDetailsData.fromResults(Map<String, dynamic> result) {
    return ProductDetailsData(
      result['name'],
      result['Images']['url'],
      result['Images']['url'],
      result['Images']['url'],
      result['rating'],
      result['ratingCount'],
      result['price'],
      result['currency'],
      result['reviews'],
      result['product_tags'],
    );
  }
}

class Review {
  String name;
  String profileURL;
  String review;
  String rating;

  Review(
    this.name,
    this.profileURL,
    this.review,
    this.rating,
  );

  factory Review.fromResults(Map<String, dynamic> result) {
    return Review(
      result['name'],
      result['profile_url'],
      result['review'],
      result['rating'],
    );
  }
}

// class ReviewList {
//   List<Review> reviewList;

//   ReviewList(this.reviewList);

//   factory ReviewList.fromResponse(List<dynamic> list) {
//     List<Review> temp = List<Review>();
//     list.forEach((item) {
//       temp.add(
//         Review(
//           item['name'],
//           item['profile_url'],
//           item['review'],
//           item['rating'].toString(),
//         ),
//       );
//     });
//     return ReviewList(temp);
//   }
// }

class Tags {
  String tag;

  Tags(
    this.tag,
  );

  factory Tags.fromResults(Map<String, dynamic> result) {
    return Tags(
      result['tag'],
    );
  }
}

class ProductDetailsDataList {
  List<ProductDetailsData> productDetailsList;

  ProductDetailsDataList(this.productDetailsList);

  factory ProductDetailsDataList.fromResponse(List<dynamic> list) {
    List<ProductDetailsData> temp = List<ProductDetailsData>();
    list.forEach((item) {
      temp.add(
        ProductDetailsData(
          item['name'],
          item['Images'][0]['url'],
          item['Images'][1]['url'],
          item['Images'][2]['url'],
          (item['rating']).toString(),
          (item['ratingCount']).toString(),
          (item['price']).toString(),
          item['currency'],
          item['reviews'].cast<Review>(),
          item['product_tags'].cast<Tags>(),
        ),
      );
    });
    return ProductDetailsDataList(temp);
  }
}
