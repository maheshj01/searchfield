#  [SearchField: ^0.3.0](https://pub.dev/packages/searchfield) 



A highly customizable simple and easy to use flutter Widget to add a searchfield to your Flutter Application.This Widget allows you to search and select from list of suggestions.

Think of this widget like a dropdownButton field with an ability 
- to Search 🔍.
- to define height of each Suggestion Item
- to define max number of items visible in the viewport 📱
- to completely customize the input searchfield like a normal textfield
- to customize the suggestions with colors and gradients

list of all the properties mentioned below

## Supported Platforms
- Android
- Ios
- Web
## Getting Started

### Installation

- Add the dependency
```
dependencies:
  searchfield: ^0.2.1
```
- Import the package
```
import 'package:searchfield/searchfield.dart';
```
Use the Widget 
#### Example1

```
 SearchField(
    suggestions: [
    'United States',
    'America',
    'Washington',
    'India',
    'Paris',
    'Jakarta',
    'Australia',
    'Lorem Ipsum'
    ],
),
```
 <img src="https://user-images.githubusercontent.com/31410839/101930194-d74f5f80-3bfd-11eb-8f08-ca8f593cdb01.gif" width="210" />


#### Example2
```
SearchField(
   suggestions: _suggestions,
   hint: 'SearchField Sample 2',
   searchStyle: 
          TextStyle(
             fontSize: 18, color: Colors.black.withOpacity(0.8)),
   searchInputDecoration: 
          InputDecoration(
             focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(color: Colors.black.withOpacity(0.8)),
          ),
             border: OutlineInputBorder(
             borderSide: BorderSide(color: Colors.red),
         )),
   maxSuggestionsInViewPort: 6,
   itemHeight: 50,
   onTap: (x) {print(x);},
   )
```
<p float="left;padding=10px">
  <img src ="https://user-images.githubusercontent.com/31410839/102691041-a55a8080-422f-11eb-939f-6d2d43715e23.gif" width="210"/>
  <img src = "https://user-images.githubusercontent.com/31410839/102691101-fff3dc80-422f-11eb-9860-cf4fcf2b1351.gif" width="210"/>
  <img src = "https://user-images.githubusercontent.com/31410839/102691410-582bde00-4232-11eb-85fb-8ce8da8d8764.gif" width="210"/>
</p>

### Properties
- ```controller```: TextEditing Controller to interact with the searchfield.
- ```suggestions``` : list of Strings to search from.**(Mandatory)**
- ```initialValue``` :  The initial value to be set in searchfield when its rendered, if not specified it will be empty.
- ```onTap``` : callback when a sugestion is tapped it also returns the tapped value.
- ```hint``` :   hint for the search Input.
- ```searchStyle``` :  textStyle for the search Input.
- ```suggestionStyle``` :  textStyle for the SuggestionItem.
- ```searchInputDecoration``` :  decoration for the search Input similar to built in textfield widget.
- ```suggestionsDecoration``` :  decoration for suggestions List with ability to add box shadow background color and much more.
- ```suggestionItemDecoration`` : decoration for suggestionItem with ability to add color and gradient in the background.
- ```itemHeight``` :  height of each suggestion Item, (defaults to 35.0).
- ```marginColor``` : Color for the margin between the suggestions.
- ```maxSuggestionsInViewPort``` : The max number of suggestions that can be shown in a viewport.

### Contributing
You are welcome to contribute to this package,contribution doesnt necessarily mean sending a pull request it could be
 - pointing out bugs/issues 
 - requesting a new feature
 - improving the documentation

 If you feel generous and confident send a PR but make sure theres an open issue if not feel free to create one before you send a PR. This helps Identify the problem and helps everyone to stay aligned with the issue :) 
