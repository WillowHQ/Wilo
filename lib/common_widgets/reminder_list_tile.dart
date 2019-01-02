import 'package:flutter/material.dart';
import 'package:flutter_app/database.dart';

class ReminderListTile extends StatefulWidget {
  ReminderListTile(
      {this.key, this.reminder, this.onDecrement, this.onIncrement, this.onDismissed, this.onNav});

  final Key key;
  final Reminder reminder;
  final ValueChanged<Reminder> onDecrement;
  final ValueChanged<Reminder> onIncrement;
  final ValueChanged<Reminder> onDismissed;
  final onNav;


  @override
  State<StatefulWidget> createState() => _ReminderTileState();
}
class _ReminderTileState extends State<ReminderListTile> {
  final reminderFormKey = GlobalKey<FormState>();

  String _prompt;

  @override

  Widget build(BuildContext context) {
    return
      Form(
        key: reminderFormKey,
        child: Dismissible(
      background: Container(color: Colors.red),
      key: widget.key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => widget.onDismissed(widget.reminder),
      child: ListTile(

        title: Text(
          'Phil',
          style: TextStyle(fontSize: 16.0),
        ),
        subtitle: Text(
          'Phil',
          style: TextStyle(fontSize: 16.0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ReminderActionButton(
              iconData: Icons.remove,
              onPressed: () => widget.onDecrement(widget.reminder),
            ),
            SizedBox(width: 8.0),
            ReminderActionButton(
              iconData: Icons.add,
              onPressed: () => widget.onNav(widget.reminder),
            ),
          ],
        ),
      ),
    ),
      );
  }
}

class ReminderActionButton extends StatelessWidget {
  ReminderActionButton({this.iconData, this.onPressed});
  final VoidCallback onPressed;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28.0,
      backgroundColor: Theme.of(context).primaryColor,
      child: IconButton(
        icon: Icon(iconData, size: 28.0),
        color: Colors.black,
        onPressed: onPressed,
      ),
    );
  }
}
