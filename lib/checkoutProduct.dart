import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'shippingModel.dart';

class CheckoutProduct extends StatefulWidget {
  CheckoutProduct({Key key}) : super(key: key);

  @override
  _CheckoutProductState createState() => _CheckoutProductState();
}

class _CheckoutProductState extends State<CheckoutProduct> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              child: new FutureBuilder(
                  future: DefaultAssetBundle.of(context)
                      .loadString('assets/product.json'),
                  builder: (context, snapshot) {
                    var cdl = json.decode(snapshot.data.toString());
                    var result = cdl['data']['product'][0];

                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        // Build the ListView
                        itemBuilder: (BuildContext context, int index) {
                          return SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                onTap: () {
                                  print("You have tapped on ${result['name']}");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .width,
                                            width: 370,
                                            child: Center(
                                              child:
                                                  CupertinoActivityIndicator(),
                                            ),
                                          ),
                                          CarouselSlider(
                                            options:
                                                CarouselOptions(height: 370.0),
                                            items: [
                                              result['Images'][0]['url'],
                                              result['Images'][1]['url'],
                                              result['Images'][2]['url'],
                                            ].map((i) {
                                              return Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                    ),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      //height: 370,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
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
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          result['name'],
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 45, 0),
                                              child: Text(
                                                result['currency'].toString() +
                                                    " " +
                                                    result['price'].toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green[600],
                                                ),
                                              ),
                                            ),
                                            (double.parse(result['rating']
                                                        .toString()) >=
                                                    4.0)
                                                ? Container(
                                                    child: new IconTheme(
                                                      data: new IconThemeData(
                                                          color: Colors.green),
                                                      child: new Icon(
                                                          Icons.star_border),
                                                    ),
                                                  )
                                                : (double.parse(result['rating']
                                                                .toString()) <
                                                            4.0 &&
                                                        double.parse(result[
                                                                    'rating']
                                                                .toString()) >
                                                            2.0)
                                                    ? Container(
                                                        child: new IconTheme(
                                                          data:
                                                              new IconThemeData(
                                                                  color: Colors
                                                                      .yellow),
                                                          child: new Icon(Icons
                                                              .star_border),
                                                        ),
                                                      )
                                                    : Container(
                                                        child: new IconTheme(
                                                          data:
                                                              new IconThemeData(
                                                                  color: Colors
                                                                      .red),
                                                          child: new Icon(Icons
                                                              .star_border),
                                                        ),
                                                      ),
                                            Text(
                                              result['rating'].toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              " (" +
                                                  result['ratingCount']
                                                      .toString() +
                                                  ")",
                                              style: TextStyle(
                                                fontSize: 16,
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      !pressed
                                          ? Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 8, 8),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: 300,
                                                      child: RaisedButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                        onPressed: () {
                                                          setState(() {
                                                            pressed = !pressed;
                                                          });
                                                        },
                                                        color: Colors.white,
                                                        textColor: Colors.black,
                                                        child: Text(
                                                          "Read More",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            //fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    result['description'],
                                                    //overflow: TextOverflow.ellipsis,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 8, 8),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: 300,
                                                      child: RaisedButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                        onPressed: () {
                                                          setState(() {
                                                            pressed = !pressed;
                                                          });
                                                        },
                                                        color: Colors.white,
                                                        textColor: Colors.black,
                                                        child: Text(
                                                          "Read Less",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            //fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Container(
                                          height: 2.0,
                                          width: 330.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 8, 8),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Reviews',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                children: result['reviews']
                                                    .map<Widget>((item) {
                                                  return Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 8, 8, 8),
                                                        child: Container(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Column(
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                        child:
                                                                            Stack(
                                                                          children: <
                                                                              Widget>[
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
                                                                                shape: BoxShape.circle,
                                                                                image: DecorationImage(image: NetworkImage(item['profile_url'] ?? 'https://graphql.org/users/logos/github.png'), fit: BoxFit.fill),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            4,
                                                                            4,
                                                                            0,
                                                                            4),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            (double.parse(item['rating'].toString()) >= 4.5)
                                                                                ? Row(
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        child: new IconTheme(
                                                                                          data: new IconThemeData(color: Colors.amber),
                                                                                          child: new Icon(Icons.star),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        child: new IconTheme(
                                                                                          data: new IconThemeData(color: Colors.amber),
                                                                                          child: new Icon(Icons.star),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        child: new IconTheme(
                                                                                          data: new IconThemeData(color: Colors.amber),
                                                                                          child: new Icon(Icons.star),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        child: new IconTheme(
                                                                                          data: new IconThemeData(color: Colors.amber),
                                                                                          child: new Icon(Icons.star),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        child: new IconTheme(
                                                                                          data: new IconThemeData(color: Colors.amber),
                                                                                          child: new Icon(Icons.star),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                : (double.parse(item['rating'].toString()) >= 4.0)
                                                                                    ? Row(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            child: new IconTheme(
                                                                                              data: new IconThemeData(color: Colors.amber),
                                                                                              child: new Icon(Icons.star),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            child: new IconTheme(
                                                                                              data: new IconThemeData(color: Colors.amber),
                                                                                              child: new Icon(Icons.star),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            child: new IconTheme(
                                                                                              data: new IconThemeData(color: Colors.amber),
                                                                                              child: new Icon(Icons.star),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            child: new IconTheme(
                                                                                              data: new IconThemeData(color: Colors.amber),
                                                                                              child: new Icon(Icons.star),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : (double.parse(item['rating'].toString()) >= 3.0)
                                                                                        ? Row(
                                                                                            children: <Widget>[
                                                                                              Container(
                                                                                                child: new IconTheme(
                                                                                                  data: new IconThemeData(color: Colors.amber),
                                                                                                  child: new Icon(Icons.star),
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                child: new IconTheme(
                                                                                                  data: new IconThemeData(color: Colors.amber),
                                                                                                  child: new Icon(Icons.star),
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                child: new IconTheme(
                                                                                                  data: new IconThemeData(color: Colors.amber),
                                                                                                  child: new Icon(Icons.star),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        : (double.parse(item['rating'].toString()) >= 2.0)
                                                                                            ? Row(
                                                                                                children: <Widget>[
                                                                                                  Container(
                                                                                                    child: new IconTheme(
                                                                                                      data: new IconThemeData(color: Colors.amber),
                                                                                                      child: new Icon(Icons.star),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    child: new IconTheme(
                                                                                                      data: new IconThemeData(color: Colors.amber),
                                                                                                      child: new Icon(Icons.star),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              )
                                                                                            : Row(
                                                                                                children: <Widget>[
                                                                                                  Container(
                                                                                                    child: new IconTheme(
                                                                                                      data: new IconThemeData(color: Colors.amber),
                                                                                                      child: new Icon(Icons.star),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                            Text(
                                                                              "From " + item['name'],
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.grey[700],
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              item['review'],
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 15,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Container(
                                          height: 2.0,
                                          width: 330.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 8, 8),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Tags',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: result['product_tags']
                                                  .map<Widget>((item) {
                                                return Builder(
                                                  builder:
                                                      (BuildContext context) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          18, 2, 4, 2),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          width: 150,
                                                          child: RaisedButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                            onPressed: () {},
                                                            color: Colors.white,
                                                            textColor:
                                                                Colors.black,
                                                            child: Text(
                                                              item['tag'].toString().substring(
                                                                  item['tag']
                                                                      .toString()
                                                                      .indexOf(
                                                                          " "),
                                                                  item['tag']
                                                                      .toString()
                                                                      .indexOf(
                                                                          "}")),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                //fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Container(
                                          height: 2.0,
                                          width: 330.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
            Positioned(
              left: 100,
              top: 400,
              right: 10,
              bottom: 0,
              child: Opacity(
                opacity: 0.0,
                child: RaisedButton(
                  // foregroundColor: Colors.white,
                  // backgroundColor: Colors.white,
                  child: Icon(Icons.keyboard_arrow_left),
                  onPressed: () {
                    null;
                  },
                ),
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
          child: Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.yellow[600])),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/paymentPage',
                          arguments: ShippingModel(
                            firstName: "-",
                            lastName: "-",
                            address: "-",
                            city: "-",
                            state: "-",
                            pinCode: "-",
                          ),
                        );
                      },
                      color: Colors.yellow[600],
                      textColor: Colors.black,
                      child: Text(
                        "Buy now".toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
