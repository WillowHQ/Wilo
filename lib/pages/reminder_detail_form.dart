import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/database.dart';

class ReminderDetailForm extends StatefulWidget {
  ReminderDetailForm({ this.reminder, this.database});
  final Reminder reminder;
  final Database database;


  @override
  State<StatefulWidget> createState() => ReminderDetailFormState();

}

class ReminderDetailFormState extends State<ReminderDetailForm> {
  final reminderFormKey = new GlobalKey<FormState>();
  String _prompt;
  void initState() {
    super.initState();
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
        await widget.database.updateReminder( widget.reminder, _prompt);
      } catch (e) {
        print('$e');
      }
    }

  }
  void _increment() async  {

    await widget.database.createReminder();

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
              children: buildInputs()+ buildSubmitButtons(),

            ),
          ),
        )
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
          decoration: new InputDecoration(labelText: 'prompt'),
          validator: (value) => value.isEmpty ? 'Prompt can\`t be empty' : null,
          onSaved: (value) => _prompt = value),
    ];
  }
  List<Widget> buildSubmitButtons(){
      return [
        new RaisedButton(
          child:
          new Text('Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child:
            new Text('Suck a dick', style: new TextStyle(fontSize: 30.0)),
          onPressed: ()=> {},
        )
      ];
    }
  }
