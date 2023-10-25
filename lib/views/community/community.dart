import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/views/community/chat/chats.dart';
import 'package:residents/views/community/market_place/market_place.dart';

class Community extends StatefulWidget {
  @override
  CommunityState createState() => CommunityState();
}

class CommunityState extends State<Community> {
  int currentIndex = 0;
  var title = "Chats";

  final List<Widget> screens = [Chats(), MarketPlace()];

  void _setCurrentScreen(int index) {
    setState(() {
      currentIndex = index;
      title = index == 0 ? "Chats" : "Market Place";
    });
  }

  @override
  void initState() {
    title = "Chat";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: _setCurrentScreen,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bubble_left_bubble_right),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            label: "Market Place",
          ),
        ],
      ),
    );
  }
}
