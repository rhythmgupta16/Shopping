class SearchData {
  String name;
  //String imgURL;
  String rating;
  String ratingCount;
  String price;
  String currency;

  SearchData(
    this.name,
    //this.imgURL,
    this.rating,
    this.ratingCount,
    this.price,
    this.currency,
  );

  factory SearchData.fromResults(Map<String, dynamic> result) {
    return SearchData(
      result['name'],
      //result['Images']['url'],
      result['rating'],
      result['ratingCount'],
      result['price'],
      result['currency'],
    );
  }
}

class SearchDataList {
  List<SearchData> searchDataList;

  SearchDataList(this.searchDataList);

  factory SearchDataList.fromResponse(List<dynamic> list) {
    List<SearchData> temp = List<SearchData>();
    list.forEach((item) {
      temp.add(SearchData(
          item['name'],
          //item['Images'][0]['url'],
          (item['rating']).toString(),
          (item['ratingCount']).toString(),
          (item['price']).toString(),
          item['currency']));
    });
    return SearchDataList(temp);
  }
}
