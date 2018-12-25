import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_app/database.dart';
import 'package:flutter_app/pages/redux_page.dart';
import 'package:flutter_app/pages/scoped_models_page.dart';
import 'package:flutter_app/pages/set_state_page.dart';
import 'package:flutter_app/pages/streams_page.dart';

enum TabItem {
  setState,
  streams,

}

String tabItemName(TabItem tabItem) {
  switch (tabItem) {
    case TabItem.setState:
      return "setState";
    case TabItem.streams:
      return "streams";

  }
  return null;
}

class BottomNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  TabItem currentItem = TabItem.setState;

  _onSelectTab(int index) {
    switch (index) {
      case 0:
        _updateCurrentItem(TabItem.setState);
        break;
      case 1:
        _updateCurrentItem(TabItem.streams);
        break;

    }
  }

  _updateCurrentItem(TabItem item) {
    setState(() {
      currentItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    var database = AppFirestore();
    var stream = database.countersStream();
    switch (currentItem) {
      case TabItem.setState:
        return SetStatePage(database: database, stream: stream);
      case TabItem.streams:
        return StreamsPage(database: database, stream: stream);

    }
    return Container();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(icon: Icons.adjust, tabItem: TabItem.setState),
        _buildItem(icon: Icons.clear_all, tabItem: TabItem.streams),

      ],
      onTap: _onSelectTab,
    );
  }

  BottomNavigationBarItem _buildItem({IconData icon, TabItem tabItem}) {
    String text = tabItemName(tabItem);
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentItem == item ? Theme.of(context).primaryColor : Colors.grey;
  }
}
