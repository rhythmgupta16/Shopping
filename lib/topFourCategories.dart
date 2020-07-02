class TopFourCategories {
  String name;
  String imgURL;

  TopFourCategories(this.name, this.imgURL);

  factory TopFourCategories.fromResults(Map<String, dynamic> result) {
    return TopFourCategories(result['Category_name'], result['Category_url']);
  }
}

class TopFourCategoryList {
  List<TopFourCategories> categories;

  TopFourCategoryList(this.categories);

  factory TopFourCategoryList.fromResponse(List<dynamic> list) {
    List<TopFourCategories> temp = List<TopFourCategories>();
    list.forEach((item) {
      temp.add(TopFourCategories(item['Category_name'], item['Category_url']));
    });
    return TopFourCategoryList(temp);
  }
}
