import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class DoctorForgetBody extends StatelessWidget {
  DoctorForgetBody({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pharmacyNameController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // const Text(
              //   ': تأكيد ثم ادخال كلمة مرور جديده',
              //   textAlign: TextAlign.right,
              //   style: TextStyles.styleblackBold18,
              // ),
              const SizedBox(height: 50),
              CustomForgetTextField(
                controller: phoneController,
                labelText: ' رقم الهاتف',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "قم بإدخال رقم الهاتف المربوط بالحساب";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomForgetTextField(
                controller: licenseController,
                labelText: "رقم الرخصة",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "ادخل رقم رخصة الصيدلية";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomForgetTextField(
                controller: pharmacyNameController,
                labelText: "اسم الصيدلية",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "ادخل اسم الصيدلية";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomForgetTextField(
                controller: newPasswordController,
                labelText: "كلمة المرور الجديدة",
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'كلمة المرور غير مسجلة';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 25),
              DoctorForgetButton(
                pharmacyNameController: pharmacyNameController,
                forgetKey: formKey,
                licenseController: licenseController,
                newPasswordController: newPasswordController,
                phoneController: phoneController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
