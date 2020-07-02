class Trending {
  String name;
  String imgURL;
  String rating;
  String ratingCount;
  String price;
  String currency;

  Trending(
    this.name,
    this.imgURL,
    this.rating,
    this.ratingCount,
    this.price,
    this.currency,
  );

  factory Trending.fromResults(Map<String, dynamic> result) {
    return Trending(
      result['name'],
      result['Images']['url'],
      result['rating'],
      result['ratingCount'],
      result['price'],
      result['currency'],
    );
  }
}

class TrendingList {
  List<Trending> trending;

  TrendingList(this.trending);

  factory TrendingList.fromResponse(List<dynamic> list) {
    List<Trending> temp = List<Trending>();
    list.forEach((item) {
      temp.add(Trending(
          item['name'],
          item['Images'][0]['url'],
          (item['rating']).toString(),
          (item['ratingCount']).toString(),
          (item['price']).toString(),
          item['currency']));
    });
    return TrendingList(temp);
  }
}
