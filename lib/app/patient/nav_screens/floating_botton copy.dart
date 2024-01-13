import 'package:flutter/material.dart';
import 'package:pharmazool/app/patient/nav_screens/barcode.dart';

import '../../../constants_widgets/utils/assets_images_path.dart';

class FloatingBottonPatient extends StatelessWidget {
  const FloatingBottonPatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BarCode()));
      },
      child: Image.asset(
         scan,
        color: Colors.black,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
