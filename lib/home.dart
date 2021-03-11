import 'package:flutter/material.dart';
import 'package:humangen/drawingarea.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:core';
import 'dart:async';
// allows us to connect to the api
import 'package:http/http.dart' as http;






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
  Widget imageOutput;

  void saveToImage(List<DrawingArea> points) async {
    // records our canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(200, 200)));
    // pen
    Paint paint = Paint()..color = Colors.white..strokeCap = StrokeCap.round..strokeWidth = 2.0;
    // background
    final paint2 = Paint()..style = PaintingStyle.fill..color = Colors.black;

    canvas.drawRect(Rect.fromLTWH(0, 0, 256, 256), paint2);

    // recreating canvas from sketch
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i+1] != null) {
        canvas.drawLine(points[i].point, points[i+1].point, paint);
    }
    }

    final picture = recorder.endRecording();
    // the img variable is our final sketch
    final img = await picture.toImage(256, 256);

    // converting it into png
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final listBytes = Uint8List.view(pngBytes.buffer);

    //File file = await writeBytes(listBytes);

    String base64 = base64Encode(listBytes);
    fetchResponse(base64);
  }

  void fetchResponse(var bas64Image) async {
    var data = {"Image": bas64Image};

    print("Starting request");

    // might have to change this to the other local host
    var url = 'http://127.0.0.1:5000/predict';
    var urlUri = Uri.parse(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'Keep-Alive'
    };
    var body = json.encode(data);
    try {
      // holds json data for generated image
      var response = await http.post(urlUri, body: body, headers: headers);

      final Map<String, dynamic> responseData = json.decode(response.body);
      String outputBytes = responseData['Image'];
      print(outputBytes.substring(2, outputBytes.length - 1));
      
    } catch(e) {
      print(" * ERROR has Occured");
      print(e);
      return null;
    }
  }
  
  void displayResponseImage(String bytes) async {
    Uint8List convertedBytes = base64Decode(bytes);

    setState(() {
      imageOutput = Container(
        width: 256, 
        height: 256, 
        child: Image.memory(
          convertedBytes,
          fit: BoxFit.cover,
        )
      );
    });
  }


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
                      saveToImage(points);
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
