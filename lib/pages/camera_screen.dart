import 'dart:io';

import 'package:camera/camera.dart';
import "package:flutter/material.dart";

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key,final this.onTerminate}) : super(key: key);

  final Function(File)? onTerminate;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  List<CameraDescription>? cameras;
  CameraController? controller;
  File? imageFile;
  int cameraIdx = 0;
  Future<void>? _initializeControllerFuture;

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) async {
      cameras = value;
      if(cameras == null) return;
      controller = CameraController(cameras![cameraIdx], ResolutionPreset.high);
      setState(() {
        _initializeControllerFuture = controller?.initialize();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(_initializeControllerFuture != null) FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if(snapshot.hasError) {
              return const Center(
                child: Text("Initialized Camera Failure"),
              );
            } else if (snapshot.connectionState == ConnectionState.done){
              return CameraPreview(controller!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        ),
        Positioned.fill(
            bottom: 10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Container(),
                  ),
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: RawMaterialButton(
                    onPressed: () async {
                      if(controller != null) {
                        XFile xfile = await controller!.takePicture();
                        File file = File(xfile.path);
                        if(widget.onTerminate != null) widget.onTerminate!(file);
                      }
                    },
                    elevation: 2.0,
                    fillColor: Colors.red,
                    shape: const CircleBorder(),
                    child: Container(),
                  ),
                ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: RawMaterialButton(
                    onPressed: () {
                      if(cameras !=null) {
                        int finalIdx;
                        CameraController newController;
                        if(cameraIdx == 0) {
                          finalIdx = 1;
                        } else {
                          finalIdx = 0;
                        }
                        newController = CameraController(cameras![finalIdx], ResolutionPreset.high);
                        setState(() {
                          _initializeControllerFuture = newController.initialize();
                          cameraIdx = finalIdx;
                          controller = newController;
                        });
                      }
                    },
                    elevation: 2.0,
                    fillColor: Colors.red,
                    shape: const CircleBorder(),
                    child:const Icon(Icons.flip_camera_android, color: Colors.white),
                  ),
                  )
                ],
                )
            ),


        )

      ],
    );
  }
}
