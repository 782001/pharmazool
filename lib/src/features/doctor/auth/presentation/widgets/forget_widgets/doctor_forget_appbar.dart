import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class DoctorForgetAppBar {
  AppBar doctorForgetAppBar() => AppBar(
        elevation: 0,
        title: const AutoSizeText(
          "أستعادة كلمة المرور",
                          style: TextStyles.styleblack19,
                      
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      );
}
