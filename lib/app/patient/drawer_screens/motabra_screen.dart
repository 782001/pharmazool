import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MotabraScreen extends StatelessWidget {
  const MotabraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "المتبرع",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'ما تعتبره علاجًا مكررًا غير مهمًا هو الامل الوحيد لغيرك  للشفاء والتعافي. فكر مرتين قبل رمي الأدوية وكن سببًا في إنقاذ حياة شخص آخر.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'ساهم من خلال فارمازول في ايصال او طلب المساعده عن طريق الاسفل:',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        launch('https://wa.me/message/SZRZTEI2JDTKO1');
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      elevation: 0.0,
                      minWidth: 200.0,
                      height: 80,
                      color: Colors.blue.withOpacity(0.7),
                      child: const Text(
                        'متبرع',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      onPressed: () {
                        launch('https://wa.me/message/44A3HSYVGXONI1');
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      elevation: 0.0,
                      minWidth: 200.0,
                      height: 80,
                      // color: Colors.grey[200]!.withOpacity(0.6),
                      color: Colors.blue.withOpacity(0.7),
                      child: const Text(
                        'ذوي الحاجة',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
