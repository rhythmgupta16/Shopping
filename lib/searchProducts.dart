class SearchProducts {
  String id;
  String firstName;
  String lastName;
  String profileUrl;

  SearchProducts(
    this.id,
    this.firstName,
    this.lastName,
    this.profileUrl,
  );

  factory SearchProducts.fromResults(Map<String, dynamic> result) {
    return SearchProducts(
      result['ID'],
      result['name'],
      result['currency'],
      result['Images']['url'],
    );
  }
}

class SearchProductsList {
  List<SearchProducts> trending;

  SearchProductsList(this.trending);

  factory SearchProductsList.fromResponse(List<dynamic> list) {
    List<SearchProducts> temp = List<SearchProducts>();
    list.forEach((item) {
      temp.add(SearchProducts(
        item['ID'],
        item['name'],
        item['currency'],
        item['Images'][0]['url'],
      ));
    });
    return SearchProductsList(temp);
  }
}
