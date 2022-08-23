import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_editor/image_editor.dart';
import 'package:skin_camera/constants/app_colors.dart';
import 'package:skin_camera/theme_provider.dart';
import 'package:uuid/uuid.dart';


class EditPhotoScreen extends StatefulWidget {
  final File imageFile;
  const EditPhotoScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<EditPhotoScreen> createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();
  late final File imageFile;
  @override
  void initState() {
    super.initState();
    imageFile = widget.imageFile;
  }

  Future<File?> crop([bool test = false]) async {
    final Uint8List? result;
    final ExtendedImageEditorState? state = editorKey.currentState;
    final Rect? rect = state?.getCropRect();
    // final EditActionDetails? action = state?.editAction;
    if(rect != null && state != null) {
      final Uint8List img = state.rawImageData;

      final ImageEditorOption option = ImageEditorOption();
      option.addOption(ClipOption.fromRect(rect));
      option.outputFormat = const OutputFormat.jpeg(90);
      debugPrint(const JsonEncoder.withIndent('  ').convert(option.toJson()));
      result = await ImageEditor.editImage(
        image: img,
        imageEditorOption: option,
      );

    } else {
      debugPrint("Ocurrio un error");
      return null;
    }
    File? resultFile;
    if(result != null) {
      var newName = const Uuid().v4();
      resultFile = await DefaultCacheManager().putFile(newName, result, fileExtension: 'jpg');
    }
    return resultFile;
  }

  Widget buildImage(BuildContext context){
    return ExtendedImage(
      image: ExtendedFileImageProvider(widget.imageFile, cacheRawData: true),
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.contain,
      extendedImageEditorKey: editorKey,
      mode: ExtendedImageMode.editor,
      initEditorConfigHandler: (ExtendedImageState? state) {
        return EditorConfig(
          cropRectPadding: const EdgeInsets.all(20.0),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: buildFunctions(context),
      appBar: AppBar(
        title: const Text("Editar imagen"),
        actions: <Widget>[
          const IconButton(
            icon: Icon(Icons.refresh),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.crop),
            onPressed: () async {
              File? file = await crop();
              if(file != null ) {
                  if (!mounted) return;
                 Navigator.pop(context, file);
              };
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          //width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: 1,
                child: buildImage(context),
              )
          )
          ],
        )
      )
    )
    );
  }
}
