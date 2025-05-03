### [1.3.0-dev.5] - May 03, 2025

- Fix [Issue: #218](https://github.com/maheshj01/searchfield/issues/218) FocusNode listener is not removed

### [1.3.0-dev.4] - May 03, 2025

- Fix [Issue: #222](https://github.com/maheshj01/searchfield/issues/222) Suggestion overlay dimensions not updated on resize
- Fix [Issue: #224](https://github.com/maheshj01/searchfield/issues/224) calling setState in listener caused setState exception
- Add VisualDensity Parameter to SearchInputDecoration

### [1.3.0-dev.3] - Apr 16, 2025

- Allow onSearchTextChanged to serve Future [Issue #215](https://github.com/maheshj01/searchfield/issues/215)
- Dynamic height is broken when the suggestion direction is up [Issue #216](https://github.com/maheshj01/searchfield/issues/216)

### [1.3.0-dev.2] - Apr 12, 2025

- allow onSearchTextChanged to serve Future [Issue #215](https://github.com/maheshj01/searchfield/issues/215)

### [1.3.0-dev.1] - Mar 19, 2025

- Deprecate `maintainHintHeight` in favour of `maintainHintSize` property of `SearchInputDecoration`
- Add `hint` property to `SearchInputDecoration`

### [1.2.6] - Mar 11, 2025

- Fix Range Error on First Suggestion Tap [Issue #210](https://github.com/maheshj01/searchfield/issues/210)

### [1.2.5] - Mar 11, 2025

- set overlay to null after unmount [PR #209](https://github.com/maheshj01/searchfield/pull/209/)

### [1.2.4] - January 28, 2025

- Fix: [Issue: #205](https://github.com/maheshj01/searchfield/issues/205) Index out of bound on SuggestionDirection.up

### [1.2.3] - January 26, 2025

- Fix: [Issue: #204](https://github.com/maheshj01/searchfield/issues/204) Interactive text editable menu was not being displayed.

### [1.2.2] - December 24, 2024

- Fix: [Issue: #197](https://github.com/maheshj01/searchfield/pull/197) Remove Null Checker
- Add ScrollController to control the scroll of suggestions [PR: #199](https://github.com/maheshj01/searchfield/pull/199)
- Fix: For SuggestionDirection.up arrow key would highlight in reverse.

#### [1.2.1] - December 12, 2024

- Fix: [Issue: #195](https://github.com/maheshj01/searchfield/issues/195) Add maintain Height property to SearchInputDecoration
  _Note: To use Searchfield 1.2.1 you would need flutter 3.27.0 or greater_

#### [1.2.0] - November 28, 2024

- [Breaking]: Handle selected Value on Client Side [Issue: #191](https://github.com/maheshj01/searchfield/issues/191)

**Before**

The package sets the selectedValue automatically inside the component, which leads to issues when navigating or selecting suggestions

```dart
SearchField(
    hint: 'Basic SearchField',
    dynamicHeight: true,
    maxSuggestionBoxHeight: 300,
    initialValue: SearchFieldListItem<String>('ABC'),
    suggestions: dynamicHeightSuggestion
        .map(SearchFieldListItem<String>.new)
        .toList(),
    suggestionState: Suggestion.expand,
),
```

**After**

Now the client should handle the selectedValue explicitly in the client code (consumer code) by using the onSuggestionTap callback. This approach simplifies the API and provides more accurate control over the internal state of the package.

```dart
var selectedValue = SearchFieldListItem<String>('ABC');

SearchField(
    hint: 'Basic SearchField',
    dynamicHeight: true,
    maxSuggestionBoxHeight: 300,
    // now the selectedValue is handled by the client
    onSuggestionTap: (SearchFieldListItem<String> item) {
        setState(() {
            selectedValue = item;
        });
    },
    selectedValue: selectedValue, // rename initialValue to selectedValue
    suggestions: dynamicHeightSuggestion
        .map(SearchFieldListItem<String>.new)
        .toList(),
    suggestionState: Suggestion.expand,
),
```

- Fixes: [Issue: #178](https://github.com/maheshj01/searchfield/issues/178), [Issue: #155](https://github.com/maheshj01/searchfield/issues/155)

- Fixes: [Issue: #151](https://github.com/maheshj01/searchfield/issues/151) Clarifies use of SuggestionAction and now defaults to `SuggestionState.unfocus` without having to use `FocusNode` on client side.

- Fixes: [Issue: #190](https://github.com/maheshj01/searchfield/issues/190) Keyboard navigation does not work after selecting a suggestion.

Huge thanks to all contributors and supporters.
Happy Thanksgiving! 🦃

#### [1.1.9] - November 25, 2024

- [regression] Fix: Keyboard navigation does not work [Issue: 183](https://github.com/maheshj01/searchfield/issues/182)

#### [1.1.8] - November 18, 2024

- Add `contextmenubuilder` property

#### [1.1.7] - October 22, 2024

- Refactor: Overlay condition too strict [Issue: 182](https://github.com/maheshj01/searchfield/issues/182)

#### [1.1.6] - September 25, 2024

- Fix: new properties were missing in CopyWith Constructor [Issue: 177 comment](https://github.com/maheshj01/searchfield/issues/177#issuecomment-2376401417)

#### [1.1.5] - September 25, 2024

- remove custom assertions for `SearchInputDecoration` properties

#### [1.1.4] - September 24, 2024

- Add new properties to `SearchInputDecoration` : `prefixIconConstraints`, `hintMaxLines`, `floatingLabelStyle`, `errorText`, `error`, `hintTextDirection`, `hintFadeDuration`, `helper`, `suffixIconConstraints`

#### [1.1.3] - September 20, 2024

- Fix SearchInputDecoration does not take any values [Issue #176](https://github.com/maheshj01/searchfield/issues/176)

#### [1.1.2] - September 20, 2024

- add a `SearchInputDecoration.copyWith` constructor [Issue #175](https://github.com/maheshj01/searchfield/issues/175)
- Fix [Issue #174](https://github.com/maheshj01/searchfield/issues/174) Exception: RangeError (index): Index out of range: index must not be negative: -1
- Fix [Issue #165](https://github.com/maheshj01/searchfield/issues/165) Trigger onSubmit when a option is not selected.

#### [1.1.1] - September 14, 2024

- Adds following properties to `SearchInputDecoration`: `suffix`, `label`, `suffixIconColor`, `prefix`, `prefixIconColor`, `prefixIcon` and `suffixIcon`;
- Fix [Issue #166](https://github.com/maheshj01/searchfield/issues/166): select suggestion with keyboard throws null error
- Fix [Issue: 168](https://github.com/maheshj01/searchfield/issues/168): update selected item when the suggestions change

#### [1.1.0] - September 10, 2024

- Adds new properties to style the search input using `SearchInputDecoration`: `cursorColor`, `cursorWidth`, `cursorHeight`, `keyboardAppearance`, `cursorRadius`, `cursorOpacityAnimates`
- [BREAKING] Input deocration properties are now part of `SearchInputDecoration` following are the properties moved to `SearchInputDecoration`:
  `textCapitalization`, `searchStyle`

**Before**

```dart
SearchField(
    textCapitalization: TextCapitalization.words,
    style: TextStyle(...)
    ...
)
```

**After**

```dart
SearchField(
    searchInputDecoration: SearchInputDecoration(
        textCapitalization: TextCapitalization.words,
        style: TextStyle(...)
        ...
    )
    ...
),
```

#### [1.0.9] - August 05, 2024

- renamed `dynamicHeightItem` to `dynamicHeight`
- Fix exception on scroll (debug) [Issue #162](https://github.com/maheshj01/searchfield/issues/162)

#### [1.0.8] - July 23, 2024

- Fixed Regression: Broke basic functionality to search [hotfix #161](https://github.com/maheshj01/searchfield/pull/161)

#### [1.0.7] - July 22, 2024

- Fix: Scroll to selected Sugggestion Issue Fix: [Issue #155](https://github.com/maheshj01/searchfield/issues/155)
- Fix: maxSuggestionInViewport did not show correct number of suggestions.
- Add Support for dynamic height of suggestionItem [Issue #67](https://github.com/maheshj01/searchfield/issues/67)

#### [1.0.6] - July 10, 2024

- Option was not being selected on search [Issue #136](https://github.com/maheshj01/searchfield/issues/136)

#### [1.0.5] - Jun 05, 2024

- Add Max Length and Option to disable counter for TextFormField [#Issue 145](https://github.com/maheshj01/searchfield/issues/145)

#### [1.0.4] - Jun 03, 2024

- Fix: error when dealing with multiple Overlays [Issue #143](https://github.com/maheshj01/searchfield/issues/143)

#### [1.0.3] - May 28, 2024

- Arrow keys now properly scroll to the focused suggestion
- Fix: Scrollbar tap hides the suggestions [Issue #137](https://github.com/maheshj01/searchfield/issues/137)
- Expose additional properties of `RawScrollbar` to `ScrollbarDecoration`

#### [1.0.2] - May 23, 2024

- Fix: onSuggestionTap returns empty searchKey usng keyboard [Issue #138](https://github.com/maheshj01/searchfield/issues/138)

#### [1.0.1] - March 22, 2024

- emptyWidget was incorrectly displayed [Fix Issue #132](https://github.com/maheshj01/searchfield/issues/132)
- adds animationDuration to customize the list animation duration
- Scroll to bottom and top of list using alt+down and alt+up keys

#### [1.0.0] - March 20, 2024

- ListView is always kept in state to maintain scrolloffset [Issue #122](https://github.com/maheshj01/searchfield/issues/122)
- Shift+Tab should respect sequence of SearchField in a form with SuggestionState.hidden [Issue #125](https://github.com/maheshj01/searchfield/issues/125)

#### [0.9.9] - March 13, 2024

- Incorrect search result passed to onSubmit [Issue #126](https://github.com/maheshj01/searchfield/issues/126)

#### [0.9.8] - March 13, 2024

- Add `elevation` and `shadowColor` property to SuggestionDecoration class fixes [Issue #110](https://github.com/maheshj01/searchfield/issues/110)
- Customize width of suggestions using `SuggestionDecoration.width` property
- Initial Value should be selected by default [Issue #127](https://github.com/maheshj01/searchfield/issues/127)
- Add `textAlign` property to SearchField [Completes PR #126](https://github.com/maheshj01/searchfield/pull/63)(

#### [0.9.7] - March 09, 2024

- Expose `onScroll` event listener [Issue #118](https://github.com/maheshj01/searchfield/issues/118)
- Add `showEmpty` parameter to hide/show emptyWidget

#### [0.9.6] - March 07, 2024

- Add `hoverColor` and `selectionColor` property to SuggestionDecoration. [Issue #112](https://github.com/maheshj01/searchfield/issues/112)

#### [0.9.5] - March 06, 2024

- Add keyboard support for suggestions [Issue #7](https://github.com/maheshj01/searchfield/issues/7)
- [BREAKING] Remove deprecated property `comparator`, use `onSearchTextChanged` instead

#### [0.9.2] - Feb 07, 2024

- Fix SuggestionDirection broken

#### [0.9.1] - Feb 07, 2024

- Update Suggestion dimensions on Window resize [Issue #84](https://github.com/maheshj01/searchfield/issues/84)
- Adds a enum `SuggestionDirection.flexible` to position the suggestions based on the available space. [Issue #56](https://github.com/maheshj01/searchfield/issues/56)

#### [0.9.0] - Dec 07, 2023

- Expose onTap callback to get the tap event on the searchfield
- Add autoValidateMode property to SearchField

#### [0.8.9] - Nov 23, 2023

- Clip Suggsestions within Material, Fixes [issue #44](https://github.com/maheshj01/searchfield/issues/44)

#### [0.8.8] - Nov 21, 2023

- add `onTapOutside` callback to SearchField [Issue #94](https://github.com/maheshj01/searchfield/issues/94)
- add `autofocus` property to SearchField [Issue #105](https://github.com/maheshj01/searchfield/issues/105)

#### [0.8.7] - Oct 27, 2023

- Minor Fix in suggestions total height calculation. [#PR 85](https://github.com/maheshj01/searchfield/pull/85)

#### [0.8.6] - Oct 13, 2023

- Remove default scrollbar from listview

#### [0.8.5] - Oct 12, 2023

- Adds `scrollbarDecoration` property to customize the scrollbar [Issue #99](https://github.com/maheshj01/searchfield/issues/99)
- [BREAKING] Removes `scrollbarAlwaysVisible` property, instead use `scrollbarDecoration.thumbVisibility` to customize the scrollbar.

#### [0.8.4] - Aug 07, 2023

- Addresses [Issue #92](https://github.com/maheshj01/searchfield/issues/92): Add `onSaved` callback to SearchField
- Addresses [Issue #90](https://github.com/maheshj01/searchfield/issues/90) Update Docs to clarify Alignment of suggestions

#### [0.8.3] - May 19, 2023

- Fix Regressed Issue: https://github.com/maheshj01/searchfield/issues/83

#### [0.8.2] - May 16, 2023

- Fix static analysis issue

#### [0.8.1] - May 15, 2023

- Fixed: Overlay was not updated when the dependency changed.
- Fix: [Issue #81](https://github.com/maheshj01/searchfield/issues/81) adds padding property to `SuggestionDecoration`.

#### [0.8.0] - May 05, 2023

- Fix: [Issue #78](https://github.com/maheshj01/searchfield/issues/78) Adds `onSearchTextChanged` callback to get the search text on every change.
- Deprecate `comparator` property, use `onSearchTextChanged` instead.

#### [0.7.8] - May 02, 2023

- Fix [Issue #77](https://github.com/maheshj01/searchfield/issues/77) Add TextCapitalization property to SearchField.

#### [0.7.7] - Apr 27, 2023

- Fix [Issue: 76](https://github.com/maheshj01/searchfield/issues/76) Overlay not getting closed on Route pop.

#### [0.7.6] - Apr 16, 2023

- Add 'readOnly' property to disable editing
- [BREAKING] [Issue #58](https://github.com/maheshj01/searchfield/issues/58): Removes `hasOverlay` property, now suggestions are always shown as an overlay
- Fixes: SearchField Cannot be wrapped with Center [Issue 57](https://github.com/maheshj01/searchfield/issues/57)

#### [0.7.5] - Jan 27, 2023

- Hot Fix: https://github.com/maheshj01/searchfield/issues/70 OnSuggestionTap broke in flutter 3.7 for non mobile platforms see: https://github.com/flutter/flutter/issues/119390

- [BREAKING] Adds Scrollbar for suggestions (Requires flutter stable 3.7 or greater.)

#### [0.7.4] - Jan 16, 2023

- Add `comparator` property to filter out the suggestions with a custom logic.
- Fixes [#69](https://github.com/maheshj01/searchfield/issues/69)

#### [0.7.3] - Oct 25, 2022

- Add `enabled` property see [#65](https://github.com/maheshj01/searchfield/pull/65)

#### [0.7.2] - Oct 25, 2022

- Add `suggestionDirection` property to position the suggestions.

#### [0.7.1] - Oct 6, 2022

- Fixes [#43](https://github.com/maheshj01/searchfield/issues/43)

#### [0.7.0] - Aug 30, 2022

- Add `offset` property to position the suggestions.

#### [0.6.9] - Aug 12, 2022

- Add `suggestionStyle` to style default suggestions.

#### [0.6.8] - Aug 8, 2022

- Fix widget not mounted error on Deactivate

#### [0.6.7] - Jul 24, 2022

- Fixes [issue #39](https://github.com/maheshj01/searchfield/issues/39)

#### [0.6.6] - Jun 12, 2022

- Add `autoCorrect` and `inputFormatter` property
- Fix suggestionState for `hasOverlay:false`

#### [0.6.5] - May 19, 2022

- Fixes runtime warning in flutter 3 [Issue #29](https://github.com/maheshj01/searchfield/issues/29)

#### [0.6.4] - Apr 21, 2022

- Fixes [Issue #25](https://github.com/maheshj01/searchfield/issues/25)

#### [0.6.3] - Feb 24, 2022

- Fixes [issue #20](https://github.com/maheshj01/searchfield/issues/20)
- renamed property `onTap` to `onSuggestionTap`
- Adds `focusNode` and `onSubmit` parameters to SearchField

#### [0.6.2] - Feb 24, 2022

- Add support for empty widget
- Add support for changing inputType

#### [0.6.1] - Feb 21, 2022

- update version in readme
- pass generic object to `SearchfieldListItem`

#### [0.6.0] - Feb 20, 2022 (Breaking Change)

- add custom widget for Suggestions using `SearchFieldListItem`
- removes `suggestionStyle` property
- minor fixes

#### [0.5.6] - Sep 26, 2021

- adds `suggestionAction` to change focus on suggestion tap
- suggestions now always show on `SuggestionState.enabled`

#### [0.5.5] - Sep 03, 2021

- adds `searchInputAction` property to focus to next input

#### [0.5.4] - Sep 01, 2021

- renamed property to `SuggestionType` to `SuggestionState`

#### [0.5.3] - Sep 01, 2021

- Adds `SuggestionType` enum to show/hide suggestion on focus
- Update example

#### [0.5.2] - Apr 17, 2021

- Add overlay example
- Update readme

#### [0.5.1] - Apr 13, 2021

- Updated docs

#### [0.5.0] - Apr 13, 2021

- Adds support for overlays
- suggestions are lazily loaded on demand
- Adds animation to suggestions

#### [0.3.2] - Jan 10, 2021

- Fix a [small bug](https://github.com/maheshj01/searchfield/pull/4)

#### [0.3.1] - Jan 10, 2021

- Adds support for validator to add custom validations

#### [0.3.0] - Dec 24, 2020

- Support for controller to interact with the SearchField

#### [0.2.1] - Dec 19, 2020

- update Docs

#### [0.2.0] - Dec 18, 2020

- support to change the height of each suggestionItem.
- Can now define max number of suggestions visible in the viewport.
- Customizable Search Input Decoration like the built in textfield.
- decorate the Suggestions List with color or gradient.

#### [0.0.1] - Dec 11, 2020

- Initial Release.
- supports sound null safety
- docs: minor documentation fixes and improvements
