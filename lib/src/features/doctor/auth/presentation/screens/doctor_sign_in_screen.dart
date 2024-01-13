import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/constant/app_constant.dart';
import 'package:pharmazool/src/core/constant/pop_up.dart';

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

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
    loadKeys();
  }

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
        if (state is AppLoginSuccesState) {
          setState(() {
            isloading = false;
          });
          showmycheckdialog(context);
        }
        if (state is AppLoginErrorState) {
          setState(() {
            isloading = false;
          });
          showmydialog(context, 'الحساب غير صحيح', Icons.warning);
        }
      },
      builder: ((context, state) {
        return Form(
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
                    ),
                  ),
                ),
                SizedBox(height: context.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                      child: Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                            color: AppColors.PharmaColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                SizedBox(height: context.height * 0.04),
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
                                setState(() {
                                  isloading = true;
                                });
                                if (formKey.currentState!.validate()) {
                                  AppCubit.get(context).userlogin(
                                      username: emailController.text,
                                      password: passwordController.text);
                                  // HomeLayoutDoctor()));
                                }
                              },
                              child: const AutoSizeText(
                                'تسجيل الدخول',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
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
                              .getDoctorPharmacy(licenceId: doctorLicense);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const HomeLayoutDoctor()));
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
        options: AuthenticationOptions(
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
}
