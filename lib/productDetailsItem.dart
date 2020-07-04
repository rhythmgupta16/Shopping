import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopping/productDetailsData.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailsItem extends StatefulWidget {
  final ProductDetailsData productDetailsList;

  ProductDetailsItem({@required this.productDetailsList});

  @override
  _ProductDetailsItemState createState() => _ProductDetailsItemState();
}

class _ProductDetailsItemState extends State<ProductDetailsItem> {
  @override
  Widget build(BuildContext context) {
    //print(widget.productDetailsList.reviews[0].name);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          print("You have tapped on ${widget.productDetailsList.name}");
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: 370,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),

                  CarouselSlider(
                    options: CarouselOptions(height: 370.0),
                    items: [
                      widget.productDetailsList.imageOne,
                      widget.productDetailsList.imageTwo,
                      widget.productDetailsList.imageThree,
                    ].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: Colors.blueAccent),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              //height: 370,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: NetworkImage(i ??
                                        'https://graphql.org/users/logos/github.png'),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  )
                  // Positioned.fill(
                  //   child: Align(
                  //     alignment: Alignment.bottomLeft,
                  //     child: Container(
                  //       width: 70,
                  //       height: 25,
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.only(
                  //               topRight: Radius.circular(40)),
                  //           border: Border.all(
                  //               width: 1,
                  //               color: Colors.green,
                  //               style: BorderStyle.solid)),
                  //       child: Align(
                  //         alignment: Alignment.center,
                  //         child: Text(
                  //           widget.productDetailsList.currency +
                  //               " " +
                  //               widget.productDetailsList.price,
                  //           style: TextStyle(fontSize: 12),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.productDetailsList.name,
                  //overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    (double.parse(widget.productDetailsList.rating) >= 4.0)
                        ? Container(
                            child: new IconTheme(
                              data: new IconThemeData(color: Colors.green),
                              child: new Icon(Icons.star_border),
                            ),
                          )
                        : (double.parse(widget.productDetailsList.rating) <
                                    4.0 &&
                                double.parse(widget.productDetailsList.rating) >
                                    2.0)
                            ? Container(
                                child: new IconTheme(
                                  data: new IconThemeData(color: Colors.yellow),
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
                      widget.productDetailsList.rating,
                    ),
                    Text(
                      " (" + widget.productDetailsList.ratingCount + ")",
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
