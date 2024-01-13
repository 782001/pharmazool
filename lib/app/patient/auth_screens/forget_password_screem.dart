import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/app/patient/auth_screens/tap_patient_auth_screen.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';
import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';

class ConfirmPasswordPatientScreen extends StatelessWidget {
  const ConfirmPasswordPatientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phonecontroller = TextEditingController();

    var newpasswordcontroller = TextEditingController();
    var formkey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is AppResetPasswordSuccesState) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const TabBarScreen_patient()));
        showmydialog(context, 'تم تغيير كلمة المرور', Icons.lock_open);
      }
      if (state is AppResetPasswordErrorState) {
        showmydialog(context, 'رقم الهاتف غير صحيح', Icons.warning);
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const AutoSizeText(
            "تأكيد رقم الهاتف ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 19,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    ': تأكيد ثم ادخال رقم الهاتف الجديد ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: phonecontroller,
                      cursorColor: Colors.lightBlue,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.numbers,
                          color: Colors.black,
                        ),
                        labelText:"أدخل رقم الهاتف",
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: AppColors.PharmaColor),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: AppColors.PharmaColor),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const SizedBox(height: 50),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: newpasswordcontroller,
                      cursorColor: Colors.lightBlue,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'كلمة المرور غير مسجلة';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password_sharp,
                          color: Colors.black,
                        ),
                        labelText:"أدخل رقم الهاتف الجديد",
                        labelStyle: const TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: AppColors.PharmaColor),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: AppColors.PharmaColor),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            AppCubit.get(context).resetPassword(
                                phonenumber: phonecontroller.text,
                                password: newpasswordcontroller.text,
                                licenceId: '',
                                type: 1);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                          color: AppColors.PharmaColor,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 65,
                          ),
                          child: const Text(
                            'تأكيد',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
