import 'package:flutter/material.dart';
import 'package:shopping/productDetailsData.dart';
import 'package:shopping/productDetailsItem.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({Key key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  //
  static String productID;
  String currency, price, rating, ratingCount;
  //
  String getProductDetails = """
query (\$productID: uuid!) {
  product(where: {ID: {_eq: \$productID}}) {
    name
    description
    currency
    price
    rating
    ratingCount
    Images {
      url
    }
    reviews {
      name
      profile_url
      review
      rating
    }
    product_tags {
      tag {
        tag
      }
    }
    Seller {
      Name
      ID
      seller_rating
      seller_profile
    }
  }
}
  """;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: SingleChildScrollView(
        // Running the Query in this widget
        child: Stack(
          children: <Widget>[
            Container(
              child: Query(
                options: QueryOptions(
                    documentNode: gql(getProductDetails),
                    variables: {
                      "productID": "7e928b70-475b-4e23-9a5f-1ced7df856d2"
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
                  ProductDetailsDataList pdl =
                      ProductDetailsDataList.fromResponse(
                          result.data['product']);

                  // Displaying the ListView on successful response
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    //height: 500.0,
                    //width: 400.0,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: pdl.productDetailsList.length,
                        itemBuilder: (context, index) {
                          // Category Object contains the name & url of category
                          final productDetailsList =
                              pdl.productDetailsList[index];

                          // Showing custom item ui for a particular category
                          return ProductDetailsItem(
                              productDetailsList: productDetailsList);
                        }),
                  );
                },
              ),
            ),
            Positioned(
              left: 20,
              top: 50,
              child: FloatingActionButton(
                foregroundColor: Colors.black54,
                backgroundColor: Colors.yellow[600],
                child: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  print('Clicked');
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          color: Colors.black87,
          height: 50.0,
        ),
      ),
    );
  }
}
