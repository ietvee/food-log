import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';

class FoodData extends StatelessWidget {
  double widthScreen;
  double heightScreen;
  final String apiUrl =
      "https://api.edamam.com/search?q=chicken&app_id=2a8139ca&app_key=7c2a72e3232ab19beadbad328c0fe09f&from=0&to=100";

  Future<List<dynamic>> fetchFoods() async {
    var result = await http.get(apiUrl);
    return json.decode(result.body)['hits'];
  }

  String _name(dynamic food) {
    return food['recipe']['label'];
  }

  String _url(dynamic food) {
    return food['recipe']['url'];
  }

  String _image(dynamic image) {
    return image['recipe']['image'];
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    widthScreen = mediaQueryData.size.width;
    heightScreen = mediaQueryData.size.height;
    return Scaffold(
      body: Container(
        // color: Colors.red[50],
        height: heightScreen,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.red[400],
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: heightScreen,
                  child: FutureBuilder<List<dynamic>>(
                    future: fetchFoods(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            // padding: EdgeInsets.all(8),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromRGBO(
                                                196, 135, 198, .3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          )
                                        ]),
                                    height: 220,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Row(children: [
                                        Expanded(
                                          flex: 2,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Image(
                                              image: NetworkImage(
                                                  _image(snapshot.data[index])),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 45),
                                                  child: ListTile(
                                                    title: Text(
                                                      _name(
                                                          snapshot.data[index]),
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "For more details, click ↓",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .grey[700]),
                                                        ),
                                                        Linkify(
                                                          onOpen: (link) async {
                                                            if (await canLaunch(
                                                                link.url)) {
                                                              await launch(
                                                                  link.url);
                                                            } else {
                                                              throw 'Could not launch $link';
                                                            }
                                                          },
                                                          text: _url(snapshot
                                                              .data[index]),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .yellow),
                                                          linkStyle: TextStyle(
                                                            color: Colors
                                                                .blueAccent,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                              // return Card(
                              //   child: ListTile(
                              //     leading: Container(
                              //       height: 150,
                              //       width: 150,
                              //       child: ClipRRect(
                              //         borderRadius: BorderRadius.circular(15.0),
                              //         child: Image(
                              //           image: NetworkImage(
                              //               _image(snapshot.data[index])),
                              //         ),
                              //       ),
                              //     ),
                              //     title: Text(
                              //       _name(snapshot.data[index]),
                              //       style: TextStyle(fontSize: 22),
                              //     ),
                              //     subtitle: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: <Widget>[
                              //         Text("Click here to know more:"),
                              //         Linkify(
                              //           onOpen: (link) async {
                              //             if (await canLaunch(link.url)) {
                              //               await launch(link.url);
                              //             } else {
                              //               throw 'Could not launch $link';
                              //             }
                              //           },
                              //           text: _url(snapshot.data[index]),
                              //           // maxLines: null,
                              //           // overflow:
                              //           //     TextOverflow.ellipsis,
                              //           style: TextStyle(color: Colors.yellow),
                              //           linkStyle: TextStyle(
                              //             color: Colors.blueAccent,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // );
                            });
                      } else {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.red[400]),
                            ),
                            Container(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('loading ...',
                                      style: TextStyle(
                                          letterSpacing: 2,
                                          color: Colors.black54)),
                                ])
                          ],
                        ));
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
