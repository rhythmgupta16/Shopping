import 'package:flutter/material.dart';
import 'package:shopping/Category.dart';
import 'package:shopping/CategoryItem.dart';
import 'package:shopping/searchArguments.dart';
import 'package:shopping/topFourCategories.dart';
import 'package:shopping/topFourCategoriesItem.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shopping/trending.dart';
import 'package:shopping/trendingItem.dart';
import 'package:shopping/featured.dart';
import 'package:shopping/featuredItem.dart';

class ShopMainScreen extends StatefulWidget {
  ShopMainScreen({Key key, this.title}) : super(key: key);
  final String title;

  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  _ShopMainScreen createState() => _ShopMainScreen();
}

class _ShopMainScreen extends State<ShopMainScreen> {
  //used for the first list
  final myController = TextEditingController();
  bool pressed = false;
  String searchString;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

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
    product(where: {isFeatured: {_eq: true}}, limit:4) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Running the Query in this widget
        child: Column(
          children: <Widget>[
            Container(
              height: 140.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    height: 100.0,
                    child: Center(
                      child: Text(
                        "Home",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.0),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0),
                            color: Colors.white),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                print("your menu action here");
                                //_scaffoldKey.currentState.openDrawer();
                              },
                            ),
                            Expanded(
                              child: TextField(
                                controller: myController,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                searchString = ("%" + myController.text + "%");
                                print(searchString);
                                Navigator.pushNamed(context, '/search',
                                    arguments: SearchArguments(searchString));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.5, 0, 0.5, 20),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Icon(Icons.trending_up),
                      ),
                      Text(
                        'Trending',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Icon(Icons.shopping_basket),
                      ),
                      Text(
                        'Featured',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
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
                  FeaturedList fl =
                      FeaturedList.fromResponse(result.data['product']);
                  // Displaying the ListView on successful response
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    height: 250.0,
                    width: 400.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: fl.featured.length,
                        itemBuilder: (context, index) {
                          // Category Object contains the name & url of category
                          final featured = fl.featured[index];

                          // Showing custom item ui for a particular category
                          return FeaturedItem(featured: featured);
                        }),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Books',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
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
                  FeaturedList fl =
                      FeaturedList.fromResponse(result.data['product']);
                  // Displaying the ListView on successful response
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    height: 250.0,
                    width: 400.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: fl.featured.length,
                        itemBuilder: (context, index) {
                          // Category Object contains the name & url of category
                          final featured = fl.featured[index];

                          // Showing custom item ui for a particular category
                          return FeaturedItem(featured: featured);
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
