import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final TabController tabController;

  const CustomTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {}); // Forces the widget to rebuild when the tab changes.
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      unselectedLabelColor: Colors.white54,
      labelColor: Colors.white,
      tabs: [
        Tab(
            icon: widget.tabController.index == 0
                ? Image.asset('assets/icon_event.png', height: 24, width: 24)
                : Image.asset('assets/icon_event_grey.png', height: 24, width: 24),
            text: "Мероприятия"
        ),
        Tab(
            icon: widget.tabController.index == 1
                ? Image.asset('assets/icon_about_us.png', height: 24, width: 24)
                : Image.asset('assets/icon_about_us.png', height: 24, width: 24, color: Colors.white54),
            text: "О нас"
        ),
        Tab(
            icon: widget.tabController.index == 2
                ? Icon(Icons.group)
                : Icon(Icons.group, color: Colors.white54),
            text: "Отряды"
        ),
      ],
    );
  }
}
