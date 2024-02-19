import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';
import 'package:pharmazool/constants_widgets/main_widgets/loadingwidget.dart';
import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';
import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class PatientRegister extends StatefulWidget {
  const PatientRegister({super.key});

  @override
  State<PatientRegister> createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    var namEController = TextEditingController();
    var locatioNController = TextEditingController();
    var agEController = TextEditingController();
    var phonEController = TextEditingController();
    var formkey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is AppRegisterSuccesState) {
        showmydialog(context, 'تم انشاء الحساب بنجاح', Icons.warning);
        setState(() {
          isloading = false;
        });
      }
      if (state is AppRegisterErrorState) {
        setState(() {
          isloading = false;
        });
      }
    }, builder: (context, state) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.height * 0.1,
                ),
                TextFormField(
                  controller: namEController,
                  keyboardType: TextInputType.name,
                  onTap: () {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ' الاسم غير مسجل';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.PharmaColor,
                      ),
                      labelText: 'ادخل اسمك',
                      labelStyle: TextStyles.styleblackDefault),
                ),
                const SizedBox(
                  height: 1,
                ),
                TextFormField(
                  controller: phonEController,
                  keyboardType: TextInputType.number,
                  onTap: () {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'رقم الهاتف غير مسجل';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColors.PharmaColor,
                      ),
                      labelText: 'ادخل رقم الهاتف',
                      labelStyle: TextStyles.styleblackDefault),
                ),
                const SizedBox(
                  height: 1,
                ),
                TextFormField(
                  controller: agEController,
                  keyboardType: TextInputType.number,
                  onTap: () {},
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'العمر غير مسجل';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.numbers,
                        color: AppColors.PharmaColor,
                      ),
                      labelText: 'ادخل العمر ',
                      labelStyle: TextStyles.styleblackDefault),
                ),
                SizedBox(
                  width: context.width * 1,
                  child: TextFormField(
                    controller: locatioNController,
                    keyboardType: TextInputType.name,
                    onTap: () {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'الموقع غير صحيح';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: AppColors.PharmaColor,
                        ),
                        labelText: 'ادخل موقعك',
                        labelStyle: TextStyles.styleblackDefault),
                  ),
                ),
                SizedBox(
                  height: context.height * 0.07,
                ),
                isloading
                    ? loading()
                    : Center(
                        child: Container(
                          width: context.width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.PharmaColor,
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                AppCubit.get(context).patientRegister(
                                    username: namEController.text.toString(),
                                    password: 'no password',
                                    phone: phonEController.text,
                                    type: 1);
                              }
                            },
                            child: const AutoSizeText(
                              'إنشاء حساب',
                              style: TextStyles.styleWhiteBold15,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
