import 'package:flutter/material.dart';
import 'package:shopping/productsListData.dart';
import 'package:shopping/productsListItem.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProductsList extends StatefulWidget {
  ProductsList({Key key}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  //
  static String category;
  //
  String getProductCategories = """
  query(\$category: uuid!){
    product(where: {Category: {ID: {_eq: \$category}}}, limit:5 ) {
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
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: SingleChildScrollView(
        // Running the Query in this widget
        child: Column(
          children: <Widget>[
            Container(
              height: 130.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    height: 100.0,
                    child: Center(
                      child: Text(
                        "Products",
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
                                print("your menu action here");
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
            Container(
              child: Query(
                options: QueryOptions(
                    documentNode: gql(getProductCategories),
                    variables: {
                      "category": "7e369680-7498-4c06-b974-19649f12d047"
                    }),
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
                  ProductsListDataList pl =
                      ProductsListDataList.fromResponse(result.data['product']);
                  // Displaying the ListView on successful response
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    //height: 500.0,
                    //width: 400.0,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 3),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: pl.productsList.length,
                        itemBuilder: (context, index) {
                          // Category Object contains the name & url of category
                          final productsList = pl.productsList[index];

                          // Showing custom item ui for a particular category
                          return ProductsListItem(productsList: productsList);
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
