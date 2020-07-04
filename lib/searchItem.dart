import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopping/searchData.dart';

class SearchItem extends StatefulWidget {
  final SearchData searchDataList;

  SearchItem({@required this.searchDataList});

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () {
          print("You have tapped on ${widget.searchDataList.name}");
          Navigator.pushNamed(context, '/productDetails');
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                  child: Container(
                    height: 18,
                    child: Text(
                      widget.searchDataList.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: Colors.green,
                          style: BorderStyle.solid),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 40, 0),
                            child: Text(
                              widget.searchDataList.currency +
                                  " " +
                                  widget.searchDataList.price,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
                              ),
                            ),
                          ),
                          (double.parse(widget.searchDataList.rating) >= 4.0)
                              ? Container(
                                  child: new IconTheme(
                                    data:
                                        new IconThemeData(color: Colors.green),
                                    child: new Icon(Icons.star_border),
                                  ),
                                )
                              : (double.parse(widget.searchDataList.rating) <
                                          4.0 &&
                                      double.parse(
                                              widget.searchDataList.rating) >
                                          2.0)
                                  ? Container(
                                      child: new IconTheme(
                                        data: new IconThemeData(
                                            color: Colors.yellow),
                                        child: new Icon(Icons.star_border),
                                      ),
                                    )
                                  : Container(
                                      child: new IconTheme(
                                        data: new IconThemeData(
                                            color: Colors.red),
                                        child: new Icon(Icons.star_border),
                                      ),
                                    ),
                          Text(
                            widget.searchDataList.rating,
                          ),
                          Text(
                            " (" + widget.searchDataList.ratingCount + ")",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
