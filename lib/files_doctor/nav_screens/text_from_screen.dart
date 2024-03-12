import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';
import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';
import 'package:pharmazool/files_doctor/nav_screens/receipt_screen.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class ScannedTextDoctor extends StatelessWidget {
  const ScannedTextDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    var doctorsearchcontroller = TextEditingController(
        text: AppCubit.get(context).doctorSearcher.toString());
    print(AppCubit.get(context).doctorSearcher);

    List<String> doctorNewValueSearcher = [''];
    bool changed = false;
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[800],
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  AppCubit.get(context).searcher = '';
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: Colors.grey[800],
            body: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'في حالة الضغط علي تحديث الكل سيقوم فارمازول بتغيير حالة جميع الادوية التي قمت بأدخالها الي المتوفر',
                    style: TextStyles.stylewhiteBold18,
                    textAlign: TextAlign.end,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            style: TextStyles.stylewhiteDefault,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            readOnly: false,
                            controller: doctorsearchcontroller,
                            onChanged: (newValue) {
                              // Update the value of AppCubit.get(context).doctorSearcher here
                              // AppCubit.get(context).doctorSearcher = [newValue];
                              doctorNewValueSearcher = [newValue];
                              print(AppCubit.get(context).doctorSearcher);
                              print(newValue);
                              changed = true;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: AppColors.PharmaColor,
                          ),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const AutoSizeText(
                                ' الغاء',
                                style: TextStyles.styleblackBold15,
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: AppColors.PharmaColor,
                          ),
                          child: TextButton(
                              onPressed: () async {
                                List<String> doctorSearcherValue = changed
                                    ? doctorNewValueSearcher
                                    : AppCubit.get(context).doctorSearcher;

                                // Check if the value contains "[" or "]"
                                if (changed == true) {
                                  for (int i = 0;
                                      i < doctorSearcherValue.length;
                                      i++) {
                                    if (doctorSearcherValue[i].contains("[") ||
                                        doctorSearcherValue[i].contains("]")) {
                                      // Remove "[" and "]" from the value
                                      doctorSearcherValue[i] =
                                          doctorSearcherValue[i]
                                              .replaceAll("[", "")
                                              .replaceAll("]", "");
                                    }
                                  }

                                  // Update AppCubit.get(context).doctorSearcher with the modified value
                                  changed
                                      ? AppCubit.get(context).doctorSearcher =
                                          doctorSearcherValue
                                              .toString()
                                              .split(', ')
                                      : AppCubit.get(context).doctorSearcher;
                                }

                                // Rest of your logic
                                Map<String, dynamic> data;
                                data = await AppCubit.get(context)
                                    .updatepharmacymedicinelist(
                                        AppCubit.get(context).doctorSearcher,
                                        'ChangeStatusAllMedicineByPharmacyId');

                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ReceiptScreen(data);
                                }));
                              },
                              child: const AutoSizeText(
                                'حذف الادوية',
                                style: TextStyles.styleblackBold15,
                              )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: AppColors.PharmaColor,
                          ),
                          child: TextButton(
                              onPressed: () async {
                                List<String> doctorSearcherValue = changed
                                    ? doctorNewValueSearcher
                                    : AppCubit.get(context).doctorSearcher;

                                // Check if the value contains "[" or "]"
                                if (changed == true) {
                                  for (int i = 0;
                                      i < doctorSearcherValue.length;
                                      i++) {
                                    if (doctorSearcherValue[i].contains("[") ||
                                        doctorSearcherValue[i].contains("]")) {
                                      // Remove "[" and "]" from the value
                                      doctorSearcherValue[i] =
                                          doctorSearcherValue[i]
                                              .replaceAll("[", "")
                                              .replaceAll("]", "");
                                    }
                                  }

                                  // Update AppCubit.get(context).doctorSearcher with the modified value
                                  changed
                                      ? AppCubit.get(context).doctorSearcher =
                                          doctorSearcherValue
                                              .toString()
                                              .split(', ')
                                      : AppCubit.get(context).doctorSearcher;
                                }

                                Map<String, dynamic> data;
                                data = await AppCubit.get(context)
                                    .updatepharmacymedicinelist(
                                        AppCubit.get(context).doctorSearcher,
                                        'UpdateMedicineStateInPharmacy');
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ReceiptScreen(data);
                                }));
                              },
                              child: const AutoSizeText(
                                'اضافة الادوية',
                                style: TextStyles.styleblackBold15,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
