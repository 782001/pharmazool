import 'package:flutter/material.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class ConfirmEdit extends StatelessWidget {
  final String loc;
  final String link;
  final String phone;
  final String time;
  final String licence;
  const ConfirmEdit(
      {super.key,
      required this.loc,
      required this.link,
      required this.phone,
      required this.time,
      required this.licence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const SizedBox(),
        elevation: 0,
      ),
      body: Column(children: [
        Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                  width: double.infinity,
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                link,
                                style: TextStyles.styleellipsisbold18,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const Text(
                              ':موقع الصيدلية',
                              style: TextStyles.styleblackbold25,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                loc,
                                style: TextStyles.styleblackBold18,
                              ),
                            ),
                            const Text(
                              ':رابط الخدمات',
                              style: TextStyles.styleblackbold25,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                phone,
                                style: TextStyles.styleblackBold18,
                              ),
                            ),
                            const Text(
                              ':رقم التليفون',
                              style: TextStyles.styleblackbold25,
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text(
                        //         time,
                        //         style: const TextStyle(
                        //             fontSize: 18, fontWeight: FontWeight.bold),
                        //       ),
                        //     ),
                        //     const Text(
                        //       ':مواعيد العمل',
                        //       style: TextStyle(
                        //           fontSize: 25, fontWeight: FontWeight.bold),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                licence,
                                style: TextStyles.styleblackBold18,
                              ),
                            ),
                            const Text(
                              ':رقم الرخصة',
                              style: TextStyles.stylewhitebold25,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            )),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.teal,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: const Text(
                      "تعديل",
                      style: TextStyles.stylewhitebold20,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    AppCubit.get(context).updatepharmacy(
                        int.parse(pharmamodel!.id.toString()),
                        link,
                        loc,
                        phone,
                        licence,
                        context);
                  },
                  color: Colors.teal,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: const Text(
                      "حفظ",
                      style: TextStyles.stylewhitebold20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
