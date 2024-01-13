import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class HeadSharedSpokenScreen extends StatelessWidget {
  const HeadSharedSpokenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: AppColors.PharmaColor),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'في فارمازول',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'نحن نهتم بكلماتك و نعمل علي تحسين خدماتنا بناء عليها, شاركنا رأيك و اجعل صوتك مسموعا',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
