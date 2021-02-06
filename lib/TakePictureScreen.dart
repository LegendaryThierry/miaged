import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:miaged/NewPost.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

// Widget permettant à un utilisateur de prendre une photo
class TakePictureScreen extends StatefulWidget {
  CameraDescription camera;
  final ValueChanged<String> update;
  TakePictureScreen({this.update});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}


class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  Future<void> initCamera() async{
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    widget.camera = firstCamera;

    // To display the current output from the Camera,
    // create a CameraController.
    print("_CONTROLLER");
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prendre une photo')),

      body: FutureBuilder<void>(
        //Nous affichons un CircularProgressIndicator en attendant que le Controller soit initialisé
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            //Création du chemin sur le smartphone de l'utilisateur où sera enregistré la photo
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            //Enregistrement de la photo à l'endroit spécifié
            await _controller.takePicture(path);

            //Retour sur l'écran précédent et affichage de la photo
            Navigator.pop(context);
            widget.update(path);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}