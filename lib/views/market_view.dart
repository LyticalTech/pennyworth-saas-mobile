import 'package:flutter/material.dart';

class MarketView extends StatefulWidget {
  const MarketView({Key? key}) : super(key: key);

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  // static const _kAddPhotoTabIndex = 2;
  // int _tabSelectedIndex = 0;

  // Save the home page scrolling offset,
  // used when navigating back to the home page from another tab.
  double _lastFeedScrollOffset = 0;
  ScrollController? _scrollController;

  @override
  void dispose() {
    _disposeScrollController();
    super.dispose();
  }

  // void _scrollToTop() {
  //   if (_scrollController == null) {
  //     return;
  //   }
  //   if (_scrollController != null) {
  //     _scrollController?.animateTo(
  //       0.0,
  //       duration: const Duration(milliseconds: 250),
  //       curve: Curves.decelerate,
  //     );
  //   }
  // }

  // Call this when changing the body that doesn't use a ScrollController.
  void _disposeScrollController() {
    if (_scrollController != null) {
      _lastFeedScrollOffset = _scrollController!.offset;
      _scrollController?.dispose();
      _scrollController = null;
    }
  }
  //
  // void _onTabTapped(BuildContext context, int index) {
  //   if (index == _kAddPhotoTabIndex) {
  //     displaySnackBar(context, 'Add Photo');
  //   } else if (index == _tabSelectedIndex) {
  //     _scrollToTop();
  //   } else {
  //     setState(() => _tabSelectedIndex = index);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }


  void displaySnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
