import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Mobilenet(),
//     );
//   }
// }

class Mobilenet extends StatefulWidget {
  @override
  _MobilenetState createState() => _MobilenetState();
}

class _MobilenetState extends State<Mobilenet> {
  File _image=File('assets/lables.txt');
  bool isImageloaded=false;
  final picker = ImagePicker();
  List _result=[];

  String _confidence="";
  String _name="";
 // String numbers ="";


  var picimg;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {

      picimg=File(pickedFile!.path);
      isImageloaded=true;
     ApplymodelonImage(picimg.path);
    });
  }

  //loading the model
  loadMyModel() async{
    Tflite.close();
    var resultant = await Tflite.loadModel(model: 'assets/flower_model.tflite',labels: 'assets/flower_labels.txt');
    print("Result after loading the model mobilenet: $resultant");
  }




  ApplymodelonImage(File file) async{
    var res = await Tflite.runModelOnImage(
        path:file.path,
        numResults: 2,
        threshold: 0.05,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _result=res!;
      // String str=_result[0]['label'];
      // _name=str.substring(2);
      // _confidence=_result!=null?(_result[0]['confidence']*100).toString().substring(0,4)+"%":"";
      // print("${_result[0]},:reslut1:${_result[1]},${_result[2]}");
   //   print(_result[0]);

      print(_result);
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
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobilw net Image Picker Example'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            isImageloaded
                ?Center(
              child: Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(picimg.path)),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
                :Container(),
            SizedBox(height: 50,),
             Center(child: Text("Result :$_name \n\n\nConfidence $_confidence")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),

    );
  }
}