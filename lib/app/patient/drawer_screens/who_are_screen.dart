import 'package:flutter/material.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class WhoAreScreenPatient extends StatelessWidget {
  const WhoAreScreenPatient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "من نحن",
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/who_are_us.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(
            left: 6,
            right: 6,
            top: 4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        '"مرحبا بك',
                        style: TextStyles.stylewhite35,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '.فارمازول اول تطبيق سوداني يوفر المستخدمين مقدرة الوصول الي العلاج المطلوب في اسرع وقت و دون اي مجهود يذكر.',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyles.stylewhite20,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'هدفنا تطوير مستقبل العلاج فالسودان وتسهيل عملية الوصول الي الادوية و الاحتياجات الطبية دون الحوجة الي البحث الميداني وتضيع الوقت.',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyles.stylewhite20,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'لاننا نؤمن ان حق العلاج من ابسط حقوق المواطن.',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyles.stylewhite20,
                      ),
                      SizedBox(height: 180),
                      Text(
                        'قريب من البيت , قريب للقلب.',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyles.stylewhite20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
