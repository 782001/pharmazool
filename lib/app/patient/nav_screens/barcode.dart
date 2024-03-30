import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app/patient/search_screen/search_screen_patient.dart';

import 'package:pharmazool/src/core/utils/styles.dart';

class BarCode extends StatefulWidget {
  const BarCode({super.key});

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
                              child: const Row(
                                children: [
                                  Icon(Icons.file_download),
                                  AutoSizeText(
                                    'Scan File',
                                    style: TextStyles.styleblackBold15,
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
                              child: const Row(
                                children: [
                                  Icon(Icons.file_download),
                                  AutoSizeText(
                                    'Choose File',
                                    style: TextStyles.styleblackBold15,
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
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "لتقليل نسبة الخطأ وحفظ الوقت والجهد يمكنك اضافة الادوية عن طريق الماسح الضوئي اعلاه",
                  style: TextStyles.styleblack15,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}
