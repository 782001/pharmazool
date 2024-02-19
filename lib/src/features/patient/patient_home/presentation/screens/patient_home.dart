import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:flutter/material.dart';

// import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientHomeAppBar().patientLayoutAppBar(),
      endDrawer: const PatientDrawer(),
      backgroundColor: Colors.white,
      body: const ShowWidget(child: PatientHomeBody()),
      extendBody: true,
    );
  }
}
