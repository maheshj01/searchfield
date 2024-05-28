// Note: This is not an SearchField example
//
// This code is a minimal repro, used to report issue related to overlay

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: BottomNavBarHome(),
    );
  }
}

class PageOne extends StatefulWidget {
  const PageOne({Key? key, required this.bottomNavBarKey}) : super(key: key);

  final GlobalKey<State<BottomNavigationBar>> bottomNavBarKey;

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  final ScrollController _scrollController = ScrollController();
  BottomNavigationBar? bottomNavKey;

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
                      _searchFocus.unfocus();
                      if (widget.bottomNavBarKey.currentWidget != null) {
                        bottomNavKey = widget.bottomNavBarKey.currentWidget
                            as BottomNavigationBar;
                      }
                      bottomNavKey?.onTap!(1);
                    },
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
                  child: TapRegion(
                      onTapInside: (x) {
                        suggestionInFocus = true;
                      },
                      onTapOutside: (x) {
                        suggestionInFocus = false;
                        if (!_searchFocus.hasFocus) {
                          if (_overlayEntry != null && _overlayEntry!.mounted) {
                            _overlayEntry!.remove();
                          }
                        }
                      },
                      child: Material(color: Colors.red, child: _list()))),
            ));
  }

  OverlayEntry? _overlayEntry;

  bool suggestionInFocus = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = _createOverlay();
    });
    _searchFocus = FocusNode();
    _searchFocus.addListener(() {
      print("suggestion in Focus ${suggestionInFocus}");
      if (!_searchFocus.hasFocus && !suggestionInFocus) {
        if (_overlayEntry != null && _overlayEntry!.mounted) {
          _overlayEntry!.remove();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
    }
    _searchFocus.dispose();
    super.dispose();
  }

  late FocusNode _searchFocus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Steps to Reproduce'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CompositedTransformTarget(
              link: _layerLink,
              child: TextFormField(
                focusNode: _searchFocus,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                onTap: () {
                  Overlay.of(context).insert(_overlayEntry!);
                },
                onChanged: (query) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBarHome extends StatefulWidget {
  const BottomNavBarHome({Key? key}) : super(key: key);

  @override
  State<BottomNavBarHome> createState() => _BottomNavBarHomeState();
}

class _BottomNavBarHomeState extends State<BottomNavBarHome> {
  late PageController _pageController;
  late final GlobalKey<State<BottomNavigationBar>> _bottomNavBarKey;
  DateTime? currentBackPressTime;
  @override
  void initState() {
    _pageController = PageController();
    _bottomNavBarKey = GlobalKey<State<BottomNavigationBar>>();
    super.initState();
  }

  int selectindex = 0;
  void _onItemTapped(int selectedIndex) {
    setState(() {
      selectindex = selectedIndex;
      _pageController.jumpToPage(selectindex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          children: [
            PageOne(
              bottomNavBarKey: _bottomNavBarKey,
            ),
            PageSecond(),
            PageThird(),
          ],
          // onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectindex,
          type: BottomNavigationBarType.fixed,
          key: _bottomNavBarKey,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Page 1',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Page 2',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Page 3',
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class PageSecond extends StatelessWidget {
  const PageSecond({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Page Second')),
    );
  }
}

class PageThird extends StatelessWidget {
  const PageThird({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'Page Third',
      )),
    );
  }
}
