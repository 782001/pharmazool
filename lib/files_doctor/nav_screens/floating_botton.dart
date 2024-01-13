import 'package:flutter/material.dart';

import 'package:pharmazool/files_doctor/nav_screens/barcode.dart';

import '../../constants_widgets/utils/assets_images_path.dart';

class FloatingBotton extends StatelessWidget {
  const FloatingBotton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BarCodeDoctor()));
      },
      child: Image.asset(
        // cacheHeight: 20,
        scan,
        color: Colors.black,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
