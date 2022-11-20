import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persian_date/persian_date.dart';

class ShowCountryInformation extends StatefulWidget {
  final country;

  ShowCountryInformation({@required this.country});

  @override
  State<ShowCountryInformation> createState() => _ShowCountryInformationState();
}

class _ShowCountryInformationState extends State<ShowCountryInformation> {
  List items = [];
  bool loading = true;
  PersianDate persianDate = PersianDate();
  var toDate;
  var fromDate;
  var date = DateTime.now();

  @override
  void initState() {
    super.initState();
    toDate = date.toString().split(' ')[0];
    fromDate = DateTime(date.year, date.month-1, date.day-2).toString().split(' ')[0];
    _setData();
  }

  @override
  Widget build(BuildContext context) {
    print(date.toString().split(' ')[0]);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text('${widget.country['Slug']}'),
                backgroundColor: Colors.indigo,
                pinned: true,
                actions: [
                  Container(
                    child: Image.asset(
                      'images/flags/${widget.country['ISO2'].toLowerCase()}.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ],
              )
            ];
          },
          body: _buildBody()),
    );
  }

  void _setData() async {
    // https://developers.google.com/books/docs/overview
    var url =
        'https://api.covid19api.com/country/${widget.country['Slug']}?from=${fromDate}T00:00:00Z&to=${toDate}T00:00:00Z';
    // Await the http get response, then decode the json-formatted response.
    var response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
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
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = items[index];
                  if (index == 0) {
                    return Container();
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Material(
                      elevation: 3,
                      shadowColor: Colors.indigo.withOpacity(0.3),
                      child: ListTile(
                        subtitle: Text(
                          '${persianDate.gregorianToJalali(item['Date'], "yyyy-m-d")}', style: TextStyle(height: 1.8),),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'مبتلایان جدید: ${items[index]['Confirmed'] - items[index - 1]['Confirmed']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'بهبودیافتگان: ${items[index]['Recovered'] - items[index - 1]['Recovered']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'جان باختگان: ${items[index]['Deaths'] - items[index - 1]['Deaths']}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
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
