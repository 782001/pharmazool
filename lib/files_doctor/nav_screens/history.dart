import 'package:flutter/material.dart';

import 'package:pharmazool/app/doctor/model/itemWidget.dart';
import 'package:pharmazool/app/patient/nav_screens/barcode.dart';
import 'package:pharmazool/src/features/patient/patient_home/presentation/screens/patient_home.dart';

import 'package:pharmazool/constants_widgets/main_widgets/catalog-model.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  goToIndexPage(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const PatientHome();
        }),
        (Route<dynamic> route) => false,
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const History();
        }),
        (Route<dynamic> route) => false,
      );
    } else if (index == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const BarCode();
        }),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "History",
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
          itemCount: CatalogModel.items.length,
          itemBuilder: (context, index) {
            return ItemWidget(item: CatalogModel.items[index]);
          }),
    );
  }
}
