import 'package:example/user_data.dart';
import 'package:example/user_model.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class Pagination extends StatefulWidget {
  const Pagination({Key? key}) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  final focus = FocusNode();

  Future<List<UserModel>> getPaginatedSuggestions({int pageLength = 5}) async {
    await Future.delayed(const Duration(seconds: 2));
    int total = suggestions.length;

    return List.generate(pageLength, (index) {
      total++;
      return UserModel.fromJson(users_data[total % users_data.length]);
    });
  }

  static const surfaceGreen = Color.fromARGB(255, 237, 255, 227);
  static const surfaceBlue = Color(0xffd3e8fb);
  static const skyBlue = Color(0xfff3ddec);

  var suggestions = <UserModel>[];

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
      if (mounted) {
        setState(() {
          suggestions.addAll(result);
        });
      }
    });
  }

  var selectedValue = null;
  @override
  Widget build(BuildContext context) {
    Widget searchChild(UserModel user) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
          child: Text(user.name,
              style: TextStyle(fontSize: 16, color: Colors.black)),
        );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SearchField<UserModel>(
          onSearchTextChanged: (query) {
            final filter = suggestions
                .where((user) =>
                    user.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return filter
                .map((e) => SearchFieldListItem<UserModel>(e.name,
                    child: searchChild(e)))
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
          selectedValue: selectedValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.length < 4) {
              return 'error';
            }
            return null;
          },
          emptyWidget: Container(
              decoration: suggestionDecoration,
              height: 200, // item*maxItems
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ))),
          key: const Key('searchfield'),
          itemHeight: 50,
          maxSuggestionsInViewPort: 4,
          scrollbarDecoration: ScrollbarDecoration(),
          onTapOutside: (x) {},
          suggestionStyle: const TextStyle(fontSize: 20, color: Colors.black),
          searchInputDecoration: SearchInputDecoration(
            hintText: 'Load Paginated suggestions from network',
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
          ),
          suggestionsDecoration: suggestionDecoration,
          suggestions: suggestions
              .map((e) =>
                  SearchFieldListItem<UserModel>(e.name, child: searchChild(e)))
              .toList(),
          focusNode: focus,
          suggestionState: Suggestion.expand,
          onSuggestionTap: (SearchFieldListItem<UserModel> x) {
            setState(() {
              selectedValue = x;
            });
          },
        ),
      ],
    );
  }
}
