# [searchfield: ^1.2.7](https://pub.dev/packages/searchfield)

<a href="https://github.com/maheshj01/searchfield" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
<a href="https://pub.dev/packages/searchfield"><img src="https://img.shields.io/pub/v/searchfield.svg" alt="Pub"></a>
<a href="https://pub.dev/packages/searchfield/versions/1.3.0-dev.3" target="_blank">
<img src="https://img.shields.io/badge/pub-Prerelease--1.3.0--dev.3-blue" alt="Prerelease" />
</a>
[![codecov](https://codecov.io/gh/maheshj01/searchfield/graph/badge.svg?token=QHK8TGC23V)](https://codecov.io/gh/maheshj01/searchfield)
[![Build](https://github.com/maheshj01/searchfield/actions/workflows/workflow.yml/badge.svg)](https://github.com/maheshj01/searchfield/actions/workflows/workflow.yml)
<a href="https://opensource.org/licenses/MIT" rel="noopener" target="_blank"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
<a href="https://github.com/sponsors/maheshj01/" target="_blank">
<img src="https://img.shields.io/badge/Sponsor-Searchfield-orange" alt="Sponsor @maheshj01" />
</a>

⭐️Show some ❤️ and star the repo.⭐

![Frame 1 (1)](https://github.com/maheshj01/searchfield/assets/31410839/67810336-fc28-4c5d-90e0-117e202fe673)

A highly customizable, simple and easy to use AutoComplete widget for your Flutter app. This widget allows you to

- search 🔍 and select from a list of suggestions
- validate the input with custom validation logic.
- Dynamic height of each suggestion item.
- show suggestions of custom type (not just String)
- lazy load the suggestions from Network with custom Loading widget
- show dynamic suggestions above or below the input field
- define max number of items visible in the viewport 📱
- filter out the suggestions with a custom logic
- visually customize the input and the suggestions
- navigate through the suggestions using keyboard for Desktop 🖥 ️
- Listen to scroll events of suggestions

## Getting Started

### Installation

- Add the dependency

```yaml
flutter pub add searchfield
```

- Import the package

```
import 'package:searchfield/searchfield.dart';
```

Use the Widget

#### Example1

```dart

var selectedValue = null;
SearchField<Country>(
  suggestions: countries
    .map(
    (e) => SearchFieldListItem<Country>(
      e.name,
      item: e,
      // Use child to show Custom Widgets in the suggestions
      // defaults to Text widget
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(e.flag),
            ),
            SizedBox(
              width: 10,
            ),
            Text(e.name),
          ],
        ),
      ),
      selectedValue: selectedValue,
      onSuggestionTap: (SearchFieldListItem<Country> x) {
        setState(() {
          selectedValue = x.item;
        });
      },
  ),
  ).toList(),
),
```

 <img src="https://github.com/maheshj01/searchfield/assets/31410839/08bd594c-1593-4865-81a8-5d347077b98a" width="210"/>

#### [Example 2 (Network demo)](https://github.com/maheshj01/searchfield/blob/master/example/lib/network_sample.dart)

Ability to load suggestions from the network with a custom loading widget

```dart
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
    onTap: () async {
    final result = await getSuggestions();
    setState(() {
        suggestions = result;
    });
    },
    /// widget to show when suggestions are empty
    emptyWidget: Container(
        decoration: suggestionDecoration,
        height: 200,
        child: const Center(
            child: CircularProgressIndicator(
        color: Colors.white,
        ))),
    hint: 'Load suggestions from network',
    itemHeight: 50,
    scrollbarDecoration: ScrollbarDecoration(),
    suggestionStyle: const TextStyle(fontSize: 24, color: Colors.white),
    searchInputDecoration: SearchInputDecoration(...),
    border: OutlineInputBorder(...)
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
    )),
    suggestionsDecoration: suggestionDecoration,
    suggestions: suggestions
        .map((e) => SearchFieldListItem<String>(e, child: searchChild(e)))
        .toList(),
    focusNode: focus,
    suggestionState: Suggestion.expand,
    onSuggestionTap: (SearchFieldListItem<String> x) {

    },
),
```

 <img src="https://github.com/maheshj01/searchfield/assets/31410839/f4f17c24-63c4-4ec3-9b3b-d27f5ee4575d" width="210"/>

#### Example 3 Custom Widgets

[complete code here](example/lib/custom.dart)

![demo-ezgif com-video-to-gif-converter (1)](https://github.com/maheshj01/searchfield/assets/31410839/227b6288-15a2-489f-9d97-0ecfb04fff41)

#### Example 4 Load suggestions from network with Pagination

Note that this also maintains the Scroll position when new items are added to list
see: [complete code here](example/lib/pagination.dart)

![output_video-ezgif com-video-to-gif-converter](https://github.com/flutter/flutter/assets/31410839/3b153e7b-f3e4-4eb7-86ca-8eebd94abf28)

#### Example 5 (Validation)

```dart
Form(
  key: _formKey,
  child: SearchField(
    suggestions: _statesOfIndia
        .map((e) => SearchFieldListItem(e))
        .toList(),
    suggestionState: Suggestion.expand,
    textInputAction: TextInputAction.next,
    hint: 'SearchField Example 2',
    searchStyle: TextStyle(
      fontSize: 18,
      color: Colors.black.withValues(alpha: 0.8),
    ),
    validator: (x) {
      if (!_statesOfIndia.contains(x) || x!.isEmpty) {
        return 'Please Enter a valid State';
      }
      return null;
    },
    selectedValue: selectedValue,
      onSuggestionTap: (SearchFieldListItem<Country> x) {
        setState(() {
          selectedValue = x.item;
        });
      },
    searchInputDecoration: SearchInputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withValues(alpha: 0.8),
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    ),
    maxSuggestionsInViewPort: 6,
    itemHeight: 50,
    onTap: (x) {},
  ))
```

```dart
 SearchField(
    onSearchTextChanged: (query) {
      final filter = suggestions
          .where((element) =>
              element.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return filter
          .map((e) => SearchFieldListItem<String>(e,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(e,
                    style: TextStyle(fontSize: 24, color: Colors.red)),
              )))
          .toList();
    },
    selectedValue: selectedValue,
      onSuggestionTap: (SearchFieldListItem<Country> x) {
        setState(() {
          selectedValue = x.item;
        });
      },
    key: const Key('searchfield'),
    hint: 'Search by country name',
    itemHeight: 50,
    searchInputDecoration:
        SearchInputDecoration(hintStyle: TextStyle(color: Colors.red)),
    suggestionsDecoration: SuggestionDecoration(
        padding: const EdgeInsets.all(4),
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    suggestions: suggestions
        .map((e) => SearchFieldListItem<String>(e,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(e,
                  style: TextStyle(fontSize: 24, color: Colors.red)),
            )))
        .toList(),
    focusNode: focus,
    suggestionState: Suggestion.expand,
    selectedValue: selectedValue,
    onSuggestionTap: (SearchFieldListItem<String> x) {
      setState(() {
          selectedValue = x.item;
        });
    },
  ),
```

<img src="https://user-images.githubusercontent.com/31410839/104081674-2ec10980-5256-11eb-9712-6b18e3e67f4a.gif" width="360"/>

## Customize the suggestions the way you want

Suggestions can be passed as a widget using the child property of `SearchFieldListItem`

```dart
SearchField(
  suggestions: _statesOfIndia
     .map((e) => SearchFieldListItem(e,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
             padding: const EdgeInsets.symmetric(horizontal:16.0),
               child: Text(e,
                 style: TextStyle(color: Colors.red),
               ),
             ),
          ))).toList(),
    ...
    ...
)
```

### Support for Keyboard Navigation

With v0.9.5 Searchfield now adds support for Keyboard navigation, you can now navigate through the suggestions using the keyboard.

  <img src = "https://github.com/maheshj01/searchfield/assets/31410839/17ed4c43-f0c3-4ba8-8fae-beedf42ae781" width="300">

Shortcuts:

- Up/Down Arrow keys are circular, i.e. if you reach the last item and press down, it will take you to the first item. Similarly, if you reach the first item and press up, it will take you to the last item.
- `ctr/option + down` to scroll to last item in the list
- `ctr/option + up` to scroll to first item in the list

### Support for Dynamic positioning of suggestions

The position of suggestions is dynamic based on the space available for the suggestions to expand within the viewport.

<img src = "https://github.com/maheshj01/searchfield/assets/31410839/19501d66-44d5-40b8-a4cf-b47920c791a3" width="400">

## Properties

- `animationDuration`: Duration for the animation of the suggestions list.
- `autoCorrect`: Defines whether to enable autoCorrect defaults to `true`
- `autofocus`: Defines whether to enable autofocus defaults to `false`
- `autoValidateMode`: Used to enable/disable this form field auto validation and update its error text.defaults to `AutoValidateMode.disabled`
- `contextmenubuilder`: Creates a [FormField] that contains a [TextField]. When a [controller] is specified, [initialValue] must be null (the default). If [controller] is null, then a [TextEditingController] will be constructed automatically and its text will be initialized to [initialValue] or the empty string.
  For documentation about the various parameters, see the [TextField] class and [TextField.new], the constructor.
- `controller`: TextEditing Controller to interact with the searchfield.
- `comparator` property to filter out the suggestions with a custom logic (Comparator is deprecated Use `onSearchTextChanged` instead).
- `dynamicHeight`: Set to true to opt-in to dynamic height, defaults to false (`itemHeight : 51`)
- `emptyWidget`: Custom Widget to show when search returns empty Results or when `showEmpty` is true. (defaults to `SizedBox.shrink`)
- `enabled`: Defines whether to enable the searchfield defaults to `true`
- `focusNode` : FocusNode to interact with the searchfield.
- `hint` : hint for the search Input.
- `readOnly` : Defines whether to enable the searchfield defaults to `false`
- `selectedValue` : The initial value to be set in searchfield when its rendered, if not specified it will be empty.
- `inputType`: Keyboard Type for SearchField
- `inputFormatters`: Input Formatter for SearchField
- `itemHeight` : height of each suggestion Item, (defaults to 51.0).
- `marginColor` : Color for the margin between the suggestions.
- `maxSuggestionBoxHeight`: Specifies a maximum height for the suggestion box when `dynamicHeight` is set to `true`.
- `maxSuggestionsInViewPort` : The max number of suggestions that can be shown in a viewport.
- `offset` : suggestion List offset from the searchfield, The top left corner of the searchfield is the origin (0,0).
- `onOutSideTap` : callback when the user taps outside the searchfield.
- `onSaved` : An optional method to call with the final value when the form is saved via FormState.save.
- `onScroll` : callback when the suggestion list is scrolled. It returns the current scroll position in pixels and the max scroll position.
- `onSearchTextChanged`: callback when the searchfield text changes, it returns the current text in the searchfield.
- `onSuggestionTap` : callback when a sugestion is tapped, it returns the tapped value which can be used to set the selectedValue.
- `onSubmit` : callback when the searchfield is submitted, it returns the current text in the searchfield.
- `onTap`: callback when the searchfield is tapped or brought into focus.
- `scrollbarDecoration`: decoration for the scrollbar.
- `scrollController`: ScrollController to interact with the suggestions list.
- `showEmpty`: Boolean to show/hide the emptyWidget.
- `suggestions`**(required)** : List of SearchFieldListItem to search from.
  each `SearchFieldListItem` in the list requires a unique searchKey, which is used to search the list and an optional Widget, Custom Object to display custom widget and to associate a object with the suggestion list.
- `suggestionState`: enum to hide/show the suggestion on focusing the searchfield defaults to `SuggestionState.expand`.
- `searchStyle` : textStyle for the search Input.
- `searchInputDecoration` : decoration for the search Input (e.g to update HintStyle) similar to built in textfield widget.
- `suggestionsDecoration` : decoration for suggestions List with ability to add box shadow background color and much more.
- `suggestionDirection` : direction of the suggestions list, defaults to `SuggestionDirection.down`.
- `suggestionItemDecoration` : decoration for suggestionItem with ability to add color and gradient in the background.
- `SuggestionAction` : enum to control focus of the searchfield on suggestion tap.
- `suggestionStyle`:Specifies `TextStyle` for suggestions when no child is provided.
- `textInputAction` : An action the user has requested the text input control to perform throgh the submit button on keyboard.
- `textCapitalization` : Configures how the platform keyboard will select an uppercase or lowercase keyboard on IOS and Android.
- `textAlign`: specifies the alignment of the text in the searchfield. Defaults to `TextAlign.start`.

### You can find all the [code samples here](https://github.com/maheshj01/searchfield/tree/master/example)

### Contributing

You are welcome to contribute to this package, to contribute please read the [contributing guidelines](CONTRIBUTING.md).

### Contributors

Thanks to all the contributors who have helped in improving this package.

### Support

If you like this package, consider supporting it by Sponsorship or Donation through [github sponsors here](https://github.com/sponsors/maheshj01/)
