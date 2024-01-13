import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/constant/app_constant.dart';

String? userName;
String? token;
PharmacyModelData? pharmacyModelData;
PharmacyModel? pharmamodel;
List<PharmacyModel> pharmacyhistory = [];
dynamic lat1 = 31.265504445873205;
double long1 = 32.3016561;
double lat2 = 31.2640004386519;
double long2 = 32.30775007919794;

double myLat = 0;
double mylong = 0;

void setmypost() async {
  Position mypos = await determinePosition();
  myLat = mypos.latitude;
  mylong = mypos.longitude;
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

double calculateDistance(double lat1, double long1, double lat2, double long2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((long2 - long1) * p)) / 2;
  double distance = (12742 * asin(sqrt(a)) * 1000);

  return distance;
}

FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true));

showmycheckdialog(
  context,
) {
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
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
                                          licenceId: licenceidcontroller.text);
                                      // ignore: use_build_context_synchronously
                                      secureStorage.write(key: SecureStorageKey.doctorLicense, value: licenceidcontroller.text);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeLayoutDoctor()));
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      showmydialog(context,
                                          'البيانات غير صحيحة', Icons.warning);
                                    }
                                  }
                                },
                                child: const AutoSizeText(
                                  'تأكيد ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
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

showmydialog(context, String content, IconData icon) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Row(
              children: [
                Icon(icon),
                const SizedBox(
                  width: 2,
                ),
                Text(content),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('رجوع'))
            ],
          ));
}

String baseurl = 'http://amc007-001-site8.etempurl.com/api/';

// 1- login endpoints:
String loginEndPoint = 'Authentication/Login';
String registerEndPoint = 'Authentication/Register';
String resetPasswordEndPoint = 'Authentication/ResetPassword';

// 2- area endpoints:
String getAreaByIdEndPoint = 'Area/:id';
String putAreaByIdEndPoint = 'Area/:id';
String deleteAreaByIdEndPoint = 'Area/:id';
String getAreaEndPoint =
    'Area?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postAreaEndPoint = 'Area';

// 3- generic endpoints:
String getGenericEndPoint =
    'Generic?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postGenericEndPoint = 'Generic';
String getGenericByIdEndPoint = 'Generic/:id';
String putGenericByIdEndPoint = 'Generic/:id';
String deleteGenericByIDEndPoint = 'Generic/:id';

// 4- groub endpoints:
String getGroubEndPoint = 'Group?pageSize=10';
String postGroupEndPoint = 'Group';
String getGroupByIdEndPoint = 'Group/:id';
String putGroupByIdEndPoint = 'Group/:id';
String deleteGroupByIDEndPoint = 'Group/:id';

// 5- locality endpoints:
String getLocalityEndPoint =
    'Locality?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postLocalityEndPoint = 'Locality';
String getLocalityByIdEndPoint = 'Locality/:id';
String putLocalityByIdEndPoint = 'Locality/:id';
String deleteLocalityByIDEndPoint = 'Locality/:id';

// 6- manufactory endpoints:
String getManufacturerEndPoint =
    'Manufacturer?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postManufacturerEndPoint = 'Manufacturer';
String getManufacturerByIdEndPoint = 'Manufacturer/:id';
String putManufacturerByIdEndPoint = 'Manufacturer/:id';
String deleteManufacturerByIDEndPoint = 'Manufacturer/:id';

// 7- manufactoryorigincountry:
String getManufacturerOrginCountryEndPoint =
    'ManufacturerOrginCountry?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postManufacturerOrginCountryEndPoint = 'ManufacturerOrginCountry';
String getManufacturerOrginCountryByIdEndPoint = 'ManufacturerOrginCountry/:id';
String putManufacturerOrginCountryByIdEndPoint = 'ManufacturerOrginCountry/:id';
String deleteManufacturerOrginCountryByIDEndPoint =
    'ManufacturerOrginCountry/:id';

// 8- medicine endpoints:
String getMedicineEndPoint = 'Medicine?PageSize=50&';
String postMedicineEndPoint = 'Medicine';
String getMedicineByIdEndPoint = 'Medicine/:id';
String putMedicineByIdEndPoint = 'Medicine/:id';
String deleteMedicineByIDEndPoint = 'Medicine/:id';

// 8- medicinegroub endpoints:
String getMedicineGroupEndPoint =
    'Medicine?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postMedicineGroupEndPoint = 'Medicine';
String getMedicineGroupByIdEndPoint = 'MedicineGroup/:MedicineId/:GroupId';
String putMedicineGroupByIdEndPoint = 'MedicineGroup/:MedicineId/:GroupId';
String deleteMedicineGroupByIDEndPoint = 'MedicineGroup/:MedicineId/:GroupId';

// 9- origincountry endpoints:
String getOrginCountryEndPoint =
    'OrginCountry?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postOrginCountryEndPoint = 'OrginCountry';
String getOrginCountryByIdEndPoint = 'OrginCountry/:id';
String putOrginCountryByIdEndPoint = 'OrginCountry/:id';
String deleteOrginCountryByIDEndPoint = 'OrginCountry/:id';

// 10- pharmacy endpoints:
String getPharmacyEndPoint = 'Pharmacy?PageSize=20';
String postPharmacyEndPoint = 'Pharmacy';
String getPharmacyByIdEndPoint = 'Pharmacy/:id';
String putPharmacyByIdEndPoint = 'Pharmacy/:id';
String deletePharmacyByIDEndPoint = 'Pharmacy/:id';

// 11- pharmacymedicine endpoints:
String getPharmacyMedicineEndPoint =
    'PharmacyMedicine?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postPharmacyMedicineEndPoint = 'PharmacyMedicine';
String getPharmacyMedicineByIdEndPoint =
    'PharmacyMedicine/:MedicineId/:PharmacyId';
String putPharmacyMedicineByIdEndPoint =
    'PharmacyMedicine/:MedicineId/:PharmacyId';
String deletePharmacyMedicineByIDEndPoint =
    'PharmacyMedicine/:MedicineId/:PharmacyId';

// 12- ProductStatus endpoints:
String getProductStatusEndPoint =
    'ProductStatus?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postProductStatusEndPoint = 'ProductStatus';
String getProductStatusByIdEndPoint = 'ProductStatus/:id';
String putProductStatusByIdEndPoint = 'ProductStatus/:id';
String deleteProductStatusByIDEndPoint = 'ProductStatus/:id';

// 13- ProductStatus endpoints:
String getUnitEndPoint =
    'Unit?PageIndex=<integer>&PageSize=<integer>&Sort=<string>&Search=<string>';
String postUnitEndPoint = 'Unit';
String getUnitByIdEndPoint = 'Unit/:id';
String putUnitByIdEndPoint = 'Unit/:id';
String deleteUnitByIDEndPoint = 'Unit/:id';
