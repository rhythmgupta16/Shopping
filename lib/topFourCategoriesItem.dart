import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'topFourCategories.dart';

class TopFourCategoriesItem extends StatefulWidget {
  final TopFourCategories category;

  TopFourCategoriesItem({@required this.category});

  @override
  _TopFourCategoriesItemState createState() => _TopFourCategoriesItemState();
}

class _TopFourCategoriesItemState extends State<TopFourCategoriesItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      width: 79,
      child: GestureDetector(
        onTap: () {
          print("You have tapped on ${widget.category.name}");
          Navigator.pushNamed(context, '/productsList');
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(widget.category.imgURL ??
                                'https://graphql.org/users/logos/github.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    widget.category.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9),
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
