import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';

class FoodData extends StatelessWidget {
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
    return Scaffold(
      body: Column(
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
                color: Colors.orangeAccent,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 700,
              child: FutureBuilder<List<dynamic>>(
                future: fetchFoods(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 200,
                              width: 400,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: <Widget>[
                                      Image(
                                        image: NetworkImage(
                                            _image(snapshot.data[index])),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 20, 0, 0),
                                        child: Text(
                                          _name(snapshot.data[index]),
                                          style: TextStyle(fontSize: 28),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text("Click here to know more:"),
                                        ],
                                      ),
                                      Linkify(
                                        onOpen: (link) async {
                                          if (await canLaunch(link.url)) {
                                            await launch(link.url);
                                          } else {
                                            throw 'Could not launch $link';
                                          }
                                        },
                                        text: _url(snapshot.data[index]),
                                        style: TextStyle(color: Colors.yellow),
                                        linkStyle: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 28),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.orangeAccent),
                        ),
                        Container(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text('loading ...',
                                  style: TextStyle(
                                      letterSpacing: 2, color: Colors.black54)),
                            ])
                      ],
                    ));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
