import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(
          title: 'My Home Page',
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// false works fine
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomWidget(),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWidget extends StatefulWidget {
  const CustomWidget({Key? key}) : super(key: key);
  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
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
                    onTap: () {
                      _portalController.hide();
                    },
                  ))),
    );
  }

  GlobalKey gkey = GlobalKey();
  final OverlayPortalController _portalController = OverlayPortalController();
  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.8),
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    );
    Widget textfield() {
      return TextFormField(
        key: gkey,
        decoration: inputDecoration,
        onTap: () {
          if (!_portalController.isShowing) {
            setState(() {
              _portalController.show();
            });
          }
        },
        onChanged: (query) {},
      );
    }

    return OverlayPortal(
      controller: _portalController,
      overlayChildBuilder: (BuildContext context) {
        // Justin: (I think) this RenderBox is guaranteed to already be laid out here.
        final renderBox = gkey.currentContext!.findRenderObject() as RenderBox;
        final Size tSize = renderBox.size;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        // bottom Offset when keyboard is launched
        final bottomOffset = EdgeInsets.fromViewPadding(
                View.of(context).viewInsets, View.of(context).devicePixelRatio)
            .bottom;
        return AnimatedPositioned(
          duration: Duration(seconds: 1),
          left: offset.dx,
          top: offset.dy + tSize.height - bottomOffset, // + textfield height
          child: Material(
            color: Colors.red,
            child: SizedBox(
              width: tSize.width,
              child: _list(),
            ),
          ),
        );
      },
      child: Material(
        child: textfield(),
      ),
    );
  }
}
