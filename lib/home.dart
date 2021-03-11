import 'package:flutter/material.dart';
import 'package:humangen/drawingarea.dart';





//import '../flutter/packages/flutter/lib/material.dart';

//import '../flutter/packages/flutter/lib/material.dart';
//import '../flutter/packages/flutter/lib/material.dart';
//import '../flutter/packages/flutter/lib/painting.dart';

// Stateful widget tracks its own internal state, but stateless widget is immutable and cannot change its own configuration
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DrawingArea> points = [];
  @override
  // following method golds all the UI data
  Widget build(BuildContext context) {
    // scaffold widget allows us to properly display information
    return Scaffold(
      // on top of linear gradient, this will be the sketching pad
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
              colors: [
                Color.fromRGBO(138, 35, 135, 1.0), 
                Color.fromRGBO(255, 64, 87, 1.0), 
                Color.fromRGBO(242, 113, 33, 1.0)
                ]
              ),
            ), 
          ),
          Center(
            child: Column(
              // centers widget
              crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
              // for multiple widgets
              children: [
                Padding(padding: EdgeInsets.all(8.0),
                // images that get processed into neural network have this size
                child: Container(
                  width: 256, 
                  height: 256, 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.4),
                      blurRadius: 5.0,
                      spreadRadius: 1
                      )
                    ]
                  ),
                  child: GestureDetector(
                    onPanDown: (details) {
                      this.setState(() {
                        points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: 
                          Paint()..strokeCap = StrokeCap.round..
                          isAntiAlias = true..
                          color = Colors.white..
                          strokeWidth = 2.0));
                      });
                    },
                    onPanUpdate: (details) {
                      this.setState(() {
                        points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: 
                          Paint()..strokeCap = StrokeCap.round..
                          isAntiAlias = true..
                          color = Colors.white..
                          strokeWidth = 2.0));
                      });
                    }, 
                    onPanEnd: (details) {
                      this.setState(() {
                        points.add(null);
                      });
                    },
                    child: SizedBox.expand(child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20),
                    ),
                    child: CustomPaint(painter: MyCustomPainter(points: points)),)
                    )
                  )
                ),
              ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                // everything in this row will be centered
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.layers_clear, color: Colors.black), onPressed: () {
                    this.setState(() {
                      points.clear();
                    });
                  },)
                ],
              ),
            )
              ],
            ),
          )
        ],
      )
    );
  }
}