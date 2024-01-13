import 'package:flutter/material.dart';
import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';

class WhoAreScreen extends StatelessWidget {
  const WhoAreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "من نحن",
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
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/who_are_us.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child:const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                SizedBox(height: 20),
                Text(
                  '"مرحبا بك',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "من اجل تحسين الخدمة الصحية و رفع الامكانيات",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "نقدم فارمازول هو صديق لمساعدة الصيدلي للوصول الى اقصى قدرة اداة  ممكنه وتوفير الوقت والمجهود",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "الهدف من فارمازول",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "تم انساء فارمازول بغرض مساعدة المرضى وتوجيههم الى اقرب صيدلية تتوفر فيها حوجتهم.",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),     Text(
                  "اضافة الى مساعدة كل صيدلي في ادارة الصيدلية باقل مجهود ودقة عاليه وحفظ الوقت الضائع.",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'قريب من البيت , قريب للقلب.',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
        ),
      );




  }
}
