import 'package:flutter/material.dart';
import 'package:pharmazool/src/core/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class MotabraScreen extends StatelessWidget {
  const MotabraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "المتبرع",
          style: TextStyles.styleblackbold20,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/motabra.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Text(
                      'فارمازول',
                      style: TextStyles.styleWhite40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'ما تعتبره علاجًا مكررًا غير مهمًا هو الامل الوحيد لغيرك  للشفاء والتعافي. فكر مرتين قبل رمي الأدوية وكن سببًا في إنقاذ حياة شخص آخر.',
                      textAlign: TextAlign.center,
                      style: TextStyles.stylewhite20,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'ساهم من خلال فارمازول في ايصال او طلب المساعده عن طريق الاسفل:',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyles.stylewhite22,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        launch('https://wa.me/201553550086');
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      elevation: 0.0,
                      minWidth: 200.0,
                      height: 80,
                      color: Colors.blue.withOpacity(0.7),
                      child: const Text('متبرع',
                          style: TextStyles.stylewhitebold25),
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      onPressed: () {
                        launch('https://wa.me/201553550086');
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      elevation: 0.0,
                      minWidth: 200.0,
                      height: 80,
                      // color: Colors.grey[200]!.withOpacity(0.6),
                      color: Colors.blue.withOpacity(0.7),
                      child: const Text('ذوي الحاجة',
                          style: TextStyles.stylewhitebold25),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
