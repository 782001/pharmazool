// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/constant/app_constant.dart';
import 'package:pharmazool/src/core/constant/pop_up.dart';
import 'package:pharmazool/src/core/utils/app_strings.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class DoctorSignin extends StatefulWidget {
  const DoctorSignin({super.key});

  @override
  State<DoctorSignin> createState() => _DoctorSigninState();
}

class _DoctorSigninState extends State<DoctorSignin> {
  bool isloading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  late final LocalAuthentication auth;
  bool _supportState = false;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
    loadKeys();
    getConnectivity();
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
  String doctorLicense = '';

  void loadKeys() async {
    doctorLicense =
        await secureStorage.read(key: SecureStorageKey.doctorLicense) ?? '';
    print(doctorLicense);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is DoctorLoginSuccesState) {
          setState(() {
            isloading = false;
          });
          print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv$state");
        }
        // if (state is DoctorLoginErrorState) {
        //   setState(() {
        //     isloading = false;
        //   });
        //   showmydialog(context, 'الحساب غير صحيح', Icons.warning);
        // }
      },
      builder: ((context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.height * 0.1),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (emailController) {
                      if (emailController!.isEmpty) {
                        return 'برجاء ادخال اسم المستخدم';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.PharmaColor,
                      ),
                      labelText: 'أسم المستخدم',
                      labelStyle: TextStyles.styleblackDefault,
                    ),
                  ),
                  SizedBox(height: context.height * 0.04),
                  SizedBox(
                    width: context.width * 1,
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (passwordController) {
                        if (passwordController!.isEmpty) {
                          return 'برجاء ادخال كلمة المرور';
                        }
                        if (passwordController.length < 8 ) {
                    return 'برجاء ادخال 8 مدخلات أو أكثر';
                          
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          color: AppColors.PharmaColor,
                        ),
                        labelText: 'كلمة المرور',
                        labelStyle: TextStyles.styleblackDefault,
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DoctorForgetPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyles.styleblackBold15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: context.height * 0.04),
                  Center(
                    child: Container(
                      width: context.width * 0.5,
                      // height: context.height * .25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.PharmaColor,
                      ),
                      child: TextButton(
                          onPressed: () {
                            // setState(() {
                            //   isloading = true;
                            // });
                            if (formKey.currentState!.validate()) {
                              // AppCubit.get(context).Doctorlogin(
                              //     username: emailController.text,
                              //     password: passwordController.text);
                              // HomeLayoutDoctor()));

                              showDialog(
                                context: context,
                                builder: (context) => DoctorLoginCheckDialog(
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  isloading: isloading,
                                ),
                              );
                            }
                          },
                          child: const AutoSizeText(
                            'تسجيل الدخول',
                            style: TextStyles.styleWhiteBold15,
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () async {
                        if (doctorLicense == '') {
                          flutterToast(msg: "Please Sign First");
                        } else {
                          if (await _authenticate() == true) {
                            BlocProvider.of<AppCubit>(context)
                                // .getDoctorPharmacy(licenceId: doctorLicense);
                                .getPharmacyNameFromSignIn(
                              PharmacyNameFromController:
                                  PharmacyNameFromController!,
                              // licenceId:
                              //     licenceidcontroller.text
                            );

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const HomeLayoutDoctor();
                              }),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            flutterToast(msg: "Not Recognized");
                          }
                        }
                      },
                      child: Image.asset("assets/images/fingerprint_image.jpg",
                          height: size.height * 0.2, width: size.width * 0.2),
                    ),
                  ),
                  if (_supportState)
                    const Text("This device is supported")
                  else
                    const Text("This device is not supported"),
                  ElevatedButton(
                    onPressed: _getAvailbleBiometrice,
                    child: const Text("Get available biometrics"),
                  ),
                  ElevatedButton(
                    onPressed: _authenticate,
                    child: const Text("Auth"),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _getAvailbleBiometrice() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print("List of availableBiometrics : $availableBiometrics");
    if (!mounted) {
      return;
    }
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

// DoctorLoginCheckdialog(
//     context, emailController, passwordController, isloading) {
//   var cubit = AppCubit.get(context);
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController licenceidcontroller = TextEditingController();
//   var formKey = GlobalKey<FormState>();
//   showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//             content: SizedBox(
//               width: 400,
//               height: 400,
//               child: Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Form(
//                   key: formKey,
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: TextFormField(
//                             controller: namecontroller,
//                             keyboardType: TextInputType.emailAddress,
//                             validator: (namecontoller) {
//                               if (namecontoller!.isEmpty) {
//                                 return 'برجاء ادخال اسم الصيدلية';
//                               } else {
//                                 return null;
//                               }
//                             },
//                             decoration: const InputDecoration(
//                               hintText: 'اسم الصيدلية',
//                               labelText: 'أسم الصيدلية',
//                               labelStyle: TextStyles.styleblackDefault,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: TextFormField(
//                             controller: licenceidcontroller,
//                             keyboardType: TextInputType.number,
//                             validator: (licenceController) {
//                               if (licenceController!.isEmpty) {
//                                 return 'برجاء ادخال رقم الرخصة';
//                               } else {
//                                 return null;
//                               }
//                             },
//                             onChanged: (value) {
//                               BlocProvider.of<ProfilePharmacyCubit>(context)
//                                   .licenceID = value;
//                             },
//                             decoration: const InputDecoration(
//                               hintText: 'رقم الرخصة',
//                               labelText: 'رقم الرخصة',
//                               labelStyle: TextStyles.styleblackDefault,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         isloading
//                             ? loading()
//                             : Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: ElevatedButton(
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                         },
//                                         child: const AutoSizeText(
//                                           'رجوع',
//                                           style: TextStyles.styleblackBold15,
//                                         )),
//                                   ),
//                                   const SizedBox(width: 30),
//                                   Expanded(
//                                     child: ElevatedButton(
//                                         onPressed: () async {
//                                           if (formKey.currentState!
//                                               .validate()) {
//                                             AppCubit.get(context).Doctorlogin(
//                                               username: emailController,
//                                               password: passwordController,
//                                               licenseId:
//                                                   licenceidcontroller.text,
//                                               pharmacyName: namecontroller.text,
//                                               context: context,
//                                             );
//                                             if (DoctorLoginSuccesState ==
//                                                 true) {
//                                               cubit.getDoctorPharmacy(
//                                                   licenceId:
//                                                       licenceidcontroller.text);
//                                               secureStorage.write(
//                                                   key: SecureStorageKey
//                                                       .doctorLicense,
//                                                   value:
//                                                       licenceidcontroller.text);
//                                               Navigator.of(context).pushReplacement(
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           const HomeLayoutDoctor()));
//                                             }

//                                             // if (await cubit.checkpharmacy(
//                                             //     licenceidcontroller.text,
//                                             //     namecontroller.text)) {
//                                             //   cubit.getDoctorPharmacy(
//                                             //       licenceId:
//                                             //           licenceidcontroller.text);
//                                             //   // ignore: use_build_context_synchronously
//                                             //   secureStorage.write(
//                                             //       key: SecureStorageKey.doctorLicense,
//                                             //       value: licenceidcontroller.text);
//                                             //   Navigator.of(context).pushReplacement(
//                                             //       MaterialPageRoute(
//                                             //           builder: (context) =>
//                                             //               const HomeLayoutDoctor()));
//                                             // } else {
//                                             //   // ignore: use_build_context_synchronously
//                                             //   showmydialog(
//                                             //       context,
//                                             //       'البيانات غير صحيحة',
//                                             //       Icons.warning);
//                                             // }
//                                           }
//                                         },
//                                         child: const AutoSizeText(
//                                           'تأكيد ',
//                                           style: TextStyles.styleblackBold15,
//                                         )),
//                                   ),
//                                 ],
//                               ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ));
// }

class DoctorLoginCheckDialog extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  bool isloading;

  DoctorLoginCheckDialog({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isloading,
  });

  @override
  _DoctorLoginCheckDialogState createState() => _DoctorLoginCheckDialogState();
}

class _DoctorLoginCheckDialogState extends State<DoctorLoginCheckDialog> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController licenceIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    return AlertDialog(
      surfaceTintColor: Colors.white,
      content: SizedBox(
        width: 400,
        height: 400,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (namecontoller) {
                        if (namecontoller!.isEmpty) {
                          return 'برجاء ادخال اسم الصيدلية';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'اسم الصيدلية',
                        labelText: 'أسم الصيدلية',
                        labelStyle: TextStyles.styleblackDefault,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: licenceIdController,
                      keyboardType: TextInputType.number,
                      validator: (licenceController) {
                        if (licenceController!.isEmpty) {
                          return 'برجاء ادخال رقم الرخصة';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        BlocProvider.of<ProfilePharmacyCubit>(context)
                            .licenceID = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'رقم الرخصة',
                        labelText: 'رقم الرخصة',
                        labelStyle: TextStyles.styleblackDefault,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  widget.isloading
                      ? loading()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const AutoSizeText(
                                    'رجوع',
                                    style: TextStyles.styleblackBold15,
                                  )),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        widget.isloading = true;
                                      });
                                      Future.delayed(
                                              const Duration(milliseconds: 1))
                                          .then((value) {
                                        AppCubit.get(context).Doctorlogin(
                                          username: widget.emailController.text,
                                          password:
                                              widget.passwordController.text,
                                          licenseId: licenceIdController.text,
                                          pharmacyName: nameController.text,
                                          context: context,
                                        );
                                        cubit.getPharmacyNameFromSignIn(
                                          PharmacyNameFromController:
                                              PharmacyNameFromController!,
                                          // licenceId:
                                          //     licenceidcontroller.text
                                        );
                                        // .getDoctorPharmacy(
                                        //     licenceId:
                                        //         licenceIdController.text);

                                        // cubit.getpharmacies(
                                        //     PharmacyNameFromController:
                                        //     nameController.text);
                                      }).then((value) {
                                        {
                                          setState(
                                            () {
                                              widget.isloading = false;
                                            },
                                          );
                                        }
                                      });
                                      // if (DoctorLoginSuccesState == true) {
                                      //   cubit.getDoctorPharmacy(
                                      //       licenceId:
                                      //           licenceIdController.text);
                                      // }

                                      // if (await cubit.checkpharmacy(
                                      //     licenceidcontroller.text,
                                      //     namecontroller.text)) {
                                      //   cubit.getDoctorPharmacy(
                                      //       licenceId:
                                      //           licenceidcontroller.text);
                                      //   // ignore: use_build_context_synchronously
                                      //   secureStorage.write(
                                      //       key: SecureStorageKey.doctorLicense,
                                      //       value: licenceidcontroller.text);
                                      //   Navigator.of(context).pushReplacement(
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               const HomeLayoutDoctor()));
                                      // } else {
                                      //   // ignore: use_build_context_synchronously
                                      //   showmydialog(
                                      //       context,
                                      //       'البيانات غير صحيحة',
                                      //       Icons.warning);
                                      // }
                                    }
                                  },
                                  child: const AutoSizeText(
                                    'تأكيد ',
                                    style: TextStyles.styleblackBold15,
                                  )),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
