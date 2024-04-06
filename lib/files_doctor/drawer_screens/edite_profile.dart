// ignore_for_file: use_build_context_synchronously

import 'package:pharmazool/app/patient/category_screens/locationinfo.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/constant/pop_up.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class EditeProfile extends StatefulWidget {
  const EditeProfile({super.key});

  @override
  State<EditeProfile> createState() => _EditeProfileState();
}

class _EditeProfileState extends State<EditeProfile> {
  var formkey = GlobalKey<FormState>();
  GlobalKey locationKey = GlobalKey();
  AppCubit? appCubit;
  ProfilePharmacyCubit? profileCubit;
  late TextEditingController selectedStateController;
  late TextEditingController selectedAreaController;
  late TextEditingController selectedLocalityController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  StateData stateData = StateData();
  AreaModelData areaModelData = AreaModelData();
  LocalityModelData localityModelData = LocalityModelData();

  @override
  void initState() {
    appCubit = BlocProvider.of<AppCubit>(context);
    profileCubit = BlocProvider.of<ProfilePharmacyCubit>(context);
    appCubit?.getAreaList();
    appCubit?.getLocalityList();
    appCubit?.getStateList();
    selectedStateController =
        TextEditingController(text: pharmamodel?.state?.name ?? '');
    addressController = TextEditingController(text: pharmamodel?.address ?? '');
    BlocProvider.of<ProfilePharmacyCubit>(context).stateId =
        pharmamodel?.state?.id;
    selectedAreaController =
        TextEditingController(text: pharmamodel?.area ?? '');
    BlocProvider.of<ProfilePharmacyCubit>(context).areaId = pharmamodel?.areaId;
    selectedLocalityController =
        TextEditingController(text: pharmamodel?.locality ?? '');
    BlocProvider.of<ProfilePharmacyCubit>(context).localityId =
        pharmamodel?.localityId;
    phoneController = TextEditingController(text: pharmamodel?.phone ?? '');
    stateData.id = pharmamodel?.stateId;
    areaModelData.id = pharmamodel?.areaId;
    localityModelData.id = pharmamodel?.localityId;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([locationKey]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '  مرحبا بك' '\n' '${pharmamodel?.name ?? ''}',
              textAlign: TextAlign.end,
              style: TextStyles.stylewhitebold25,
            ),
          ),
        ],
        elevation: 0,
        toolbarHeight: 120,
      ),
      backgroundColor: Colors.teal,
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                CustomSelectAreaAndLocalityTextField(
                  controller: selectedStateController,
                  labelText: "الولاية",
                  onPress: () {
                    showStatePicker(
                      context: context,
                      stateList: appCubit?.stateModel?.data ?? [],
                      result: selectedStateController,
                    );
                    setState(() {});
                  },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'برجاء ادخال بيانات';
                  //   }
                  //   return null;
                  // },
                  onPressCancel: () => selectedStateController.clear(),
                ),
                CustomSelectAreaAndLocalityTextField(
                  controller: selectedLocalityController,
                  labelText: "المحلية",
                  onPressCancel: () => selectedLocalityController.clear(),
                  onPress: () {
                    showLocalityPicker(
                      context: context,
                      listLocality: profileCubit?.listLocalityByStateId ?? [],
                      result: selectedLocalityController,
                    );
                    setState(() {});
                  },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'برجاء ادخال بيانات';
                  //   }
                  //   return null;
                  // },
                ),
                CustomSelectAreaAndLocalityTextField(
                  controller: selectedAreaController,
                  onPressCancel: () => selectedAreaController.clear(),
                  labelText: "المنطقة",
                  onPress: () {
                    showAreaPicker(
                      context: context,
                      areaList: profileCubit?.listAreaByLocalityId ?? [],
                      result: selectedAreaController,
                    );
                    setState(() {});
                  },
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'برجاء ادخال بيانات';
                  //   }
                  //   return null;
                  // },
                ),
                BlocBuilder<ProfilePharmacyCubit, ProfilePharmacyState>(
                  builder: (context, state) {
                    return DefaultTextFormFieldForProblem(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'برجاء ادخال بيانات';
                        }
                      },
                      textEditingController:
                          BlocProvider.of<ProfilePharmacyCubit>(context)
                              .linkLocationController,
                      textInputType: TextInputType.text,
                      hintText: "رابط خدمات الموقع",
                      maxLines: 1,
                      prefixIcon: Showcase(
                        key: locationKey,
                        descriptionTextDirection: TextDirection.rtl,
                        descTextStyle: TextStyles.styleblackDefault,
                        description:
                            "تاكد من تشغيل خدمات الموقع وقم بالضغط هنا لتحديد موقع الصيدلية عن طريق الاقمار الصناعية",
                        child: IconButton(
                          icon: const Icon(Icons.location_on_outlined),
                          onPressed: () {
                            BlocProvider.of<ProfilePharmacyCubit>(context)
                                .getPressLocation();
                          },
                        ),
                      ),
                    );
                  },
                ),
                DefaultTextFormFieldForProblem(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'برجاء ادخال بيانات';
                    }
                  },
                  textEditingController: addressController,
                  textInputType: TextInputType.text,
                  hintText: "وصف العنوان",
                  maxLines: 1,
                ),
                DefaultTextFormFieldForProblem(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'برجاء ادخال بيانات';
                    }
                    if (value.length < 10 || value.length > 10) {
                      return 'برجاء ادخال 10 ارقام فقط';
                    }
                  },
                  textEditingController: phoneController,
                  textInputType: TextInputType.number,
                  hintText: "رقم المحمول",
                  maxLines: 1,
                ),
                BlocConsumer<ProfilePharmacyCubit, ProfilePharmacyState>(
                  listener: (context, state) {
                    var cubit = ProfilePharmacyCubit.get(context);

                    if (state is UpdatePharmacySuccessProfileState) {
                      BlocProvider.of<AppCubit>(context)
                          .getDoctorPharmacy(licenceId: cubit.licenceID ?? '');

                      Navigator.pop(context);
                      Navigator.pop(context);
                      flutterToast(msg: 'تم تغيير بيانات الصيدلية');
                    }
                    if (state is UpdatePharmacyErrorProfileState) {
                      flutterToast(msg: 'حدث خطأ في تحديث البيانات');
                    }
                  },
                  builder: (context, state) {
                    var cubit = ProfilePharmacyCubit.get(context);

                    return MaterialButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          if (cubit.areaId == null ||
                              cubit.localityId == null ||
                              cubit.stateId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please Choose Locality or state or area")));
                          } else {
                            showCheckDialogToEdit(context);
                          }

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ConfirmEdit(
                          //               loc: controller1.text,
                          //               link: BlocProvider.of<AppCubit>(context)
                          //                   .controller2
                          //                   .text,
                          //               phone: controller3.text,
                          //               time: controller4.text,
                          //               licence: controller5.text,
                          //             )));
                        }
                      },
                      color: Colors.teal,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 8,
                        ),
                        child: const Text(
                          "حفظ",
                          style: TextStyles.stylewhitebold20,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showCheckDialogToEdit(context) {
    var cubit = AppCubit.get(context);
    TextEditingController namecontroller = TextEditingController();
    TextEditingController licenceidcontroller = TextEditingController();
    var formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(
                width: 400,
                height: 400,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: namecontroller,
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
                            controller: licenceidcontroller,
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
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
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
                                    if (formKey.currentState!.validate()) {
                                      if (await cubit.checkpharmacy(
                                          licenceidcontroller.text,
                                          namecontroller.text)) {
                                        cubit.getDoctorPharmacy(
                                            licenceId:
                                                licenceidcontroller.text);
                                        // ignore: use_build_context_synchronously
                                        BlocProvider.of<ProfilePharmacyCubit>(context).ahmedUpdatePharmacyOptional(
                                            newLocation: BlocProvider.of<
                                                        ProfilePharmacyCubit>(
                                                    context)
                                                .linkLocationController
                                                .text,
                                            phone: phoneController.text,
                                            context: context,
                                            areaId: BlocProvider.of<
                                                            ProfilePharmacyCubit>(
                                                        context)
                                                    .areaId ??
                                                0,
                                            localityId: BlocProvider.of<
                                                            ProfilePharmacyCubit>(
                                                        context)
                                                    .localityId ??
                                                0,
                                            stateId: BlocProvider.of<
                                                            ProfilePharmacyCubit>(
                                                        context)
                                                    .stateId ??
                                                0,
                                            street:
                                                selectedStateController.text,
                                            address: addressController.text);
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showmydialog(
                                            context,
                                            'البيانات غير صحيحة',
                                            Icons.warning);
                                      }
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
            ));
  }
}
