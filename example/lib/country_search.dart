import 'package:example/country_model.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CountrySearch extends StatefulWidget {
  CountrySearch({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CountrySearchState createState() => _CountrySearchState();
}

class _CountrySearchState extends State<CountrySearch> {
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

  final _formKey = GlobalKey<FormState>();

  List<Country> countries = [];
  Country _selectedCountry = Country.init();

  bool containsCountry(String text) {
    final Country? result = countries.firstWhere(
        (Country country) => country.name.toLowerCase() == text.toLowerCase(),
        orElse: () => Country.init());

    if (result!.name.isEmpty) {
      return false;
    }
    return true;
  }

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
                  child: Form(
                    key: _formKey,
                    child: SearchField(
                      suggestions: countries
                          .map((country) =>
                              SearchFieldListItem(country.name, item: country))
                          .toList(),
                      suggestionState: Suggestion.hidden,
                      controller: _searchController,
                      hint: 'Search by country name',
                      maxSuggestionsInViewPort: 4,
                      itemHeight: 45,
                      searchInputDecoration: SearchInputDecoration(
                        textCapitalization: TextCapitalization.words,
                      ),
                      validator: (x) {
                        if (x!.isEmpty || !containsCountry(x)) {
                          return 'Please Enter a valid Country';
                        }
                        return null;
                      },
                      inputType: TextInputType.text,
                      onSuggestionTap: (SearchFieldListItem<Country> x) {
                        setState(() {
                          _selectedCountry = x.item!;
                        });
                        _formKey.currentState!.validate();
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: Center(
                        child: _selectedCountry.name.isEmpty
                            ? Text('select Country')
                            : CountryDetail(
                                country: _selectedCountry,
                              ))),
                ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.validate();
                    },
                    child: Text('validate')),
                SizedBox(
                  height: 100,
                )
              ],
            )));
  }
}

class CountryDetail extends StatefulWidget {
  final Country? country;

  CountryDetail({Key? key, required this.country}) : super(key: key);
  @override
  _CountryDetailState createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  Widget dataWidget(String key, int value) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$key:'),
          SizedBox(
            width: 16,
          ),
          Flexible(
            child: Text(
              '$value',
              style: TextStyle(fontSize: 30),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          child: Text(
            widget.country!.name,
            style: TextStyle(fontSize: 40),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        dataWidget('Population:', widget.country!.population),
        dataWidget('Density', widget.country!.density),
        dataWidget('Land Area (in Km\'s)', widget.country!.landArea)
      ],
    );
  }
}
