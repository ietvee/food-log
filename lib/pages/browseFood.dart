import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodData extends StatelessWidget {
  final String apiUrl =
      "https://api.edamam.com/search?q=chicken&app_id={ID}}&app_key={KEY}&from=0&to=100&calories=591-722&health=alcohol-free";

  Future<List<dynamic>> fetchFoods() async {
    var result = await http.get(apiUrl);
    return json.decode(result.body)['hits'];
  }

  String _name(dynamic food) {
    return food['recipe']['label'];
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
          Expanded(
            child: Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(_name(snapshot.data[index])),
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
