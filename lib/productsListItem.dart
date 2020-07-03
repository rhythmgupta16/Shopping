import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopping/productsListData.dart';

class ProductsListItem extends StatefulWidget {
  final ProductsListData productsList;

  ProductsListItem({@required this.productsList});

  @override
  _ProductsListItemState createState() => _ProductsListItemState();
}

class _ProductsListItemState extends State<ProductsListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          print("You have tapped on ${widget.productsList.name}");
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 70,
                      width: 70,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: NetworkImage(widget.productsList.imgURL ??
                                'https://graphql.org/users/logos/github.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 70,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40)),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.green,
                                  style: BorderStyle.solid)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.productsList.currency +
                                  " " +
                                  widget.productsList.price,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productsList.name,
                    //overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      (double.parse(widget.productsList.rating) >= 4.0)
                          ? Container(
                              child: new IconTheme(
                                data: new IconThemeData(color: Colors.green),
                                child: new Icon(Icons.star_border),
                              ),
                            )
                          : (double.parse(widget.productsList.rating) < 4.0 &&
                                  double.parse(widget.productsList.rating) >
                                      2.0)
                              ? Container(
                                  child: new IconTheme(
                                    data:
                                        new IconThemeData(color: Colors.yellow),
                                    child: new Icon(Icons.star_border),
                                  ),
                                )
                              : Container(
                                  child: new IconTheme(
                                    data: new IconThemeData(color: Colors.red),
                                    child: new Icon(Icons.star_border),
                                  ),
                                ),
                      Text(
                        widget.productsList.rating,
                      ),
                      Text(
                        " (" + widget.productsList.ratingCount + ")",
                      )
                    ],
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
