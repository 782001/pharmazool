import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class DoctorForgetAppBar {
  AppBar doctorForgetAppBar() => AppBar(
        elevation: 0,
        title: const AutoSizeText(
          "أستعادة كلمة المرور",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      );
}
