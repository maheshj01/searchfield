import 'package:example/example1.dart';
import 'package:example/example2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ExampleList());
  }
}

class ExampleList extends StatelessWidget {
  const ExampleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('SearchField Demo')),
        body: Column(
          children: [
            ListTile(
              title: Text('Example 1'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Example1()));
              },
            ),
            ListTile(
              title: Text('Example 2'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => Example2(
                          title: 'Country List',
                        )));
              },
            ),
          ],
        ));
  }
}
