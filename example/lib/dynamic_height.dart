// A Dynamic Height Example Suggestions

import 'dart:math';

import 'package:example/user_model.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

import 'user_data.dart';

class DynamicHeightExample extends StatefulWidget {
  const DynamicHeightExample({super.key});

  @override
  State<DynamicHeightExample> createState() => _DynamicHeightExampleState();
}

class _DynamicHeightExampleState extends State<DynamicHeightExample> {
  final List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    users_data.forEach((element) {
      users.add(UserModel.fromJson({
        ...element,
        'name': (element['name'] as String) +
            (Random().nextBool()
                ? '\n' +
                    ((element['name'] as String) +
                        '\n' +
                        (element['name'] as String))
                : '')
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchField<UserModel>(
        dynamicHeight: true,
        // maxSuggestionBoxHeight: MediaQuery.of(context).size.height * 0.8,
        suggestionsDecoration: SuggestionDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8),
          ),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
        // selectedValue: SearchFieldListItem<UserModel>(
        //   users[2].name,
        //   child: Container(
        //     color: Colors.red,
        //     width: 100,
        //     alignment: Alignment.center,
        //     child: Text(
        //       users[2].name,
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        // ),
        suggestionItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
            border: Border.all(
                color: Colors.transparent,
                style: BorderStyle.solid,
                width: 1.0)),
        searchInputDecoration: SearchInputDecoration(
          filled: true,
          hintText: 'Search for users dynamic height',
          fillColor: Colors.grey.withValues(alpha: 0.2),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(),
        ),
        marginColor: Colors.grey.shade300,
        suggestions: users
            .map((e) => SearchFieldListItem<UserModel>(e.name,
                child: UserTile(user: e)))
            .toList(),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatar),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  }
}
