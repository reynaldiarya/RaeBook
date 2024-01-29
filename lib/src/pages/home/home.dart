import 'package:ebook/src/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:ebook/src/pages/home/widget/custom_app_bar.dart';
import 'package:ebook/src/pages/home/widget/book_header.dart';
import 'package:ebook/src/pages/home/widget/category.dart';
import 'package:ebook/src/pages/home/widget/book_list.dart';
import 'package:ebook/src/pages/library/library.dart';
import 'package:ebook/src/settings/settings_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          onPageChanged: ((value) => setState(() {
                currentIndex = value;
              })),
          controller: pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            Home(settingsController: widget.settingsController),
            Library(settingsController: widget.settingsController),
            Profile(settingsController: widget.settingsController),
          ]),
      bottomNavigationBar: _buildBottonBar(),
    );
  }

  BottomNavigationBar _buildBottonBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
              currentIndex = index;
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
            }),
        selectedItemColor: const Color(0xFF6741FF),
        items: const [
          BottomNavigationBarItem(
              label: 'Home', icon: Icon(Icons.home_rounded)),
          BottomNavigationBarItem(
              label: 'Library', icon: Icon(Icons.menu_book_rounded)),
          BottomNavigationBarItem(
              label: 'Profile', icon: Icon(Icons.person_outline)),
        ]);
  }
}

class Home extends StatelessWidget {
  const Home({Key? key, required this.settingsController}) : super(key: key);
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          CustomAppBar(settingsController: settingsController),
          BookHeader(
            settingsController: settingsController,
          ),
          Category(settingsController: settingsController),
          BookList(
            settingsController: settingsController,
          ),
        ],
      ),
    );
  }
}
