import 'package:flutter/material.dart';
import 'package:rise/modules/add_screens/add_note_screen.dart';

import 'package:rise/modules/add_screens/add_task_screen.dart';
import 'package:rise/modules/home_screen.dart';

import 'package:rise/modules/quick_note_screen.dart';

class HomeScreenLayout extends StatefulWidget {
  const HomeScreenLayout({super.key});

  @override
  State<HomeScreenLayout> createState() => _HomeScreenLayoutState();
}

class _HomeScreenLayoutState extends State<HomeScreenLayout> {
  int _selectedPageIndex = 0;
  bool _isMenuOpen = false;

  final List<Widget> pages = [
    HomeScreen(),
    QuickNotesWidget(),
    HomeScreen(),
  ];

  void _onButtonTap(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[_selectedPageIndex],
          if (_isMenuOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isMenuOpen = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16, right: 16),
              height: 60,
              width: 60,
              child: Material(
                shape: const CircleBorder(),
                elevation: 6,
                color: Colors.white,
                child: PopupMenuButton<String>(
                  onOpened: () {
                    setState(() {
                      _isMenuOpen = true;
                    });
                  },
                  onCanceled: () {
                    setState(() {
                      _isMenuOpen = false;
                    });
                  },
                  onSelected: (value) {
                    setState(() {
                      _isMenuOpen = false;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  icon: const Icon(Icons.add, color: Colors.black),
                  offset: const Offset(0, -150),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 'add_task',
                        onTap: () {
                          setState(() {
                            _isMenuOpen = false;
                          });
                          Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (context) => const AddTaskScreen()));
                        },
                        child: Text('📝 Add Task')),
                    PopupMenuItem(
                        onTap: () {
                          setState(() {
                            _isMenuOpen = false;
                          });
                          Navigator.push(
                            (context),
                            MaterialPageRoute(
                              builder: (context) => const AddNoteScreen(),
                            ),
                          );
                        },
                        child: Text('🧾 Add Notes')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFf96060),
        currentIndex: _selectedPageIndex,
        onTap: _onButtonTap,
        items: <BottomNavigationBarItem>[
          _bottomNavigationButton("Home", Icons.task_alt_rounded),
          _bottomNavigationButton("Notes", Icons.book_sharp),
          _bottomNavigationButton("Profile", Icons.person_outline_sharp),
        ],
      ),
    );
  }

  BottomNavigationBarItem _bottomNavigationButton(
      String label, IconData iconData) {
    return BottomNavigationBarItem(
      activeIcon: Icon(
        iconData,
        color: Colors.white,
        size: 30,
      ),
      icon: Icon(iconData, color: Colors.white),
      label: label,
    );
  }
}
