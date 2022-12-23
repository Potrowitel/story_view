import 'package:example/data.dart';
import 'package:flutter/material.dart';
import 'package:stories/stories.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          //     child: GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return StoriesOpen(
          //             cell: cell,
          //           );
          //         },
          //       ),
          //     );
          //   },
          //   child: Container(
          //     height: 100,
          //     width: 100,
          //     color: Colors.amber,
          //   ),
          // )
          child: Stories(
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
              cell13
            ],
          ),
        ),
      ),
    );
  }
}
