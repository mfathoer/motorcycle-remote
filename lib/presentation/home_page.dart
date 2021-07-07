import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Flexible(
          child: Center(
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), primary: Colors.green),
                  child: Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Text(
                      "START\nENGINE",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                  ))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {},
                child: Container(
                    width: 128,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("PRE-START"))),
            SizedBox(
              width: 24,
            ),
            ElevatedButton(
                onPressed: () {},
                child: Container(
                    width: 128,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("EMERGENCY MODE")))
          ],
        ),
        SizedBox(
          height: 48,
        ),
        FloatingActionButton(child: Icon(Icons.mic), onPressed: () {}),
        SizedBox(
          height: 56,
        ),
      ],
    ));
  }
}
