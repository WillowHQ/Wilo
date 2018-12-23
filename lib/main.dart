import 'package:flutter/material.dart';
import 'login_page.dart';

void main(){
  runApp(new Myapp());
}

class Myapp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter login demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage()
    );
  }

}