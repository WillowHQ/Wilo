import 'package:flutter/material.dart';
import 'package:flutter_app/database.dart';
import 'package:flutter_app/pages/set_state_page.dart';
import 'package:flutter_app/pages/reminders_set_state_page.dart';
import 'package:flutter_app/pages/reminder_detail_form.dart';



enum TabItem {
  setState,
  reminders,

}

String tabItemName(TabItem tabItem) {
  switch (tabItem) {
    case TabItem.setState:
      return "setState";
    case TabItem.reminders:
      return "reminders";

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
        _updateCurrentItem(TabItem.reminders);
        break;

    }
  }
  _navToNewPage(Database database, Reminder reminder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReminderDetailForm(database: database, reminder: reminder)),
    );
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
    var remindersStream = database.remindersStream();
    switch (currentItem) {
      case TabItem.setState:
        return SetStatePage(database: database, stream: stream);
      case TabItem.reminders:
        return ReminderSetStatePage(database: database, stream: remindersStream, handleNavChange: _navToNewPage);

    }
    return Container();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(icon: Icons.adjust, tabItem: TabItem.setState),
        _buildItem(icon: Icons.clear_all, tabItem: TabItem.reminders),


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

class SecondScreen extends StatelessWidget {
  SecondScreen({this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${reminder.id}'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}