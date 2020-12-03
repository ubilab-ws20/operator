import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:operator_room/NavigationBar/NavigationBar.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<bool> selected = [true, false, false, false, false];

  void select(int n) {
    for (int i = 0; i < 5; i++) {
      if (i != n) {
        selected[i] = false;
      } else {
        selected[i] = true;
      }
    }
  }

  @override
  Future navigateToSubPage(context, team_name) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SubPage(team_name)));
  }

  Widget build(BuildContext context) {
    return Container(
      height: 450.0,
      child: Column(
        children: [
          NavBarItem(
            active: selected[0],
            icon: Feather.home,
            touched: () {
              setState(() {
                select(0);
              });
            },
          ),
          NavBarItem(
            active: selected[1],
            icon: FontAwesome.user,
            touched: () {
              setState(() {
                select(1);
                navigateToSubPage(context, 'Team 1');
                // SubPage('Team 1');
              });
            },
          ),
          NavBarItem(
            active: selected[2],
            icon: FontAwesome.user,
            touched: () {
              setState(() {
                select(2);
                navigateToSubPage(context, 'Team 2');
              });
            },
          ),
          NavBarItem(
            active: selected[3],
            icon: FontAwesome.user,
            touched: () {
              setState(() {
                select(3);
                navigateToSubPage(context, 'Team 3');
              });
            },
          ),
          NavBarItem(
            active: selected[4],
            icon: FontAwesome.user,
            touched: () {
              setState(() {
                select(4);
                navigateToSubPage(context, 'Team 4');
              });
            },
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final Function touched;
  final bool active;
  final String text;

  NavBarItem({
    this.active,
    this.icon,
    this.touched,
    this.text,
  });

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.touched();
        },
        //splashColor: Colors.white,
        hoverColor: Colors.white12,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: Row(
            children: [
              Container(
                height: 20.0,
                width: 60.0,
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 475),
                      height: 35.0,
                      width: 5.0,
                      decoration: BoxDecoration(
                        color:
                            widget.active ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Icon(
                        widget.icon,
                        color: widget.active ? Colors.white : Colors.white54,
                        size: 19.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubPage extends StatelessWidget {
  final String teamname;

  SubPage(this.teamname);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teamname + " Details"),
        backgroundColor: Color(0xff333951),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 300),
          ),
          //NavigationBar(),
          Container(
            height: 30,
            //padding: EdgeInsets.only(left: 300),
            child: Text(
              'Team name',
              textAlign: TextAlign.left,
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            height: 30,
            //padding: EdgeInsets.only(left: 300),
            child: Text(
              'Players',
              textAlign: TextAlign.left,
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            height: 30,
            //padding: EdgeInsets.only(left: 300),
            child: Text(
              'Number of hints used',
              textAlign: TextAlign.left,
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.black),
            ),
          ),

          //TextFormField(
          //decoration: InputDecoration(labelText: 'Enter your username'),
          //),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 30,
              child: Text(
                'Go Back',
                textScaleFactor: 1.5,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
