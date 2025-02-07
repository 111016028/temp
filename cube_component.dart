import 'package:flutter/material.dart';
import '../cube_constants.dart';
import 'package:cy_cube/components/cube_face.dart';
import 'dart:math';

class CubeComponent extends StatelessWidget {
  List<Widget>? cubeFaces;
  Map<Facing, Widget> cubeElements = {};
  Map<Facing, Color> cubeColor;
  List<int>? cubeFaceIndex;
  List<Widget>? cubeFaceInStack;

  CubeComponent({
    super.key,
    required this.cubeColor,
    this.cubeFaces,
    this.cubeFaceIndex,
  }) {
    if (cubeFaces == null) {
      // print('use default cubeFaces');
      cubeFaces = [];
      cubeFaceInStack = [];
      cubeElements = {
        Facing.top: CubeFace(
          transform: Matrix4.identity()
            ..translate(0.0, 0.0, -cubeWidth)
            ..rotateX(pi / 2),
          color: cubeColor[Facing.top]!,
        ),
        Facing.down: CubeFace(
          transform: Matrix4.identity()
            ..translate(0.0, cubeWidth, -cubeWidth)
            ..rotateX(pi / 2),
          color: cubeColor[Facing.down]!,
        ),
        Facing.left: CubeFace(
          transform: Matrix4.identity()
            ..translate(0.0, 0.0, -cubeWidth)
            ..rotateY(-pi / 2),
          color: cubeColor[Facing.left]!,
        ),
        Facing.right: CubeFace(
          transform: Matrix4.identity()
            ..translate(cubeWidth, 0.0, -cubeWidth)
            ..rotateY(-pi / 2),
          color: cubeColor[Facing.right]!,
        ),
        Facing.front: CubeFace(
          transform: Matrix4.identity()..translate(0.0, 0.0, 0.0),
          color: cubeColor[Facing.front]!,
        ),
        Facing.back: CubeFace(
          transform: Matrix4.identity()..translate(0.0, 0.0, -cubeWidth),
          color: cubeColor[Facing.back]!,
        ),
      };
      cubeFaces!.add(cubeElements[Facing.back]!);
      cubeFaces!.add(cubeElements[Facing.down]!);
      cubeFaces!.add(cubeElements[Facing.left]!);
      cubeFaces!.add(cubeElements[Facing.right]!);
      cubeFaces!.add(cubeElements[Facing.top]!);
      cubeFaces!.add(cubeElements[Facing.front]!);
      cubeFaceIndex = [0, 1, 2, 3, 4, 5];
      cubeFaceInStack = List<Widget>.from(cubeFaces!);
    } else {
      // print('use custom cubeFaces');
      cubeFaceInStack = [];
      for (int index in cubeFaceIndex!) {
        cubeFaceInStack!.add(cubeFaces![index]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: cubeFaces!,
    );
  }
}
