import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class DoctorForgetButton extends StatelessWidget {
  final GlobalKey<FormState> forgetKey;
  final TextEditingController phoneController;
  final TextEditingController newPasswordController;
  final TextEditingController licenseController;
  final TextEditingController pharmacyNameController;

  const DoctorForgetButton({
    super.key,
    required this.forgetKey,
    required this.licenseController,
    required this.newPasswordController,
    required this.phoneController,
    required this.pharmacyNameController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppStates>(
      listener: (context, state) {
        // if (state is AppResetPasswordSuccesState) {
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => const TabBarScreen_patient()));
        //   showmydialog(context, 'تم تغيير كلمة المرور', Icons.lock_open);
        // }
        // if (state is AppResetPasswordErrorState) {
        //   showmydialog(context, 'رقم الهاتف غير صحيح', Icons.warning);
        // }
      },
      child: Align(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            if (forgetKey.currentState!.validate()) {
              AppCubit.get(context).resetByDoctorPassword(context: context,
                phonenumber: phoneController.text,
                newPassword: newPasswordController.text,
                licenceId: licenseController.text,
                pharmacyName: pharmacyNameController.text,
             
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.PharmaColor,
                borderRadius: BorderRadius.circular(12.0)),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 90),
            child: const Text(
              'تأكيد',
              style: TextStyles.styleWhite18,
            ),
          ),
        ),
      ),
    );
  }
}
