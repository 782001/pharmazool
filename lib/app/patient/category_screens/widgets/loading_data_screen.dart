import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmazool/app/patient/category_screens/pharmasy_screen.dart';
import 'package:pharmazool/constants_widgets/main_widgets/loadingwidget.dart';

class loadingData extends StatefulWidget {
  const loadingData({
    super.key,
  });

  @override
  _loadingDataState createState() => _loadingDataState();
}

class _loadingDataState extends State<loadingData> {
  late Timer timer;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  statrDelay() {
    timer = Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PharmasyScreen()),
              // (Route<dynamic> route) => false,
            )
        // () => router.navigateTo(
        //   context,
        //   '${AppRouts.places_detailesScreenRoute}?index=${widget.index}',
        // ),
        );
  }

  @override
  void initState() {
    super.initState();
    statrDelay();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: Scaffold(
        body:
            // Center(
            //   child: CircleAvatar(
            //     radius: 70,
            //     backgroundColor: Colors.amber,
            //   ),
            // ),
            Center(
          child: loading(),
        ),
      ),
    );
  }
}
