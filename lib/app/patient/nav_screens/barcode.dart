import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';
import 'package:pharmazool/app/patient/search_screen/search_screen_patient.dart';

import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';

import 'BottomNavBarWidget.dart';
import '../../../files_doctor/nav_screens/floating_botton.dart';

class BarCode extends StatefulWidget {
  const BarCode({Key? key}) : super(key: key);

  @override
  _BarCodeState createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String search = '';
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                String updatedSearch =
                                    await AppCubit.get(context)
                                        .getImageForSeacrhPatient();
                                if (updatedSearch.isNotEmpty) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SearchScreenPatient(
                                        search: updatedSearch,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.file_download),
                                  AutoSizeText(
                                    'Scan File',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                String updatedSearch =
                                    await AppCubit.get(context)
                                        .getGalleryImageForPatientSearch();
                                if (updatedSearch.isNotEmpty) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SearchScreenPatient(
                                        search: updatedSearch,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.file_download),
                                  AutoSizeText(
                                    'Choose File',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Image(image: AssetImage('assets/images/scan.jpg')),
              ),
              const Text(
                'لتقليل نسبة الخطأ و حفظ الوقت و الجهد يمكنك البحث عن طريق الماسح الضوئي باستخدام صورة من الوسائط او الكاميرا',
                style: TextStyle(color: Colors.black, fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }
}
