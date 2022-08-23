import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import 'package:image_editor/image_editor.dart';
import 'package:skin_camera/pages/camera_screen.dart';
import 'package:image/image.dart' as img;
import 'package:skin_camera/pages/edit_photo.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _MyHomeScreenState();
}

const DEFAULT_TITLE = "Elija una opcion";

class _MyHomeScreenState extends State<HomeScreen> {
  File? imageFile;
  String title = DEFAULT_TITLE;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
              Positioned(
                width: 120,
                height: 60,
                top: 40,
                child: Column(
                  children: const [
                    Text("Eliga una opcion"),
                  ],
                )
              ),
              Positioned(
                width: 200,
                top: 100,
                child: Column(
                  children: [
                    if(imageFile != null) Image.file(imageFile!, width: 200, height: 200,),
                    ElevatedButton.icon(
                        onPressed: () async {
                          File? result;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CameraScreen(onTerminate: (File file) {
                              result = file;
                              Navigator.of(context).pop();
                            },))
                          );
                          if(!mounted || result == null) return;
                          File? resultFile = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditPhotoScreen(imageFile: result!))
                          );
                          if(resultFile != null) {
                            setState(() {
                              imageFile = resultFile;
                            });
                          }
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text("Tomar fotografia")
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles();
                          String? pathFile = result?.files.single.path;

                          if(result != null && pathFile !=null ) {
                            File? file = File(pathFile);
                            if(!mounted) return;

                            File? resultFile = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditPhotoScreen(imageFile: file))
                            );
                            if(resultFile != null) {
                              setState(() {
                                imageFile = resultFile;
                              });
                            }
                          } else {
                            debugPrint("Ocurrio un error");
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text("Seleccionar imagen")
                    ),
                    ElevatedButton.icon(
                      onPressed: imageFile != null ? () async {
                        final uri = Uri.parse('http://192.168.100.30:8000/fast-proxy/');
                        var request = http.MultipartRequest('POST', uri);
                        if(imageFile == null) return;
                        final httpImage = await http.MultipartFile.fromPath('file', imageFile!.path);
                        request.files.add(httpImage);
                        final response = await request.send();
                        final respStr =  await http.Response.fromStream(response);
                        if(response.statusCode == 200) {
                          final Map parsed = json.decode(respStr.body);
                          Widget okButton = TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          //var first = parsed.values.first;
                          debugPrint(parsed['prediction']);
                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Resutlado"),
                            content: Text(parsed['prediction']),
                            actions: [
                              okButton,
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );

                        }
                      } : null,
                      label: const Text("Detectar"),
                      icon: const Icon(Icons.upload),
                    )
                  ],
                ),
              )
          ],
        )
      ),
    );
  }
}
