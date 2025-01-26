// import 'package:example/pagination.dart';
import 'package:example/country_search.dart';
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
      home: CountrySearch(title: 'SearchField Demo'),
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
    suggestions = [
      'United States',
      'Germany',
      'Canada',
      'United Kingdom',
      'France',
      'Italy',
      'Spain',
      'Australia',
      'India',
      'China',
      'Japan',
      'Brazil',
      'South Africa',
      'Mexico',
      'Argentina',
      'Russia',
      'Indonesia',
      'Turkey',
      'Saudi Arabia',
      'Nigeria',
      'Egypt',
    ];
    super.initState();
  }

  var suggestions = <String>[];
  var selectedValue = null;
  @override
  Widget build(BuildContext context) {
    Widget searchChild(x, {bool isSelected = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(x,
              style: TextStyle(
                  fontSize: 18,
                  color: isSelected ? Colors.green : Colors.black)),
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
                hint: 'Basic SearchField',
                dynamicHeight: true,
                maxSuggestionBoxHeight: 300,
                onSuggestionTap: (SearchFieldListItem<String> item) {
                  setState(() {
                    selectedValue = item;
                  });
                  print(item.item);
                },
                selectedValue: selectedValue,
                suggestions: suggestions
                    .map(
                      (x) => SearchFieldListItem<String>(
                        x,
                        item: x,
                        child: searchChild(x),
                      ),
                    )
                    .toList(),
                suggestionState: Suggestion.expand,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Basic TextField',
                ),
              ),
              OverlayInput(),
            ],
          ),
        ));
  }
}

class OverlayInput extends StatefulWidget {
  OverlayInput({Key? key}) : super(key: key);
  @override
  State<OverlayInput> createState() => _OverlayInputState();
}

class _OverlayInputState extends State<OverlayInput> {
  final ScrollController _scrollController = ScrollController();

  Widget _list() {
    return Container(
      height: 5 * 40,
      child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                    title: Text('item $index'),
                  ))),
    );
  }

  final LayerLink _layerLink = LayerLink();

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              width: size.width,
              child: CompositedTransformFollower(
                  offset: Offset(0, 50),
                  link: _layerLink,
                  child: Material(color: Colors.red, child: _list())),
            ));
  }

  late OverlayEntry _overlayEntry;
  final _searchFocusNode = FocusNode();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = _createOverlay();
    });

    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        _overlayEntry.remove();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        focusNode: _searchFocusNode,
        onTapOutside: (x) {
          _overlayEntry.remove();
        },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        onTap: () {
          Overlay.of(context).insert(_overlayEntry);
        },
        onChanged: (query) {},
      ),
    );
  }
}
