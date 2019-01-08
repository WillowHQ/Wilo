import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/common_widgets/reminder_list_tile.dart';
import 'package:flutter_app/common_widgets/list_items_builder.dart';
import 'package:flutter_app/database.dart';

class ReminderSetStatePage extends StatefulWidget {
  ReminderSetStatePage({this.database, this.stream, this.handleNavChange});
  final Database database;
  final Stream<List<Reminder>> stream;
  final handleNavChange;

  @override
  State<StatefulWidget> createState() => ReminderSetStatePageState();
}

class ReminderSetStatePageState extends State<ReminderSetStatePage> {
  List<Reminder> _reminders;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.stream.listen((reminders) {
      setState(() {
        _reminders = reminders;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _createReminder() async {
    await widget.database.createReminder();
  }
  void _nav(Reminder reminder) {
    widget.handleNavChange(widget.database, reminder);
  }
  void _increment(Reminder reminder) async {
    reminder.value++;
    await widget.database.setReminder(reminder);
  }

  void _updatePrompt(Reminder reminder, String prompt) async {
    reminder.prompt = prompt;

  }
  void _decrement(Reminder reminder) async {
    reminder.value--;
    await widget.database.setReminder(reminder);
  }

  void _delete(Reminder reminder) async {
    await widget.database.deleteReminder(reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        elevation: 1.0,
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _createReminder,
      ),
    );
  }

  Widget _buildContent() {
    return ListItemsBuilder<Reminder>(
      items: _reminders,
      itemBuilder: (context, reminder) {

        print(reminder.prompt.toString());
        print(reminder.value.toString());
        return ReminderListTile(
          key: Key('counter-${reminder.id}'),
          reminder: reminder,
          onDecrement: _decrement,
          onIncrement: _increment,
          onDismissed: _delete,
          onNav: _nav,
        );
      },
    );
  }
}
