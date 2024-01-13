import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class PatientHomeAppBar {
  AppBar patientLayoutAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      elevation: 0,
      title: const AutoSizeText(
        "الرئيسية",
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
}
