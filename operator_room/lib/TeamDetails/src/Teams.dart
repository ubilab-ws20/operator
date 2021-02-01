import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:operator_room/TeamDetails/src/TeamPage.dart';

class Teams extends StatefulWidget {
  final Color color;
  final Color progressIndicatorColor;
  final String teamName;
  final String percentComplete;
  final IconData icon;

  Teams({
    this.color,
    this.progressIndicatorColor,
    this.teamName,
    this.percentComplete,
    this.icon,
  });
  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  bool hovered = false;
  bool touched = false;

  Future navigateToSubPage(context, teamName, markerColor) async {
    Navigator.pushNamed(context, "/teampage",
        arguments: {teamName, markerColor});
    // context,
    // MaterialPageRoute(
    //     builder: (context) => TeamPage(teamName, markerColor, teamIcon))
    // "/teampage", );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (value) {
        setState(() {
          hovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          print("onTap called.");
          navigateToSubPage(context, widget.teamName, widget.color);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: hovered ? 160.0 : 155.0,
          width: hovered ? 200.0 : 195.0,
          decoration: BoxDecoration(
            color: hovered ? Colors.blue[100] : Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 10.0,
                spreadRadius: 3.0,
              ),
            ],
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: 30.0,
                      width: 30.0,
                      child: Icon(
                        widget.icon,
                        color: hovered ? Colors.black : Colors.white,
                        size: 25.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: hovered ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(
                      //height: 10.0,
                      width: 10.0,
                    ),
                    Container(
                      height: 20.0,
                      //width: 20.0,
                      child: Text(
                        widget.teamName,
                        style: GoogleFonts.quicksand(
                          fontWeight:
                              hovered ? FontWeight.bold : FontWeight.w500,
                          fontSize: 20.0,
                          color: hovered ? Colors.black : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                  //width: 50.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      // height: 50.0,
                      width: 15.0,
                    ),
                    Container(
                      height: 20.0,
                      width: 20.0,
                      child: Icon(
                        Feather.user,
                        size: 13.0,
                        color: hovered ? Colors.white : Colors.black,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: hovered ? Colors.black : Colors.white,
                      ),
                    ),
                    SizedBox(
                      // height: 50.0,
                      width: 10.0,
                    ),
                    Container(
                      height: 15.0,
                      width: 100.0,
                      child: Text(
                        "4 members",
                        style: GoogleFonts.quicksand(
                          fontWeight:
                              hovered ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12.0,
                          color: hovered ? Colors.black : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7.0,
                  //width: 50.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      // height: 50.0,
                      width: 15.0,
                    ),
                    Container(
                      height: 20.0,
                      width: 20.0,
                      child: Icon(
                        !hovered
                            ? MaterialCommunityIcons.lightbulb_outline
                            : MaterialCommunityIcons.lightbulb_on_outline,
                        size: 13.0,
                        color: hovered ? Colors.white : Colors.black,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: hovered ? Colors.black : Colors.white,
                      ),
                    ),
                    SizedBox(
                      // height: 50.0,
                      width: 10.0,
                    ),
                    Container(
                      height: 15.0,
                      width: 100.0,
                      child: Text(
                        "Hints Used:",
                        style: GoogleFonts.quicksand(
                          fontWeight:
                              hovered ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12.0,
                          color: hovered ? Colors.black : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 7.0,
                    left: 135.0,
                  ),
                  child: Text(
                    widget.percentComplete,
                    style: GoogleFonts.quicksand(
                      fontWeight: hovered ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12.0,
                      color: hovered ? Colors.black : Colors.black87,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 275),
                  margin: EdgeInsets.only(top: 5.0),
                  height: 6.0,
                  width: 160.0,
                  decoration: BoxDecoration(
                    color: hovered
                        ? widget.progressIndicatorColor
                        : Color(0xffF5F6FA),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 275),
                      height: 6.0,
                      width: (double.parse(
                                  widget.percentComplete.substring(0, 1)) /
                              10) *
                          160.0,
                      decoration: BoxDecoration(
                        color: hovered ? Colors.white : widget.color,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
