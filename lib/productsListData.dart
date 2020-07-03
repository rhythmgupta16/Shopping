class ProductsListData {
  String name;
  String imgURL;
  String rating;
  String ratingCount;
  String price;
  String currency;

  ProductsListData(
    this.name,
    //this.imgURL,
    this.rating,
    this.ratingCount,
    this.price,
    this.currency,
  );

  factory ProductsListData.fromResults(Map<String, dynamic> result) {
    return ProductsListData(
      result['name'],
      //result['Images']['url'],
      result['rating'],
      result['ratingCount'],
      result['price'],
      result['currency'],
    );
  }
}

class ProductsListDataList {
  List<ProductsListData> productsList;

  ProductsListDataList(this.productsList);

  factory ProductsListDataList.fromResponse(List<dynamic> list) {
    List<ProductsListData> temp = List<ProductsListData>();
    list.forEach((item) {
      temp.add(ProductsListData(
          item['name'],
          //item['Images'][0]['url'],
          (item['rating']).toString(),
          (item['ratingCount']).toString(),
          (item['price']).toString(),
          item['currency']));
    });
    return ProductsListDataList(temp);
  }
}
