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
      City('New York', '10001'),
      City('Los Angeles', '90001'),
      City('Chicago', '60601'),
      City('Houston', '77001'),
      City('Phoenix', '85001'),
      City('Philadelphia', '19101'),
      City('San Antonio', '78201'),
      City('San Diego', '92101'),
      City('Dallas', '75201'),
      City('San Jose', '95101'),
      City('Austin', '73301'),
      City('Jacksonville', '32099'),
      City('Fort Worth', '76101'),
      City('Columbus', '43201'),
      City('Charlotte', '28201'),
      City('San Francisco', '94101'),
      City('Indianapolis', '46201'),
      City('Seattle', '98101'),
      City('Denver', '80201'),
      City('Washington', '20001'),
      City('Boston', '02101'),
    ].map(
      (City ct) {
        return SearchFieldListItem<City>(
          ct.name,
          value: ct.zip.toString(),
          item: ct,
          child: searchChild(ct, isSelected: false),
        );
      },
    ).toList();
    super.initState();
  }

  Widget searchChild(City city, {bool isSelected = false}) => ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(city.name,
            style: TextStyle(color: isSelected ? Colors.green : null)),
        trailing: Text('#${city.zip}'),
      );
  var cities = <SearchFieldListItem<City>>[];
  SearchFieldListItem<City>? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Searchfield Demo')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 20,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              SearchField(
                suggestionsDecoration: SuggestionDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  itemPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                maxSuggestionBoxHeight: 300,
                onSuggestionTap: (SearchFieldListItem<City> item) {
                  setState(() {
                    selectedValue = item;
                  });
                },
                searchInputDecoration: SearchInputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffix: Icon(Icons.expand_more),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  hintText: 'Search for a city or zip code',
                ),
                onSearchTextChanged: (searchText) {
                  if (searchText.isEmpty) {
                    return cities
                        .map((e) => e.copyWith(
                            child: searchChild(e.item!,
                                isSelected: e == selectedValue)))
                        .toList();
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
                        child: searchChild(e.item!,
                            isSelected: e == selectedValue)))
                    .toList(),
                suggestionState: Suggestion.expand,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedValue = null;
                    });
                  },
                  child: Text('clear input'))
            ],
          ),
        ));
  }
}

class City {
  String name;
  String zip;
  City(this.name, this.zip);
}
