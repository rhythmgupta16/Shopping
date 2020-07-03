class Featured {
  String name;
  String imgURL;
  String rating;
  String ratingCount;
  String price;
  String currency;

  Featured(
    this.name,
    //this.imgURL,
    this.rating,
    this.ratingCount,
    this.price,
    this.currency,
  );

  factory Featured.fromResults(Map<String, dynamic> result) {
    return Featured(
      result['name'],
      //result['Images']['url'],
      result['rating'],
      result['ratingCount'],
      result['price'],
      result['currency'],
    );
  }
}

class FeaturedList {
  List<Featured> featured;

  FeaturedList(this.featured);

  factory FeaturedList.fromResponse(List<dynamic> list) {
    List<Featured> temp = List<Featured>();
    list.forEach((item) {
      temp.add(
        Featured(
            item['name'],
            //(item['Images'][0]['url']),
            (item['rating']).toString(),
            (item['ratingCount']).toString(),
            (item['price']).toString(),
            item['currency']),
      );
    });
    return FeaturedList(temp);
  }
}
