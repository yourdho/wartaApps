import 'package:flutter/material.dart';
import 'package:wartaapps/view/home/home_page.dart';
import 'package:wartaapps/view/my-articles/my_articles.dart';
import 'package:wartaapps/view/profile/profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const MyArticlesPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF2B4D8C),
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  child: Icon(Icons.home, size: _currentIndex == 0 ? 28 : 24),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.article,
                    size: _currentIndex == 1 ? 28 : 24,
                  ),
                ),
                label: 'My Articles',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  child: Icon(Icons.person, size: _currentIndex == 2 ? 28 : 24),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
