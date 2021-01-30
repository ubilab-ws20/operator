import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  @override
  LoginpageState createState() {
    return LoginpageState();
  }
}

class LoginpageState extends State<Loginpage> {
  bool isPassword = false;
  bool isHidden = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Scavenger Hunt',
            style: TextStyle(fontSize: 40, fontFamily: 'Texturina'),
          ),
          backgroundColor: Colors.cyan[800],
          automaticallyImplyLeading: false,
        ),
      ),
      body: Form(
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
                    if (_formKey.currentState.validate()) {
                      if (isPassword == true) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/homepage", (route) => false);
                      }
                    }
                  },
                  color: Colors.cyan[800],
                ),
              ),
            ],
          ),
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
