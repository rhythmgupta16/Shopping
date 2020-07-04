import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'trending.dart';

class TrendingItem extends StatefulWidget {
  final Trending trending;

  TrendingItem({@required this.trending});

  @override
  _TrendingItemState createState() => _TrendingItemState();
}

class _TrendingItemState extends State<TrendingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 150,
      child: GestureDetector(
        onTap: () {
          print("You have tapped on ${widget.trending.name}");
          Navigator.pushNamed(context, '/productDetails');
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: NetworkImage(widget.trending.imgURL ??
                                'https://graphql.org/users/logos/github.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 82,
                          height: 23,
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
                              widget.trending.currency +
                                  " " +
                                  widget.trending.price,
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
                  child: Container(
                    height: 66,
                    child: Text(
                      widget.trending.name,
                      //overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      (double.parse(widget.trending.rating) >= 4.0)
                          ? Container(
                              child: new IconTheme(
                                data: new IconThemeData(color: Colors.green),
                                child: new Icon(Icons.star_border),
                              ),
                            )
                          : (double.parse(widget.trending.rating) < 4.0 &&
                                  double.parse(widget.trending.rating) > 2.0)
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
                        widget.trending.rating,
                      ),
                      Text(
                        " (" + widget.trending.ratingCount + ")",
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
