// import 'package:example/pagination.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: SearchFieldSample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SearchFieldSample extends StatefulWidget {
  const SearchFieldSample({Key? key}) : super(key: key);

  @override
  State<SearchFieldSample> createState() => _SearchFieldSampleState();
}

class _SearchFieldSampleState extends State<SearchFieldSample> {
  @override
  void initState() {
    cities = [
      City('New York', 10001),
      City('Los Angeles', 90001),
      City('Chicago', 60601),
      City('Houston', 77001),
      City('Phoenix', 85001),
      City('Philadelphia', 19101),
      City('San Antonio', 78201),
      City('San Diego', 92101),
      City('Dallas', 75201),
      City('San Jose', 95101),
    ].map(
      (City ct) {
        return SearchFieldListItem<City>(
          ct.name,
          value: ct.zip.toString(),
          item: ct,
          child: Text(ct.name),
        );
      },
    ).toList();
    selectedValue = cities[0];
    super.initState();
  }

  var cities = <SearchFieldListItem<City>>[];
  late SearchFieldListItem<City> selectedValue;
  @override
  Widget build(BuildContext context) {
    Widget searchChild(x, {bool isSelected = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(x,
              style: TextStyle(
                  fontSize: 18, color: isSelected ? Colors.green : null)),
        );
    return Scaffold(
        appBar: AppBar(title: Text('Searchfield Demo')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              SearchField(
                hint: 'Search for a city or zip code',
                // dynamicHeight: true,
                maxSuggestionBoxHeight: 300,
                onSuggestionTap: (SearchFieldListItem<City> item) {
                  setState(() {
                    selectedValue = item;
                  });
                },
                onSearchTextChanged: (searchText) {
                  if (searchText.isEmpty) {
                    return cities;
                  }
                  // filter the list of cities by the search text
                  final filter = List<SearchFieldListItem<City>>.from(cities)
                      .where((city) {
                    return city.item!.name
                            .toLowerCase()
                            .contains(searchText.toLowerCase()) ||
                        city.item!.zip.toString().contains(searchText);
                  }).toList();
                  return filter;
                },
                selectedValue: selectedValue,
                suggestions: cities
                    .map((e) => e.copyWith(
                          child: searchChild(e.item!.name,
                              isSelected: selectedValue == e),
                        ))
                    .toList(),
                suggestionState: Suggestion.expand,
              ),
            ],
          ),
        ));
  }
}

class City {
  String name;
  int zip;
  City(this.name, this.zip);
}
