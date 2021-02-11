import 'package:flutter/material.dart';
import 'package:operator_room/Homepage/HomePage.dart';
import 'package:operator_room/globals.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    print("LoginPage::IsLoggedInMain:$isLoggedIn");
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  bool _isPassword = false;
  bool _isHidden = true;

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
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      suffix: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == globalLoginPassword) {
                        _isPassword = true;
                        return null;
                      } else {
                        _isPassword = false;
                        return 'Wrong password';
                      }
                    },
                    onFieldSubmitted: (value) {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (_isPassword == true) {
                          isLoggedIn = true;
                          manager.initialiseMQTTClient();
                          manager.connect();
                          print("LoginPage::IsLoggedIn $isLoggedIn");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(),
                            ),
                            (route) => false,
                          );
                        }
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
                      if (_isPassword == true) {
                        isLoggedIn = true;
                        manager.initialiseMQTTClient();
                        manager.connect();
                        print("LoginPage::IsLoggedIn $isLoggedIn");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(),
                          ),
                          (route) => false,
                        );
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
      _isHidden = !_isHidden;
    });
  }
}
