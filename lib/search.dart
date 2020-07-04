import 'package:flutter/material.dart';
import 'package:shopping/searchData.dart';
import 'package:shopping/searchItem.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shopping/searchArguments.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  //
  static String search;
  //
  String getSearchCategories = """
  query (\$search: String!) {
  product(where: {name: {_ilike: \$search}}) {
    ID
    name
    Images(limit: 1) {
      url
    }
    currency
    price
    rating
    ratingCount
    Seller {
      Name
    }
  }
}
  """;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final SearchArguments args = ModalRoute.of(context).settings.arguments;

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
                    height: 130.0,
                    child: Center(
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.white, fontSize: 28.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Query(
                options: QueryOptions(
                    documentNode: gql(getSearchCategories),
                    variables: {
                      "search": args.searchStr,
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
                  SearchDataList sl =
                      SearchDataList.fromResponse(result.data['product']);
                  // Displaying the ListView on successful response
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    //height: 500.0,
                    //width: 400.0,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: sl.searchDataList.length,
                        itemBuilder: (context, index) {
                          // Category Object contains the name & url of category
                          final searchDataList = sl.searchDataList[index];

                          // Showing custom item ui for a particular category
                          return SearchItem(searchDataList: searchDataList);
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
