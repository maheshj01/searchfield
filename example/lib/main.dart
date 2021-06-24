import 'package:example/country_model.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Countries Demographic'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countries = data.map((e) => Country.fromMap(e)).toList();
  }

  List<Country> countries = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField<String>(
                      controller: _searchController,
                      hint: 'Search by country name',
                      maxSuggestionsInViewPort: 4,
                      itemHeight: 45,
                      listItemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // sourceController!.text = snapshot.data![index]!;
                            // sourceController!.selection = TextSelection.fromPosition(
                            //   TextPosition(
                            //     offset: sourceController!.text.length,
                            //   ),
                            // );
                            // // hide the suggestions
                            // sourceStream.sink.add(null);
                            // if (widget.onTap != null) {
                            //   widget.onTap!(snapshot.data![index]);
                            // }
                          },
                          child: Container(
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 5) +
                                EdgeInsets.only(left: 8),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.pink),
                              ),
                            ),
                            child: Text(
                              countries[index].name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      optionsBuilder: (text) {
                        if (text.isEmpty) {
                          return [];
                        }
        
                        return [];
                      }),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (_, index) => ListTile(
                      title: Text(countries[index].name),
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute<CountryDetail>(
                              builder: (_) => CountryDetail(
                                    country: countries[index],
                                  ))),
                    ),
                  ),
                )
              ],
            )));
  }
}

class CountryDetail extends StatefulWidget {
  final Country country;

  const CountryDetail({Key? key, required this.country}) : super(key: key);
  @override
  _CountryDetailState createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  Widget dataWidget(String key, int value) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$key:"),
          SizedBox(
            width: 16,
          ),
          Text(
            '$value',
            style: TextStyle(fontSize: 30),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: Text(
              widget.country.name,
              style: TextStyle(fontSize: 40),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          dataWidget('Population:', widget.country.population),
          dataWidget('Density', widget.country.density),
          dataWidget('Land Area (in Km\'s)', widget.country.landArea)
        ],
      ),
    );
  }
}
