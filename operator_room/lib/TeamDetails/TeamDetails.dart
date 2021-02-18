import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:operator_room/TeamDetails/src/Teams.dart';
import 'package:operator_room/globals.dart';

final String pageTitleString = "Operator Room";

class TeamDetails extends StatefulWidget {
  final Map teamNames;

  TeamDetails({
    this.teamNames,
  });

  @override
  _TeamDetailsState createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  @override
  Widget build(BuildContext context) {
    if (globalIsTesting) {
      print("TeamDetails::In TeamPage ${widget.teamNames}");
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        alignment: Alignment.centerLeft,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 30.0, top: 10.0, bottom: 10.0),
              child: Text(
                pageTitleString,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Piazzolla',
                  fontWeight: FontWeight.bold,
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
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                scrollDirection: Axis.horizontal,
                itemCount: (widget.teamNames.length).ceil(),
                itemBuilder: (BuildContext context, int index) {
                  if (globalIsTesting) {
                    print(
                        "Builder:$index- ${globalTeamName[index]},${globalProgressPercentage[index]}, ${globalTeamSize[index]}");
                  }
                  return Teams(
                    color: globalTeamColor[index],
                    teamName: globalTeamName[index],
                    percentComplete:
                        (double.parse(globalProgressPercentage[index]) * 100)
                            .floor()
                            .toString(),
                    teamSize: globalTeamSize[index],
                    hintsUsed: globalHintsUsed[index],
                    currentPuzzle: globalCurrentPuzzleInfo[index],
                    currentLocation: globalCurrentLocation[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 50.0,
                    height: 160.0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
