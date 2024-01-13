import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';

import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import 'package:pharmazool/constants_widgets/main_widgets/loadingwidget.dart';

import '../../../constants_widgets/utils/app_theme_colors.dart';

class DoctorSignUp extends StatefulWidget {
  const DoctorSignUp({super.key});

  @override
  State<DoctorSignUp> createState() => _DoctorSignUpState();
}

class _DoctorSignUpState extends State<DoctorSignUp> {
  bool isloading = false;
  var useRController = TextEditingController();
  var passwordController = TextEditingController();
  var phonecontroller = TextEditingController();
  var licencecontroller = TextEditingController();
  var pharmacynamecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is DoctorRegisterSuccesState) {
          setState(() {
            isloading = false;
          });
        }
        if (state is DoctorRegisterErrorState) {
          setState(() {
            isloading = false;
          });
        }
      },
      builder: ((context, state) {
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.height * 0.05,
                ),
                TextFormField(
                  controller: useRController,
                  keyboardType: TextInputType.text,
                  onTap: () {},
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return ' الرجاء ادخال الاسم';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors.PharmaColor,
                    ),
                    labelText: 'اسم المستخدم',
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                TextFormField(
                  controller: licencecontroller,
                  keyboardType: TextInputType.number,
                  onTap: () {},
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return ' رقم الصيدلية غير مسجل';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.numbers,
                      color: AppColors.PharmaColor,
                    ),
                    labelText: 'رقم الرخصة',
                  ),
                ),
                //pharm name
                const SizedBox(
                  height: 2,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: pharmacynamecontroller,
                  onTap: () {},
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'اسم الصيدلية غير مسجل';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.PharmaColor,
                    ),
                    labelText: 'اسم الصيدلية',
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(5),
                    // )
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                SizedBox(
                  width: context.width * 1,
                  child: TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    onTap: () {},
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'الرجاء ادخال كلمة المرور ';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_outlined,
                        color: AppColors.PharmaColor,
                      ),
                      labelText: 'كلمة المرور',
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(5),
                      // )
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: context.width * 1,
                  child: TextFormField(
                    controller: phonecontroller,
                    keyboardType: TextInputType.phone,
                    onTap: () {},
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'الرجاء ادخال رقم التليفون';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColors.PharmaColor,
                      ),
                      labelText: 'رقم التليفون',
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),

                SizedBox(
                  height: context.height * 0.07,
                ),
                isloading
                    ? loading()
                    : Center(
                        child: Container(
                          width: context.width * 0.5,
                          // height: context.height * .25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.PharmaColor,
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                AppCubit.get(context).doctorRegister(
                                  username: useRController.text,
                                  phone: phonecontroller.text,
                                  password: passwordController.text,
                                  type: 0,
                                  pharmacyName: pharmacynamecontroller.text,
                                  licenceId: licencecontroller.text,
                                  context: context,
                                );
                              }
                            },
                            child: const AutoSizeText(
                              'انشاء حساب',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
