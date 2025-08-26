// New file: main_page.dart

import 'package:flutter/material.dart';
import 'homepage.dart'; // Import your homepage
import 'history_page.dart'; // Import your new history page
import 'me_page.dart';


class MainPage extends StatefulWidget {
  final String name;
  const MainPage({super.key, required this.name});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Tracks the currently selected tab
  late final List<Widget> _pages; // A list to hold our pages

  @override
  void initState() {
    super.initState();
    // Initialize the list of pages here, so we can pass the user's name
    _pages = <Widget>[
      Homepage(name: widget.name),
      HistoryPage(name: widget.name),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // In main_page.dart

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('RADAR', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // REPLACE THE ACTIONS SECTION WITH THIS:
        actions: [
          TextButton(
            onPressed: () {
              // This is where we navigate to the new MePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MePage(name: widget.name)),
              );
            },
            child: Text(
              'Welcome, ${widget.name}',
              style: TextStyle(color: Colors.blue), // Set color to make it visible
            ),
          ),
        ],
      ),
      // The body of the screen is now just the selected page from our list
      body: _pages.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Records',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
