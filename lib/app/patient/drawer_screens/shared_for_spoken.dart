import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedForSpokenPatient extends StatelessWidget {
  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController positionController = TextEditingController();

  TextEditingController explainYourProblemController = TextEditingController();

  GlobalKey<FormState> reportKey = GlobalKey<FormState>();

  SharedForSpokenPatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  color: AppColors.PharmaColor),
              child: const Padding(
                padding: EdgeInsets.only(right: 20, top: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'في فارمازول',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                        "نقوم بتطوير خدماتنا وتحسينها بناءً على مقترحاتكم شاركنا رايك واقتراحك واجعل صوتك مسموعاً",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.end)
                  ],
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        launch(
                            'https://www.facebook.com/profile.php?id=100068365090281&mibextid=LQQJ4d');
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                        size: 100,
                      ),
                    ),
                    const FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Colors.redAccent,
                      size: 100,
                    ),
                  ],
                ),
              ),
            )
            // SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
