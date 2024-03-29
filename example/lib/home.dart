import 'package:example/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stories/stories.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Stories(
              cellHeight: 105,
              cellWidth: 65,
              // underBorderColor: Colors.amber,
              // allowBorder: false,
              // allowAnimation: false,
              // transitionDuration: Duration.zero,
              // reverseTransitionDuration: Duration.zero,
              // imageSwitchDuration: Duration.zero,
              // reverseImageSwitchDuration: Duration.zero,
              cells: [
                cell,
                cell1,
                cell5,
                cell6,
                cell7,
                cell8,
                cell9,
                cell10,
                cell11,
                cell12,
                cell13,
                cell14,
                cel15,
                cell16,
                imageCell
                // cell17,
                // cell18,
                // cell19,
                // cell20,
                // cell21,
                // cell22,
                // cell23,
                // cell24,
                // cell25,
                // cell26,
                // cell20,
                // cell21,
                // cell22,
                // cell23,
                // cell24,
                // cell25,
                // cell26,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
