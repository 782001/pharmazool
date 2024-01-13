import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/constant/pop_up.dart';
import 'package:pharmazool/src/features/doctor/share_spoken/logic/share_spoken_cubit.dart';
import 'package:pharmazool/src/features/doctor/share_spoken/persentation/widgets/head_shared_spoken_screen.dart';

class SharedForSpoken extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController explainYourProblemController = TextEditingController();
  GlobalKey<FormState> reportKey = GlobalKey<FormState>();

  SharedForSpoken({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShareSpokenCubit(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: reportKey,
              child: Column(
                children: [
                  HeadSharedSpokenScreen(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        CustomForgetTextField(
                          controller: nameController,
                          labelText: 'الاسم',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Name';
                            } else if (value.length < 3) {
                              return 'Please Enter Valid Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomForgetTextField(
                          controller: phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Phone';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          labelText: 'رقم التليفون',
                        ),
                        const SizedBox(height: 10),
                        CustomForgetTextField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length <= 11) {
                              return 'Please Explain Your Problem';
                            }
                            return null;
                          },
                          controller: explainYourProblemController,
                          keyboardType: TextInputType.text,
                          labelText: 'اشرح ما هو اقتراحك',
                          maxLines: 6,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                  BlocConsumer<ShareSpokenCubit, ShareSpokenState>(
                    listener: (context, state) {
                      if (state is SendEmailSuccess) {
                        flutterToast(msg: "Send Success");
                        nameController.clear();
                      phoneController.clear();
                        explainYourProblemController.clear();
                      }
                      if (state is SendEmailFailure) {
                        flutterToast(msg: "Send Failure");
                      }
                    },
                    builder: (context, state) {
                      var cubit = ShareSpokenCubit.get(context);
                      return state is SendEmailLoading
                          ? const Center(child: CircularProgressIndicator())
                          : MaterialButton(
                              onPressed: () {
                                if (reportKey.currentState!.validate()) {
                                  cubit.sendByMalier(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    subject: explainYourProblemController.text,
                                  );
                                }
                              },
                              color: AppColors.PharmaColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0))),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 80,
                                  vertical: 8,
                                ),
                                child: const Text(
                                  'شاركنا اقتراحك',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            );
                    },
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    'او تواصل معنا علي التالي',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            launch(
                                'https://www.facebook.com/profile.php?id=100068365090281&mibextid=LQQJ4d');
                          },
                          child: FaIcon(
                            FontAwesomeIcons.facebookSquare,
                            color: Colors.blue,
                            size: 60,
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.instagramSquare,
                          color: Colors.redAccent,
                          size: 60,
                        ),
                      ],
                    ),
                  )
                  // SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
