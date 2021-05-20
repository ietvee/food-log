import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodData extends StatelessWidget {
  final String apiUrl =
      "https://api.edamam.com/search?q=chicken&app_id=2a8139ca&app_key=7c2a72e3232ab19beadbad328c0fe09f&from=0&to=100&calories=591-722&health=alcohol-free";

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
      appBar: AppBar(
        title: Text('Food List'),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchFoods(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  // shrinkWrap: true,
                  // scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                            ),
                            title: Text(_name(snapshot.data[index])),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
