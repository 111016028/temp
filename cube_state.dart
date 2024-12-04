import 'dart:typed_data';

import 'package:cy_cube/cube/cube_controller/arrange_controller.dart';
import 'package:cy_cube/cube/cube_controller/extension_controller.dart';
import 'package:cy_cube/cube/cube_controller/rotation_controller.dart';
import 'package:cy_cube/cube/cube_controller/setup_controller.dart';
import 'package:cy_cube/cube/cube_view/cube_component.dart';
import 'package:cy_cube/cube/cube_model/single_cube_model.dart';
import 'package:cy_cube/cube/cube_model/single_cube_component_face_model.dart';
import 'package:cy_cube/cube/cube_constants.dart';
import 'package:cy_cube/components/single_cube_face.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';//
import 'dart:core';

import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class CubeState extends ChangeNotifier {
  GlobalKey boundaryKey = GlobalKey(); // 用於標記需要截圖的 RepaintBoundary

  static List<SingleCubeModel> cubeModels = [];
  static List<int> indexWithStack = [];

  double get cubeDx => ArrangeController.dx;

  double get cubeDy => ArrangeController.dy;

  final SetupController _setupController = SetupController();
  final RotationController _rotationController = RotationController();
  final ExtensionController _extensionController = ExtensionController();
  final ArrangeController _arrangeController = ArrangeController();

  CubeState() {
    initCubeState();
    notifyListeners();
  }

  void initCubeState() {
    cubeModels = [];
    indexWithStack = [];
    int id = 0;
    for (int z = -1; z < 2; z++) {
      for (int y = -1; y < 2; y++) {
        for (int x = -1; x < 2; x++) {
          cubeModels.add(
            SingleCubeModel(
              component: CubeComponent(
                cubeColor: Map.from(defaultCubeColor),
              ),
              x: x * cubeWidth,
              y: -y * cubeWidth,
              z: z * cubeWidth,
            ),
          );
          indexWithStack.add(id);
          id++;
        }
      }
    }
  }

  Future<void> rotate({required String rotation}) async {
    _rotationController.rotate(rotation: rotation);
    notifyListeners();

    // 截圖
    await captureCubeImage();
  }

  Color getColor({required String color}) {
    return _setupController.getColor(color);
  }

  void setupCubeWithScanningColor(
      List<List<SingleCubeComponentFaceModel>> cubeFaces) {
    _setupController.setupCubeWithScanningColor(cubeFaces);
    notifyListeners();
  }

  List<String> generateCubeStatus() {
    return _setupController.generateCubeStatus();
  }

  Future<void> setCubeStatus({required List<String> cubeStatus}) async {
    _setupController.setCubeStatus(cubeStatus: cubeStatus);
    notifyListeners();

    // 截圖
    await captureCubeImage();
  }

  SingleCubeFace show2DFace({required Facing facing}) {
    return _extensionController.show2DFace(facing: facing);
  }

  void listenToArrange({required DragUpdateDetails detail}) {
    _arrangeController.listenToArrange(detail: detail);
    notifyListeners();
  }

  Future<void> captureCubeImage() async {
    RenderRepaintBoundary boundary =
    boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    // 將畫面轉為圖片
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    // 儲存圖片到檔案系統（需引入 path_provider 和 permission_handler 套件）
    // final directory = await getApplicationDocumentsDirectory();
    // final imagePath = '${directory.path}/cube_image_${DateTime.now().millisecondsSinceEpoch}.png';
    // final file = File(imagePath);
    // await file.writeAsBytes(byteData!.buffer.asUint8List());
    // print("Image saved at: $imagePath");

    //test
    if (byteData != null) {
      final directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      final imagePath = '${directory.path}/cube_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      print("Image saved at: $imagePath");
    }

  }

}
