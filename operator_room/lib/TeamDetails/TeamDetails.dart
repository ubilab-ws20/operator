import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:operator_room/TeamDetails/src/Teams.dart';

class TeamDetails extends StatefulWidget {
  List<String> teamNames;

  TeamDetails({
    this.teamNames,
  });

  @override
  _TeamDetailsState createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Positioned(
          left: 30.0,
          child: Container(
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //color: Colors.white,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 30.0, top: 25.0, bottom: 10.0),
                  child: Text(
                    "Operator Room",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      //fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                  child: ListView.separated(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.teamNames.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Teams(
                          color: Color(0xff914BA9),
                          teamName: widget.teamNames[index],
                          percentComplete: '35%',
                          progressIndicatorColor: Colors.black87,
                          icon: MaterialCommunityIcons.numeric_1,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 50.0,
                          height: 160.0,
                        );
                      }
                      // children: [
                      //   Teams(
                      //     color: Color(0xff914BA9),
                      //     teamName: 'Team 1',
                      //     percentComplete: '35%',
                      //     progressIndicatorColor: Colors.black87,
                      //     icon: MaterialCommunityIcons.numeric_1,
                      //   ),
                      //   Teams(
                      //     color: Color(0xffF1F354),
                      //     teamName: 'Team 2',
                      //     percentComplete: '48%',
                      //     progressIndicatorColor: Colors.black87,
                      //     icon: MaterialCommunityIcons.numeric_2,
                      //   ),
                      //   Teams(
                      //     color: Color(0xff40F034),
                      //     teamName: 'Team 3',
                      //     percentComplete: '27%',
                      //     progressIndicatorColor: Colors.black87,
                      //     icon: MaterialCommunityIcons.numeric_3,
                      //   ),
                      //   Teams(
                      //     color: Color(0xffDD3D1B),
                      //     teamName: 'Team 4',
                      //     percentComplete: '68%',
                      //     progressIndicatorColor: Colors.black87,
                      //     icon: MaterialCommunityIcons.numeric_4,
                      //   ),
                      // ],
                      ),
                ),
              ],
            ),
          )),
    );
  }
}
