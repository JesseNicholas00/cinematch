import 'package:cinematch/screens/Search.dart';
import 'package:cinematch/screens/WatchList.dart';
import 'package:cinematch/screens/HomePage.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  Index({Key key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  
  static Search search = new Search();
  static Watchlist watchList = new Watchlist();
  static HomePage homePage = new HomePage();

  static List<Widget> _widgetOptions = <Widget>[
    search,
    homePage,
    watchList,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Index'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Watch List'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
