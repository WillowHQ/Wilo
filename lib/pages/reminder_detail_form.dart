import 'package:flutter/material.dart';
import 'package:flutter_app/database.dart';


var now = new DateTime.now();
var nextMonth = now.add(new Duration(days: 30));
enum RepeatFrequency {
  does_not_repeat,
  daily,
  weekly,
  weekdays
}

class ReminderDetailForm extends StatefulWidget {
  ReminderDetailForm({ this.reminder, this.database});
  final Reminder reminder;
  final Database database;


  @override
  State<StatefulWidget> createState() => ReminderDetailFormState();

}

class ReminderDetailFormState extends State<ReminderDetailForm> {
  final reminderFormKey = new GlobalKey<FormState>();
  //form
  String _outcome, _action;
  DateTime _startDate, _endDate;
  var _repeatFrequency;

  void initState() {
    super.initState();
    setState(() {
      _outcome = "";
      _action = "";

    });
  }

  bool validateAndSave() {
    final form = reminderFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
  void validateAndSubmit() async {
    if(validateAndSave()) {
      try {
        await widget.database.updateReminder( widget.reminder, _outcome, _action, _startDate, _endDate, _repeatFrequency );
      } catch (e) {
        print('$e');
      }
    }

  }

  void launchDatePicker(BuildContext context) async{
    try {
      var date = await showDatePicker(context: context,
          initialDate: now,
          firstDate: now,
          lastDate: nextMonth);
      setState(() {
        _startDate = date;
      });
    } catch (e) {
      print("error is $e");
    }
  }
  void launchEndDatePicker(BuildContext context) async{
    var date = await showDatePicker(context: context, initialDate: now, firstDate: now, lastDate: nextMonth);
    print("date is $date");

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter login demo'),
        ),
        body: new Container(
          padding: EdgeInsets.all(24.0),
          child: new Form(
            key: reminderFormKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs()+ buildSubmitButtons(context),

            ),
          ),
        )
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
          decoration: new InputDecoration(labelText: 'Outcome'),
          validator: (value) => value.isEmpty ? 'Prompt can\`t be empty' : null,
          onSaved: (value) => _outcome = value),
      new TextFormField(
          decoration: new InputDecoration(labelText: 'Action'),
          validator: (value) => value.isEmpty ? 'Prompt can\`t be empty' : null,
          onSaved: (value) => _action = value),
    ];
  }
  List<Widget> buildSubmitButtons(BuildContext context){
      return [

        new RaisedButton(
          child:
            new Text('Start date', style: new TextStyle(fontSize: 30.0)),
          //TODO have this default to today
          onPressed: () => launchDatePicker(context),
        ),
        new RaisedButton(
          child:
          new Text('End date', style: new TextStyle(fontSize: 30.0)),
          //TODO have this default to today
          onPressed: () => launchEndDatePicker(context),
        ),
        new RaisedButton(
          child:
          new Text("Fire it up bitch", style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),

      ];
    }

  }
