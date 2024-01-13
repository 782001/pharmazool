import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';

import 'package:pharmazool/files_doctor/nav_screens/text_screen.dart';

class BarCodeDoctor extends StatelessWidget {
  const BarCodeDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
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
                                  await AppCubit.get(context).getPostImage2();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ScannedTextDoctor()));
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
                                  await AppCubit.get(context).getPostImage();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ScannedTextDoctor()));
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        await AppCubit.get(context).getPdfText();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ScannedTextDoctor()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.file_download),
                          AutoSizeText(
                            'import PdF',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
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
    });
  }
}
