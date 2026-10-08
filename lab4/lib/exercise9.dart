import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NavigationScreen(),
  ));
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  final _titles = ['Home', 'Saved', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
          bottom: _selectedIndex == 0
              ? const TabBar(
                  tabs: [
                    Tab(text: 'For You'),
                    Tab(text: 'Trending'),
                  ],
                )
              : null,
        ),
        body: _selectedIndex == 0
            ? const TabBarView(
                children: [
                  Center(child: Text('Your daily mix')),
                  Center(child: Text('Trending tracks 🔥')),
                ],
              )
            : Center(
                child: Text(
                  _selectedIndex == 1
                      ? 'Saved tracks ❤️'
                      : 'Profile 👤',
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            debugPrint('Opened ${_titles[index]}');
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}