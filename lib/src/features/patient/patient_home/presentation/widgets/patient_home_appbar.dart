import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class PatientHomeAppBar {
  AppBar patientLayoutAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      elevation: 0,
      title: const AutoSizeText(
        "الرئيسية",
        style: TextStyles.styleblack19,
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
}
