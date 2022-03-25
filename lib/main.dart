import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:img_classi/mobilenet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //  home: Mobilenet(),
        debugShowCheckedModeBanner: false,
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // var _image;
  bool isImageloaded = false;
  final picker = ImagePicker();
  List _result = [];
  String _confidence = "";
  String _name = "";
  String numbers = "";
//FileImage vad;
  var picimg;

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      imageQuality:100,
        maxHeight: 200,
      maxWidth: 200
    );

    setState(() {
      // if (pickedFile != null) {
      //   _image = File(pickedFile.path);
      // } else {
      //   print('No image selected.');
      // }
      picimg = File(pickedFile!.path);
      isImageloaded = true;
      ApplymodelonImage(File(pickedFile.path));
    });
  }

  Future getImageCam() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      // if (pickedFile != null) {
      //   _image = File(pickedFile.path);
      // } else {
      //   print('No image selected.');
      // }
      picimg = File(pickedFile!.path);
      isImageloaded = true;
      ApplymodelonImage(File(pickedFile.path));
    });
  }

  //loading the model
  loadMyModel() async {
    Tflite.close();
    var resultant = await Tflite.loadModel(
        // model: 'assets/flower_model.tflite',
        // labels: 'assets/flower_labels.txt');
        model: 'assets/mnist_custom_final.tflite',
        labels: 'assets/digit.txt');
    print("Result after loading the model: $resultant");
  }

  ApplymodelonImage(File file) async {
    var res = await Tflite.runModelOnImage(
        path: file.path,
        //numResults: 3,
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true );
    setState(() {
      _result = res!;

      String str = _result[0]['label'];
      _name = str.substring(0).toUpperCase();
      _confidence = _result != null
          ? (_result[0]['confidence'] * 100).toString().substring(0, 4) + "%"
          : "";
      // print("${_result[0]},:reslut1:${_result[1]},${_result[2]}");
      print(_result[0]);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyModel();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            isImageloaded
                ? Center(
                    child: Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(picimg.path)),
                            fit: BoxFit.contain,
                          ),
                          border: Border.all(
                            color: Colors.black,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                "Result : $_name \n\nConfidence: $_confidence",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.teal, primary: Colors.white),
                    icon: Icon(Icons.picture_in_picture),
                    label: Text('From Gallery.'),
                    onPressed: () {
                      getImage();
                    },
                  ),
                ),
                Container(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.teal, primary: Colors.white),
                    icon: Icon(Icons.camera),
                    label: Text('From Camera'),
                    onPressed: () {
                      getImageCam();
                    },
                  ),
                )
              ],
            ),
            // Container(
            //   child: TextButton.icon(
            //
            //     style: TextButton.styleFrom(
            //         backgroundColor: Colors.teal,
            //         primary: Colors.white
            //     ),
            //     icon: Icon(Icons.camera),
            //     label: Text('From Camera'),
            //
            //     onPressed: () {
            //       getImageCam();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: getImage,
      //   tooltip: 'Pick Image',
      //   child: Icon(Icons.add_a_photo),
      //),
    );
  }
}
