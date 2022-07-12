## [0.6.6] - Jun 12, 2022
- Add `autoCorrect` and `inputFormatter`  property
- Fix suggestionState for `hasOverlay:false`
## [0.6.5] - May 19, 2022
- Fixes runtime warning in flutter 3 [Issue #29](https://github.com/maheshmnj/searchfield/issues/29)
## [0.6.4] - Apr 21, 2022
- Fixes [Issue #25](https://github.com/maheshmnj/searchfield/issues/25)

## [0.6.3] - Feb 24, 2022
- Fixes [issue #20](https://github.com/maheshmnj/searchfield/issues/20)
- renamed property `onTap` to `onSuggestionTap`
- Adds `focusNode` and `onSubmit` parameters to SearchField
## [0.6.2] - Feb 24, 2022

- Add support for empty widget
- Add support for changing inputType

## [0.6.1] - Feb 21, 2022

- update version in readme
- pass generic object to `SearchfieldListItem`

## [0.6.0] - Feb 20, 2022 (Breaking Change)

- add custom widget for Suggestions using `SearchFieldListItem`
- removes `suggestionStyle` property
- minor fixes

## [0.5.6] - Sep 26, 2021

- adds `suggestionAction` to change focus on suggestion tap
- suggestions now always show on `SuggestionState.enabled`

## [0.5.5] - Sep 03, 2021

- adds `searchInputAction` property to focus to next input

## [0.5.4] - Sep 01, 2021

- renamed property to `SuggestionType` to `SuggestionState`
## [0.5.3] - Sep 01, 2021

- Adds `SuggestionType` enum to show/hide suggestion on focus 
- Update example

## [0.5.2] - Apr 17, 2021

- Add overlay example 
- Update readme
## [0.5.1] - Apr 13, 2021

- Updated docs

## [0.5.0] - Apr 13, 2021

- Adds support for overlays
- suggestions are lazily loaded on demand
- Adds animation to suggestions

## [0.3.2] - Jan 10, 2021

- Fix a [small bug](https://github.com/maheshmnj/searchfield/pull/4)

## [0.3.1] - Jan 10, 2021

- Adds support for validator to add custom validations

## [0.3.0] - Dec 24, 2020

- Support for controller to interact with the SearchField

## [0.2.1] - Dec 19, 2020

- update Docs

## [0.2.0] - Dec 18, 2020

- support to change the height of each suggestionItem.
- Can now define max number of suggestions visible in the viewport.
- Customizable Search Input Decoration like the built in textfield.
- decorate the Suggestions List with color or gradient.

## [0.0.1] - Dec 11, 2020

- Initial Release.
- supports sound null safety
- docs: minor documentation fixes and improvements
