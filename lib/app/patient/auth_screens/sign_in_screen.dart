import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/app/patient/auth_screens/forget_password_screem.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';
import 'package:pharmazool/constants_widgets/main_widgets/loadingwidget.dart';
import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';
import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import 'package:pharmazool/src/core/constant/app_constant.dart';
import 'package:pharmazool/src/core/constant/pop_up.dart';
import 'package:pharmazool/src/core/network/local/cashhelper.dart';
import 'package:pharmazool/src/core/utils/styles.dart';
import 'package:pharmazool/src/features/patient/patient_home/presentation/widgets/show_widget.dart';
import 'package:pharmazool/src/features/patient/patient_layout/presentation/screens/patient_layout.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PatientSignin extends StatefulWidget {
  const PatientSignin({super.key});

  @override
  State<PatientSignin> createState() => _PatientSigninState();
}

class _PatientSigninState extends State<PatientSignin> {
  bool isloading = false;
  var namEController = TextEditingController();
  var phonEController = TextEditingController();
  String patientName = '';
  String patientPhone = '';
  late final LocalAuthentication auth;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    getConnectivity();
    loadPatientData();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() {
              isAlertSet = true;
            });
          }
        },
      );
  void loadPatientData() async {
    patientName =
        await secureStorage.read(key: SecureStorageKey.patientName) ?? '';
    patientPhone =
        await secureStorage.read(key: SecureStorageKey.patientPhone) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is PatientLoginSuccesState) {
          setState(() {
            isloading = false;
          });
          CashHelper.SaveData(
            key: 'uId',
            value: state.uId,
          ).then((value) {
            print("uId Saved succses");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                return const ShowWidget(
                  child: PatientLayout(
                    fromOnBoard: false,
                  ),
                );
              }),
              (Route<dynamic> route) => false,
            );
          });
        }
        // if (state is PatientLoginErrorState) {
        //   setState(() {
        //     isloading = false;
        //   });
        // }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
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
                        return 'الاسم غير مسجل ';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.PharmaColor,
                        ),
                        labelText: 'ادخل الاسم',
                        labelStyle: TextStyles.styleblackDefault),
                  ),
                  SizedBox(
                    height: context.height * 0.04,
                  ),
                  SizedBox(
                    width: context.width * 1,
                    child: TextFormField(
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
                            Icons.numbers,
                            color: AppColors.PharmaColor,
                          ),
                          labelText: 'ادخل رقم الهاتف',
                          labelStyle: TextStyles.styleblackDefault),
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ConfirmPasswordPatientScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "تعديل رقم الهاتف",
                          style: TextStyles.styleblackBold15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: context.height * 0.04,
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
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  Future.delayed(
                                          const Duration(milliseconds: 1))
                                      .then((value) {
                                    AppCubit.get(context).Patientlogin(
                                        context: context,
                                        username: namEController.text,
                                        password: phonEController.text);
                                  }).then((value) {
                                    setState(
                                      () {
                                        isloading = false;
                                      },
                                    );
                                  });

                                  if (patientName.isEmpty &&
                                      patientPhone.isEmpty) {
                                    await secureStorage.write(
                                        key: SecureStorageKey.patientName,
                                        value: namEController.text);
                                    await secureStorage.write(
                                        key: SecureStorageKey.patientPhone,
                                        value: phonEController.text);
                                  }
                                }
                              },
                              child: const AutoSizeText(
                                'تسجيل الدخول',
                                style: TextStyles.styleWhiteBold15,
                              ),
                            ),
                          ),
                        ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () async {
                        if (patientPhone.isEmpty && patientPhone.isEmpty) {
                          flutterToast(msg: "Please Sign First");
                        } else {
                          if (await _authenticate() == true) {
                            // ignore: use_build_context_synchronously
                               AppCubit.get(context).Patientlogin(
                                        context: context,
                                        username: patientName,
                                        password:patientPhone);
                                        
                          } else {
                            flutterToast(msg: "Not Recognized");
                          }
                        }
                      },
                      child: Image.asset("assets/images/fingerprint_image.jpg",
                          height: size.height * 0.2, width: size.width * 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason:
            'Subcribe or you will never find any stack overflow answer',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print("Authenticated : $authenticated");
      return authenticated;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  void showDialogBox() => showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text(
            'لا يوجد اتصال بالإنترنت',
            style: TextStyles.styleblack20,
          ),
          content: const Text(
            'من فضلك تحقق من الاتصال بالإنترنت',
            style: TextStyles.styleblack20,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context, "الغاء");
                setState(() {
                  isAlertSet = false;
                });
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected) {
                  showDialogBox();
                  setState(() {
                    isAlertSet = true;
                  });
                }
              },
              child: const Text(
                'تأكيد',
                style: TextStyles.styleblack20,
              ),
            )
          ],
        ),
      );
}
