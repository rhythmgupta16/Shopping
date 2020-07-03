import 'package:flutter/material.dart';
import 'package:shopping/Category.dart';
import 'package:shopping/CategoryItem.dart';
import 'package:shopping/topFourCategories.dart';
import 'package:shopping/topFourCategoriesItem.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shopping/trending.dart';
import 'package:shopping/trendingItem.dart';
import 'package:shopping/searchProducts.dart';
import 'package:shopping/featured.dart';
import 'package:shopping/featuredItem.dart';

class ShopMainScreen extends StatefulWidget {
  ShopMainScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ShopMainScreen createState() => _ShopMainScreen();
}

class _ShopMainScreen extends State<ShopMainScreen> {
  //used for the first list
  bool pressed = false;

  // GraphQL query to be fetched
  String getCategories = """
  query {
    Category{
      Category_name
      Category_url
    }
  }
""";

  String getTopFourCategories = """
  query{
    Category(limit:4){
      ID
      Category_name
      Category_url
    }
  }
  """;

  String getTrendingCategories = """
  query{
    product(where: {isTrending: {_eq: true}}) {
      ID
      name
      Images(limit: 1) {
        url
      }
      currency
      price
      rating
      ratingCount
    }
  }
  """;

  String getFeaturedCategories = """
  query{
    product(where: {isFeatured: {_eq: true}}) {
      ID
      name
      Images(limit: 1) {
        url
      }
      currency
      price
      rating
      ratingCount
    }
  }
  """;

  // String searchProducts = """
  // query($search:String!){
  //   product(where: {name: {_ilike: $search}}) {
  //     ID
  //     name
  //     Images(limit: 1) {
  //       url
  //     }
  //     currency
  //     price
  //     rating
  //     ratingCount
  //     Seller {
  //       Name
  //     }
  //   }
  // }
  // """;

  static String search;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
      ),
      body: SingleChildScrollView(
        // Running the Query in this widget
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.5, 4, 0.5, 20),
              child: Column(
                //Checking if list is expanded or not?
                children: <Widget>[
                  !pressed
                      ? Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          elevation: 7,
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Query(
                                  options: QueryOptions(
                                    documentNode: gql(getTopFourCategories),
                                  ),
                                  builder: (QueryResult result,
                                      {VoidCallback refetch,
                                      FetchMore fetchMore}) {
                                    if (result.hasException) {
                                      // error connecting to server
                                      print(result.exception.toString());
                                      return Text(
                                          "Error Connecting to server!");
                                    }

                                    if (result.loading) {
                                      // getting data from the server
                                      return CircularProgressIndicator();
                                    }
                                    // Casting the Categories into CategoryList Object present in Category.dart
                                    TopFourCategoryList cl =
                                        TopFourCategoryList.fromResponse(
                                            result.data['Category']);
                                    // Displaying the ListView on successful response
                                    return Container(
                                      margin: EdgeInsets.all(5.0),
                                      height: 100.0,
                                      width: 336.0,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: cl.categories.length,
                                          itemBuilder: (context, index) {
                                            // Category Object contains the name & url of category
                                            final category =
                                                cl.categories[index];

                                            // Showing custom item ui for a particular category
                                            return TopFourCategoriesItem(
                                                category: category);
                                          }),
                                    );
                                  },
                                ),
                              ),
                              ClipOval(
                                child: Material(
                                  color: Colors.white, // button color
                                  child: InkWell(
                                    splashColor: Colors.white, // inkwell color
                                    child: SizedBox(
                                        width: 56,
                                        height: 56,
                                        child: Icon(Icons.arrow_downward)),
                                    onTap: () {
                                      setState(() {
                                        pressed = !pressed;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          elevation: 7,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Query(
                                  options: QueryOptions(
                                    documentNode: gql(getCategories),
                                  ),
                                  builder: (QueryResult result,
                                      {VoidCallback refetch,
                                      FetchMore fetchMore}) {
                                    if (result.hasException) {
                                      // error connecting to server
                                      print(result.exception.toString());
                                      return Text(
                                          "Error Connecting to server!");
                                    }

                                    if (result.loading) {
                                      // getting data from the server
                                      return CircularProgressIndicator();
                                    }
                                    // Casting the Categories into CategoryList Object present in Category.dart
                                    CategoryList cl = CategoryList.fromResponse(
                                        result.data['Category']);
                                    // Displaying the ListView on successful response
                                    return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: cl.categories.length,
                                        itemBuilder: (context, index) {
                                          // Category Object contains the name & url of category
                                          final category = cl.categories[index];

                                          // Showing custom item ui for a particular category
                                          return CategoryItem(
                                              category: category);
                                        });
                                  },
                                ),
                              ),
                              ClipOval(
                                child: Material(
                                  color: Colors.white, // button color
                                  child: InkWell(
                                    splashColor: Colors.white, // inkwell color
                                    child: SizedBox(
                                        width: 56,
                                        height: 56,
                                        child: Icon(Icons.arrow_upward)),
                                    onTap: () {
                                      setState(() {
                                        pressed = !pressed;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            Text(
              'Trending',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            Container(
              child: Query(
                options: QueryOptions(
                  documentNode: gql(getTrendingCategories),
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  if (result.hasException) {
                    // error connecting to server
                    print(result.exception.toString());
                    return Text("Error Connecting to server!");
                  }

                  if (result.loading) {
                    // getting data from the server
                    return CircularProgressIndicator();
                  }
                  // Casting the Categories into CategoryList Object present in Category.dart
                  TrendingList cl =
                      TrendingList.fromResponse(result.data['product']);
                  // Displaying the ListView on successful response
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    height: 250.0,
                    width: 400.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: cl.trending.length,
                        itemBuilder: (context, index) {
                          // Category Object contains the name & url of category
                          final trending = cl.trending[index];

                          // Showing custom item ui for a particular category
                          return TrendingItem(trending: trending);
                        }),
                  );
                },
              ),
            ),
            Text(
              'Featured',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            Container(
              child: Query(
                options: QueryOptions(
                  documentNode: gql(getFeaturedCategories),
                ),
                builder: (QueryResult result,
                    {VoidCallback refetch, FetchMore fetchMore}) {
                  if (result.hasException) {
                    // error connecting to server
                    print(result.exception.toString());
                    return Text("Error Connecting to server!");
                  }

                  if (result.loading) {
                    // getting data from the server
                    return CircularProgressIndicator();
                  }
                  // Casting the Categories into CategoryList Object present in Category.dart
                  TrendingList cl =
                      TrendingList.fromResponse(result.data['product']);
                  // Displaying the ListView on successful response
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    height: 250.0,
                    width: 400.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: cl.trending.length,
                        itemBuilder: (context, index) {
                          // Category Object contains the name & url of category
                          final trending = cl.trending[index];

                          // Showing custom item ui for a particular category
                          return TrendingItem(trending: trending);
                        }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
