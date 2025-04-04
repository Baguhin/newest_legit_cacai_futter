import 'package:flutter/material.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:cacai/ui/views/home/home_view.dart';
import 'package:cacai/ui/views/settings.dart';
import 'package:cacai/chatbot.dart';
import 'package:cacai/ui/homepage.dart';
import '../collection.dart';

class BottomNavDrawer extends StatefulWidget {
  const BottomNavDrawer({super.key});

  @override
  _BottomNavDrawerState createState() => _BottomNavDrawerState();
}

class _BottomNavDrawerState extends State<BottomNavDrawer> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const PestListHomePage(), // Home
    const CollectionPage(), // Collection
    const GeminiChatPage(), // Chatbot
    const SettingsPage(), // Settings
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500), // Smooth slide animation
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        itemBuilder: (context, index) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                        .animate(animation),
                child: child,
              );
            },
            child: _pages[index],
          );
        },
      ),
      floatingActionButton: _selectedIndex == 2
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const HomeView(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 1), end: Offset.zero)
                            .animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
              backgroundColor: Colors.green.shade800,
              elevation: 6,
              child: const Icon(
                Icons.camera_enhance_rounded,
                color: Colors.white,
                size: 45,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: Colors.white,
        onItemSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        bottomPadding: 10,
        waterDropColor: Colors.green.shade800,
        iconSize: 30,
        barItems: [
          BarItem(
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.collections_bookmark,
            outlinedIcon: Icons.collections_bookmark_outlined,
          ),
          BarItem(
            filledIcon: Icons.chat,
            outlinedIcon: Icons.chat_bubble_outline,
          ),
          BarItem(
            filledIcon: Icons.settings,
            outlinedIcon: Icons.settings_outlined,
          ),
        ],
      ),
    );
  }
}
