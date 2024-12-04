import 'package:flutter/material.dart';
import 'package:cy_cube/cube/cube_view/cube.dart';
import 'package:cy_cube/components/cube_rotation_table.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:cy_cube/cube/cube_constants.dart';
import 'package:cy_cube/cube/cube_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CubePage extends StatelessWidget {
  CubePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: Provider.of<CubeState>(context, listen: false).boundaryKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform(
            origin: const Offset(0, 0),
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(Provider.of<CubeState>(context).cubeDy * pi / 180)
              ..rotateY(Provider.of<CubeState>(context).cubeDx * pi / 180)
              ..setEntry(2, 2, 0.001),
            child: Cube(), // 方塊視圖
          ),
          const Gap(20),
          CubeRotationTable(
            onPressed: (rotation) {
              Provider.of<CubeState>(context, listen: false)
                  .rotate(rotation: rotation);
            },
          ),
          const Gap(20),
          MaterialButton(
            onPressed: () {
              Provider.of<CubeState>(context, listen: false).captureCubeImage();
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: const Text("Capture Cube Image"),
          ),
        ],
      ),
    );
  }
}
