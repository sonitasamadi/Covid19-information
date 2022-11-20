import '/screen/showCountryInformation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowCountries extends StatefulWidget {
  const ShowCountries({Key key}) : super(key: key);

  @override
  State<ShowCountries> createState() => _ShowCountriesState();
}

class _ShowCountriesState extends State<ShowCountries> {
  List countries = [];
  List items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text('Show Countries'),
                backgroundColor: Colors.indigo,
              )
            ];
          },
          body: _buildBody()),
    );
  }

  void _setData() async {
    // https://developers.google.com/books/docs/overview
    var url = 'https://api.covid19api.com/countries';
    // Await the http get response, then decode the json-formatted response.
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
      countries = jsonResponse as List;
      items.addAll(jsonResponse);
      setState(() {
        loading = false;
      });
    } else {}
  }

  Widget _buildBody() {
    if (loading) {
      return SpinKitSquareCircle(
        color: Colors.indigo,
        size: 68.0,
      );
    }
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, left: 8, right: 8),
            child: TextField(
              onChanged: (String value) {
                items.clear();
                if (value.isEmpty) {
                  items.addAll(countries);
                } else {
                  countries.forEach((element) {
                    if (element['Country']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase())) {
                      items.add(element);
                    }
                  });
                }

                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  var country = items[index];
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Material(
                      elevation: 3,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ShowCountryInformation(country: country);
                          }));
                        },
                        title: Text('${country['Country']}'),
                        subtitle: Text('${country['Slug']}'),
                        trailing: Container(
                          child: Image.asset(
                            'images/flags/${country['ISO2'].toLowerCase()}.png',
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
