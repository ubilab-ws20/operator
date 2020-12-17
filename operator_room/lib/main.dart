import 'dart:html';

import 'package:flutter/material.dart';
import 'package:operator_room/Homepage/HomePage.dart';
import 'package:operator_room/TeamDetails/TeamDetails.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
                centerTitle: true,
                title: Text(
                  'Scavenger Hunt',
                  style: TextStyle(fontSize: 40, fontFamily: 'Texturina'),
                ),
                backgroundColor: Colors.cyan[800])),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  bool isPassword = false;
  bool isHidden = true;

  final localStorage = window.localStorage;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(100, 90, 100, 0),
              margin: EdgeInsets.all(40),
              child: Text(
                'Operator Login',
                style: TextStyle(
                    color: Colors.cyan[800],
                    fontSize: 40,
                    fontFamily: 'Texturina'),
              ),
            ),
            Container(
                child: TextFormField(
                  obscureText: isHidden,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    suffix: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                        isHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == 'abc123') {
                      isPassword = true;
                      return null;
                    } else {
                      isPassword = false;
                      return 'Wrong password';
                    }
                  },
                ),
                padding: EdgeInsets.fromLTRB(100, 0, 100, 10),
                margin: EdgeInsets.all(20),
                width: 450),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                child: Text(
                  'Submit',
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Texturina'),
                ),
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    //If the form is valid, display a Snackbar.
                    // Scaffold.of(context)
                    //   .showSnackBar(SnackBar(content: Text('Processing Data')));
                    if (isPassword == true) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  }
                },
                color: Colors.cyan[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}
