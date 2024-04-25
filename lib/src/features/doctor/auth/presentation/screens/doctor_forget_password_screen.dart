import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class DoctorForgetPasswordScreen extends StatelessWidget {
  const DoctorForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorForgetAppBar().doctorForgetAppBar(),
      body: DoctorForgetBody(),
    );
  }
}
