import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'Category.dart';

class CategoryItem extends StatefulWidget {
  final Category category;

  CategoryItem({@required this.category});

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      child: GestureDetector(
        onTap: () {
          print("You have tapped on ${widget.category.name}");
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              child: Row(
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.category.name,
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
