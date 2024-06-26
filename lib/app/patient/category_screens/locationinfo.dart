import 'package:flutter/material.dart';
import 'package:pharmazool/app/patient/category_screens/widgets/loading_data_screen.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/strings.dart';
import 'package:pharmazool/src/core/utils/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationInfo extends StatefulWidget {
  final String id;

  const LocationInfo(this.id, {super.key});

  @override
  State<LocationInfo> createState() => _LocationInfoState();
}

class _LocationInfoState extends State<LocationInfo> {
  late TextEditingController area;
  late TextEditingController locality;
  late TextEditingController stateController;
  AppCubit? appCubit;
  ProfilePharmacyCubit? profileCubit;

  @override
  void initState() {
    area = TextEditingController();
    locality = TextEditingController();
    stateController = TextEditingController();
    appCubit = BlocProvider.of<AppCubit>(context);
    profileCubit = BlocProvider.of<ProfilePharmacyCubit>(context);
    appCubit?.getAreaList();
    appCubit?.getLocalityList();
    appCubit?.getStateList();
    appCubit?.getpharmacies();
    super.initState();
  }

  @override
  void dispose() {
    area.dispose();
    locality.dispose();
    stateController.dispose();
    super.dispose();
  }

 

  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'مطلوب إذن الموقع',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'هذا التطبيق يحتاج إلى الوصول إلى الموقع ليعمل بشكل صحيح.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: const Text(
                'منح الإذن',
                textAlign: TextAlign.center,
                style: TextStyles.styleblackbold20,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                // await checkAndRequestLocationPermission(context);
                // setmypost();
                // openAppSettings();
                setmypost();
              },
            ),
          ],
        );
      },
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.teal,
            ),
            Column(
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: const Text(
                    'حدد الولاية او المحلية او المنطقة ثم اضغط بحث و سيقوم فارمازول بالبحث عن دوائك في الصيدليات المتوفرة بها',
                    textAlign: TextAlign.center,
                    style: TextStyles.stylewhitebold20,
                  ),
                ),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(70)),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<AppCubit, AppStates>(
                        builder: (context, state) {
                          var cubit = AppCubit.get(context);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // الولاية
                              CustomSelectAreaAndLocalityTextField(
                                controller: stateController,
                                labelText: "الولاية",
                                onPressCancel: () => stateController.clear(),
                                onPress: () {
                                  setState(() {
                                    showStatePicker(
                                      context: context,
                                      stateList:
                                          appCubit?.stateModel?.data ?? [],
                                      result: stateController,
                                    );
                                  });
                                },
                              ),
                              // المحلية
                              CustomSelectAreaAndLocalityTextField(
                                controller: locality,
                                onPressCancel: () => locality.clear(),
                                labelText: 'المحلية',
                                onPress: () {
                                  setState(() {
                                    showLocalityPicker(
                                      context: context,
                                      listLocality:
                                          profileCubit?.listLocalityByStateId ??
                                              [],
                                      result: locality,
                                    );
                                  });
                                },
                              ),
                              // المنطقة
                              CustomSelectAreaAndLocalityTextField(
                                controller: area,
                                onPressCancel: () => area.clear(),
                                labelText: 'المنطقة',
                                onPress: () {
                                  setState(() {
                                    showAreaPicker(
                                      context: context,
                                      areaList:
                                          profileCubit?.listAreaByLocalityId ??
                                              [],
                                      result: area,
                                    );
                                  });
                                },
                              ),
                              SearchButtonAreaAndLocalityAndState(
                                area: area,
                                locality: locality,
                                stateController: stateController,
                                id: widget.id,
                              ),
                              const SizedBox(height: 50),
                              const Text(
                                'او قم بالبحث عن طريق موقعك',
                                style: TextStyles.stylebold22,
                              ),
                              const SizedBox(height: 50),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: TextButton(
                                    child: const Text(
                                      'البحث عن طريق موقعي',
                                      style: TextStyles.stylewhiteboldDefault,
                                    ),
                                    onPressed: () async {
                                      // checkAndRequestLocationPermission(context);

                                      PermissionStatus status =
                                          await Permission.location.status;
                                      if (status.isGranted) {
                                        AppCubit.get(context).getpharmacies(
                                          id: int.parse(widget.id.toString()),
                                          area: area.text,
                                          locality: locality.text,
                                          street: stateController.text,
                                        );
                                        AppCubit.get(context)
                                            .getFilteredPharmaciesByMedicineIdmodel(
                                                MedicineId: widget.id);

                                        print(area.text +
                                            locality.text +
                                            stateController.text);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const loadingData(
                                              widget: NearbyPharmacies(),
                                            ),
                                          ),
                                        );
                                      } else if (status.isPermanentlyDenied) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(
                                                  'تم رفض إذن الموقع بشكل دائم. يرجى تمكينه من الإعدادات.'),
                                            ),
                                            action: SnackBarAction(
                                              label: 'الإعدادات',
                                              onPressed: () async {
                                                openAppSettings();
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        showPermissionDialog(context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSelectAreaAndLocalityTextField extends StatelessWidget {
  const CustomSelectAreaAndLocalityTextField({
    super.key,
    required this.controller,
    required this.onPress,
    required this.labelText,
    required this.onPressCancel,
    this.readOnly,
    this.validator,
  });

  final TextEditingController controller;
  final VoidCallback onPress;
  final VoidCallback onPressCancel;
  final String labelText;
  final String? Function(String?)? validator;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: cairoFont,
                  ),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.right,
                controller: controller,
                readOnly: readOnly ?? true,
                onTap: onPress,
                validator: validator,
              ),
            ),
            IconButton(
              onPressed: onPressCancel,
              icon: const Icon(Icons.cancel),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchButtonAreaAndLocalityAndState extends StatelessWidget {
  const SearchButtonAreaAndLocalityAndState({
    super.key,
    required this.locality,
    required this.area,
    required this.stateController,
    required this.id,
  });

  final TextEditingController locality;
  final TextEditingController area;
  final TextEditingController stateController;
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePharmacyCubit, ProfilePharmacyState>(
      builder: (context, state) {
        var profileCubit = ProfilePharmacyCubit.get(context);
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton(
              child: const Text(
                'بحث',
                style: TextStyles.stylewhiteboldDefault,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const loadingData(
                      widget: PharmasyScreen(),
                    ),
                  ),
                );

                AppCubit.get(context).getPharmaciesByMedicineIdmodel(
                  MedicineId: id,
                  localityName: locality.text,
                  areaName: area.text,
                  stateName: stateController.text,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
