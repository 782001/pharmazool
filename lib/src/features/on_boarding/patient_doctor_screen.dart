import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/app/doctor/screens/tap_doctor_auth_screen.dart';
import 'package:pharmazool/app/patient/auth_screens/tap_patient_auth_screen.dart';
import 'package:pharmazool/constants_widgets/utils/assets_images_path.dart';
import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import 'package:pharmazool/src/core/network/local/cashhelper.dart';
import 'package:pharmazool/src/core/utils/strings.dart';
import 'package:pharmazool/src/core/utils/styles.dart';
import 'package:pharmazool/src/features/patient/patient_layout/presentation/screens/patient_layout.dart';

import '../../../constants_widgets/utils/app_theme_colors.dart';
import '../patient/patient_home/presentation/widgets/show_widget.dart';

class PatientDoctorScreen extends StatelessWidget {
  const PatientDoctorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: context.height * 0.40,
              width: context.width * 1,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(41),
                      bottomRight: Radius.circular(41)),
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo_11zon_low.png'),
                      fit: BoxFit.fill)),
            ),
            SizedBox(height: context.height * 0.01),
            Expanded(
              child: Container(
                width: context.width * 1,
                decoration: BoxDecoration(
                  color: AppColors.PharmaColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(41),
                      topRight: Radius.circular(41)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: context.height * 0.05),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              print("Token on Sign:$token");
                              if (token!.isNotEmpty) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowWidget(
                                      child: PatientLayout(),
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TabBarScreen_patient()));
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(patient,
                                    height: context.height * 0.2,
                                    width: context.height * 0.2),
                                SizedBox(
                                  height: context.height * 0.0035,
                                ),
                                const AutoSizeText(
                                  'مريض',
                                  style: TextStyles.styleWhite18,
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TabBarScreen_doctor()));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(doctor,
                                    height: context.height * 0.2,
                                    width: context.height * 0.2),
                                SizedBox(
                                  height: context.height * 0.0035,
                                ),
                                Container(
                                  child: const AutoSizeText(
                                    'صيدلي',
                                    style: TextStyles.styleWhite18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const AutoSizeText(
                        'قريب من المنزل, قريب للقلب',
                        style: TextStyles.styleWhite18,
                      ),
                      SizedBox(
                        height: context.height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // SearchBar(ScanWidget: ScanBarCode()),
            // SizedBox(
            //   height: context.height * 0.05,
            // ),
          ],
        ),
      ),
      extendBody: true,
    );
  }
}
