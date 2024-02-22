import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/src/core/network/local/cashhelper.dart';
import 'package:pharmazool/src/core/utils/strings.dart';
import 'package:pharmazool/src/core/utils/styles.dart';
import 'package:pharmazool/src/features/on_boarding/patient_doctor_screen.dart';
import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import '../../../constants_widgets/utils/app_theme_colors.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

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
                  fit: BoxFit.fill,
                ),
              ),
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
                child: Column(
                  children: [
                    SizedBox(height: context.height * 0.05),
                    const AutoSizeText(
                      'اهلا بيك في فارمازول',
                      style: TextStyles.stylewhitebold30,
                    ),
                    SizedBox(
                      height: context.height * 0.2,
                    ),
                    Container(
                      width: context.width * 0.3,
                      // height: context.height * .25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white30,
                      ),
                      child: TextButton(
                          onPressed: ()  {
                            Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const PatientDoctorScreen();
        }),
        (Route<dynamic> route) => false,
      );
                         
                          },
                          child: const AutoSizeText(
                            'البدء',
                            style: TextStyles.styleWhiteBold15,
                          )),
                    ),
                    SizedBox(
                      height: context.height * 0.07,
                    ),
                    const AutoSizeText(
                      'دليلك الاول للصيدليات فالسودان',
                      style: TextStyles.styleWhiteBold15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
    );
  }
}
