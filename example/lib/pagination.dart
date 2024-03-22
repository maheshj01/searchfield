import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class Pagination extends StatefulWidget {
  const Pagination({Key? key}) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  final focus = FocusNode();

  Future<List<String>> getPaginatedSuggestions({int pageLength = 5}) async {
    await Future.delayed(const Duration(seconds: 2));
    int total = suggestions.length;
    return List.generate(pageLength, (index) {
      total++;
      return 'Item $total';
    });
  }

  static const surfaceGreen = Color.fromARGB(255, 237, 255, 227);
  static const surfaceBlue = Color(0xffd3e8fb);
  static const skyBlue = Color(0xfff3ddec);

  var suggestions = <String>[];

  static const gradient = LinearGradient(
    colors: [surfaceBlue, surfaceGreen, skyBlue],
    stops: [0.25, 0.35, 0.9],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );
  final suggestionDecoration = SuggestionDecoration(
    border: Border.all(color: Colors.grey),
    gradient: gradient,
    borderRadius: BorderRadius.circular(24),
  );

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final result = await getPaginatedSuggestions();
      setState(() {
        suggestions.addAll(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget searchChild(x) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
          child: Text(x, style: TextStyle(fontSize: 20, color: Colors.black)),
        );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SearchField(
          onSearchTextChanged: (query) {
            final filter = suggestions
                .where((element) =>
                    element.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return filter
                .map((e) =>
                    SearchFieldListItem<String>(e, child: searchChild(e)))
                .toList();
          },
          animationDuration: Duration.zero,
          showEmpty: isLoading,
          onScroll: (offset, maxOffset) async {
            if (offset < maxOffset) return;
            setState(() {
              isLoading = true;
            });
            final result = await getPaginatedSuggestions();
            setState(() {
              suggestions.addAll(result);
              isLoading = false;
            });
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.length < 4) {
              return 'error';
            }
            return null;
          },
          emptyWidget: Container(
              decoration: suggestionDecoration,
              height: 250, // item*maxItems
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ))),
          key: const Key('searchfield'),
          hint: 'Load Paginated suggestions from network',
          itemHeight: 50,
          scrollbarDecoration: ScrollbarDecoration(),
          onTapOutside: (x) {},
          suggestionStyle: const TextStyle(fontSize: 20, color: Colors.black),
          searchInputDecoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
          ),
          suggestionsDecoration: suggestionDecoration,
          suggestions: suggestions
              .map((e) => SearchFieldListItem<String>(e, child: searchChild(e)))
              .toList(),
          focusNode: focus,
          suggestionState: Suggestion.expand,
          onSuggestionTap: (SearchFieldListItem<String> x) {
            focus.unfocus();
          },
        ),
      ],
    );
  }
}
