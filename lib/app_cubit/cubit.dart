import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmazool/app/patient/nav_screens/barcode.dart';
import 'package:pharmazool/src/features/patient/patient_home/presentation/screens/patient_home.dart';
import 'package:pharmazool/repo/services.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:pharmazool/files_doctor/nav_screens/home_doctor_screen.dart';
import 'package:http/http.dart' as http;
import 'package:pharmazool/mymodels/medicine_model.dart';
import '../app/patient/nav_screens/history_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isInitialized = false;

  int currentIndex = 0;
  List<Widget> screens = [
    PatientHome(),
    const HistoryScreen(),
    const BarCode(),
  ];
  int doctorindex = 0;
  List doctorscreens = [
    const HomeScreenDoctor1(),
    const HistoryScreen(),
    const BarCode(),
  ];
  void changeindex(int index) {
    currentIndex = index;
    emit(changeBottomNAvState());
  }

  var searchList = [];
  void getsearchmedicine(String search) {
    searchList = [];
    emit(GetMedicinesByIdLoadingState());
    //get data without pagination
    DioHelper.getData(
      url: 'Medicine/GetAllMedicine?PageSize=40&Search=$search',
    ).then((value) {
      value.data['data'].forEach((element) {
        if (search.isNotEmpty) {
          searchList.add(MedicineModel.fromJson(element));
        }
      });
      search = '';
      updatestatus(searchList);
      emit(GetMedicinesByIdSuccesState());
    }).catchError((error) {
      print(error);
      emit(GetMedicinesByIdErrorState());
    });
  }

  List<MedicineModel> medicinesbyId = [];

  // void getmedicinebyrepo({int id = 0, String search = ''}) async {
  // medicinesbyId = [];
  //GetMedicineData data = GetMedicineData();
  //emit(GetMedicinesByIdLoadingState());
  //try {
  //  medicinesbyId = await data.getmedicinelist(id, search, medicinesbyId);
  //emit(GetMedicinesByIdSuccesState());
  //} catch (error) {
  // print(error.toString());
  //emit(GetMedicinesByIdErrorState());
  //}
  // }
  void updatestatus(var pharmacymedicinelist) {
    pharmacymedicinelist.forEach((element) {
      element.pharmacyMedicines!.forEach((element1) {
        if (element1['pharmacyId'] == int.parse(pharmamodel!.id!)) {
          element.status = true;
        } else {
          element.status = false;
        }
      });
    });
  }

  void searchGenericMedicinePatient(String search, int id) {
    medicinesbyId = [];
    emit(SearchGenericMedicinePatientLoadingState());
    DioHelper.getData(
      url:
          'Medicine/GetMedicineByGeneric?genericId=$id&Search=$search&PageSize=15',
    ).then((value) {
      value.data['data'].forEach((element) {
        medicinesbyId.add(MedicineModel.fromJson(element));
      });
      emit(SearchGenericMedicinePatientSuccesState());
    }).catchError((error) {
      emit(SearchGenericMedicinePatientErrorState());
    });
  }

  void getMedicinesByID({int id = 0, String search = ""}) {
    medicinesbyId = [];
    emit(GetMedicinesByIdLoadingState());
    DioHelper.getData(
      url:
          'Medicine/GetMedicineByGeneric?genericId=$id&PageSize=15&Search=$search',
    ).then((value) {
      value.data['data'].forEach((element) {
        medicinesbyId.add(MedicineModel.fromJson(element));
      });
      updatestatus(medicinesbyId);
      emit(GetMedicinesByIdSuccesState());
    }).catchError((error) {
      emit(GetMedicinesByIdErrorState());
    });
  }

  void medicinelistpagination(
      {var medicinelist, int? page, int? id, String? search}) async {
    emit(IncreamentOfMedicineListLoadingState());
    GetMedicineData data = GetMedicineData();
    try {
      await data.medicinelistpaginationRepo(medicinelist, id!, page!, search!);

      emit(IncreamentOfMedicineListSuccesState());
    } catch (error) {
      print(error);
      emit(IncreamentOfMedicineListErrorState());
    }
  }

  void userlogin({required String username, required String password}) {
    emit(AppLoginLoadingState());
    DioHelper.postData(
        url: loginEndPoint,
        data: {'userName': username, 'password': password}).then((value) {
      print("doctor login ******");

      print(value.data);
      print("doctor login ******");
      userName = value.data['userName'];
      token = value.data['token'];
      emit(AppLoginSuccesState());
    }).catchError((error) {
      print(error.toString());
      emit(AppLoginErrorState());
    });
  }

  void resetPassword(
      {required String phonenumber,
      required String password,
      required String licenceId,
      required int type}) {
    DioHelper.postData(url: resetPasswordEndPoint, data: {
      "phoneNumber": phonenumber,
      "licenseId": licenceId,
      "type": type,
      "newPassword": password
    }).then((value) {
      emit(AppResetPasswordSuccesState());
    }).catchError((error) {
      print(error.toString());
      emit(AppResetPasswordErrorState());
    });
  }

  Future<bool> checkpharmacy(String licId, String name) async {
    bool isverified = false;
    await DioHelper.getData(url: getPharmacyEndPoint).then((value) {
      value.data['data'].forEach((element) {
        if (element['licenceId'] == licId && element['name'] == name) {
          isverified = true;
        }
      });
    }).catchError((error) {
      print(error);
    });
    return isverified;
  }

  void patientRegister({
    required String username,
    required String phone,
    required String password,
    required int type,
  }) {
    emit(AppRegisterLoadingState());
    DioHelper.postData(url: registerEndPoint, data: {
      'firstName': 'osamaa22',
      'lastName': 'osama22',
      'phone': phone,
      'email': 'asdsad@gmail.com',
      'userName': username,
      'password': password,
      'licenseId': 'sdas5445',
      'type': '$type'
    }).then((value) {
      print("Patient Register ******");
      print(value.data);
      print("Patient Register ******");
      userName = value.data['userName'];
      token = value.data['token'];
      emit(AppRegisterSuccesState());
    }).catchError((error) {
      print(error.toString());
      emit(AppRegisterErrorState());
    });
  }

  void doctorRegister(
      {required String username,
      required String phone,
      required String password,
      required int type,
      required String licenceId,
      required String pharmacyName,
      context}) async {
    emit(DoctorRegisterLoadingState());
    if (await checkpharmacy(licenceId, pharmacyName)) {
      print('success');
      DioHelper.postData(url: registerEndPoint, data: {
        'firstName': 'osamaa22',
        'lastName': 'osama22',
        'phone': phone,
        'email': 'asdsad@gmail.com',
        'userName': username,
        'password': password,
        'licenseId': licenceId,
        'type': '$type'
      }).then((value) {
        print("Doctor Register ******");
        print(value.data);
        print("Doctor Register ******");

        userName = value.data['userName'];
        token = value.data['token'];
        getDoctorPharmacy(licenceId: licenceId);
        showmydialog(
            context, 'تم انشاء الحساب', Icons.assignment_turned_in_outlined);
        emit(DoctorRegisterSuccesState());
      }).catchError((error) {
        print(error);
        emit(DoctorRegisterErrorState());
      });
    } else {
      emit(DoctorRegisterErrorState());
      showmydialog(context, '1 الحساب غير صحيح', Icons.warning);
    }
  }

  bool checkarea = false;
  // List<PharmacyModel>? filteredpharmacyList;
  List<PharmacyModel> pharmacyList = [];
  List<Marker> pharmaciesmarkers = [];
  List<PharmacyModel> nearestpharmacies = [];
  void resetmarker() {
    pharmaciesmarkers = [];
    pharmaciesmarkers.add(
      Marker(
        markerId: const MarkerId('موقعي'),
        position: LatLng(myLat, mylong),
        infoWindow: InfoWindow(onTap: () {}, title: 'my location'),
      ),
    );
  }

  Position? position;
  void getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition();
  }

  var controller2 = TextEditingController();
  Position? pressPosition;
  void getPressLocation() async {
    emit(GetPressPositionLoading());
    await Geolocator.getCurrentPosition().then((currentP) {
      pressPosition = currentP;
      controller2 = TextEditingController(text: "تم تحديد موقع الصيدلية بنحاح");
      emit(GetPressPositionSuccess());
    }).catchError((e) {
      print("Error in get Press Position $e");
      emit(GetPressPositionError());
    });
  }

  List<String> streetAllPharmacy = [];
  void getpharmacies(
      {int id = 0, String? area, String? locality, String? street}) {
    getCurrentLocation();
    nearestpharmacies = [];
    emit(GetPharmaciesLoadingState());
    DioHelper.getData(url: getPharmacyEndPoint).then((value) {
      pharmacyModelData = PharmacyModelData.fromJson(value.data);
      // to Store all pharmacy
      pharmacyModelData?.data?.forEach((element) {
        pharmacyList.add(element);
        // to Store All Street Pharmaces
        streetAllPharmacy.add(element.street ?? '');
      });
      // lets go to filter List Pharmacy
      // if (localityModel != null ||
      //     areaModel != null ||
      //     streetAllPharmacy.isEmpty) {
      //   pharmacyModelData?.data?.forEach((pharmacyElement) {
      //     if (pharmacyElement.locality == locality) {
      //       filteredpharmacyList = [];
      //       filteredpharmacyList?.add(pharmacyElement);
      //     }else{
      //       print("filteredpharmacyList is $filteredpharmacyList");
      //      }
      //   });
      // }

      // to get nearby List pharmacy by location
      for (PharmacyModel pharmacyItem in pharmacyModelData?.data ?? []) {
        if (pharmacyItem.lat != '' || pharmacyItem.long != '') {
          var distance = Geolocator.distanceBetween(
            double.parse(pharmacyItem.lat ?? '0.0'),
            double.parse(pharmacyItem.long ?? '0.0'),
            position?.latitude ?? 0.0,
            position?.longitude ?? 0.0,
          );

          if (distance <= 199909) {
            nearestpharmacies.add(
              pharmacyItem,
            );
          }
        }
      }

      // pharmacyModelData?.data?.forEach(
      //   (element) {
      //     print(element.address);
      //   },
      // );
      // print("****************");
      // value.data['data'].forEach((element) {
      //   element['pharmacyMedicines'].forEach((pharmacieselement) {
      //     if (pharmacieselement['medicineId'] == id) {
      //       pharmacyList.add(PharmacyModel.fromJson(element));
      //       if (element['latitude'] != null) {
      //         double distance = calculateDistance(
      //             myLat,
      //             mylong,
      //             double.parse(element['latitude']),
      //             double.parse(element['longitude']));
      //         print(distance.toInt());
      //         if (distance.toInt() < 5000) {
      //           /*  pharmaciesmarkers.add(
      //             Marker(
      //               markerId: MarkerId(element['name']),
      //               position: LatLng(double.parse(element['latitude']),
      //                   double.parse(element['longitude'])),
      //               infoWindow:
      //                   InfoWindow(onTap: () {}, title: element['name']),
      //             ),
      //           );*/
      //           nearestpharmacies.add(PharmacyModel(
      //               address: element['address'],
      //               area: element['area']['name'],
      //               street: element['street'],
      //               id: element['id'].toString(),
      //               distance: distance.toInt(),
      //               licenseId: element['licenceId'],
      //               locality: element['locality']['name'],
      //               name: element['name'],
      //               phone: element['phone'],
      //               medicines: element['pharmacyMedicines']));
      //           nearestpharmacies
      //               .sort((a, b) => a.distance!.compareTo(b.distance!));
      //         } else {
      //           return;
      //         }
      //       }
      //     }
      //   });
      // });
      // if (area.isNotEmpty) {
      //   checkarea = !checkarea;
      //   pharmacyList.forEach((element) {
      //     if (locality.isEmpty) {
      //       if (element.area == area) {
      //         filteredpharmacyList.add(element);
      //       }
      //     } else {
      //       if (element.locality == locality && element.area == area) {
      //         if (street.isNotEmpty) {
      //           if (element.street == street) {
      //             filteredpharmacyList.add(element);
      //           } else {
      //             return;
      //           }
      //         } else {
      //           filteredpharmacyList.add(element);
      //         }
      //       }
      //     }
      //   });
      // }
      // print(pharmacyList.length);
      emit(GetPharmaciesSuccesState());
    }).catchError((error) {
      print(error);
      emit(GetPharmaciesErrorState());
    });
  }

  List<PharmacyModel>? filterListByLocality;
  void filterByLocality({String? area, String? locality, String? street}) {
    if (localityModel != null ||
        areaModel != null ||
        streetAllPharmacy.isEmpty) {
      print(pharmacyModelData?.data?.length);
      pharmacyModelData?.data?.forEach((pharmacyElement) {
        if (pharmacyElement.locality == locality) {
          print(locality);
          filterListByLocality?.add(pharmacyElement);
        } else {
          print(filterListByLocality);
        }
      });
    }
  }

  StateModel? stateModel;

  void getStateList() {
    emit(GetStateLoading());
    DioHelper.getData(url: 'State').then((value) {
      stateModel = StateModel.fromJson(value.data);
      print(stateModel?.data?.length);
      emit(GetStateSuccess());
    }).catchError((e) {
      emit(GetStateError());
      print("Error in GEt Area");
    });
  }

  AreaModel? areaModel;

  void getAreaList() {
    emit(GetAreaListLoading());
    DioHelper.getData(url: 'Area').then((value) {
      areaModel = AreaModel.fromJson(value.data);
      emit(GetAreaListSuccess());
    }).catchError((e) {
      emit(GetAreaListError());
      print("Error in GEt Area");
    });
  }

  LocalityModel? localityModel;
  void getLocalityList() {
    emit(GetLocalityLoading());
    DioHelper.getData(url: 'Locality').then((value) {
      localityModel = LocalityModel.fromJson(value.data);

      emit(GetLocalitySuccess());
    }).catchError((e) {
      emit(GetLocalityError());
      print("Error in Get Locality");
    });
  }

  String searcher = '';
  List<String> doctorSearcher = [''];

  File? textImage;
  Future<String> getGalleryImageForPatientSearch() async {
    String search = '';
    XFile? PickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (PickedFile != null) {
      textImage = File(PickedFile.path);
      List<TextBlock> rectext = await recogniseText(textImage);
      rectext.forEach((element) {
        search = search + element.text;
      });

      emit(PickImageSuccesState());
    } else {
      emit(PickImageErrorState());
    }
    return search;
  }

  Future<void> getPostImage() async {
    XFile? PickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    searcher = '';
    doctorSearcher = [''];
    if (PickedFile != null) {
      textImage = File(PickedFile.path);
      List<TextBlock> rectext = await recogniseText(textImage);
      rectext.forEach((element) {
        searcher = searcher + element.text;
        doctorSearcher.add(element.text);
      });
      var splitter = searcher.split('\n');
      doctorSearcher = splitter;
      doctorSearcher = doctorSearcher.toSet().toList();

      emit(PickImageSuccesState());
    } else {
      emit(PickImageErrorState());
    }
  }

  Future<void> getPdfText() async {
    doctorSearcher = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      try {
        String pdflist = await ReadPdfText.getPDFtext(file.path);
        print(pdflist.toString());
        doctorSearcher = pdflist.split("\n");
        doctorSearcher = doctorSearcher.toSet().toList();
      } catch (error) {
        print(error);
      }
    }
  }

  File? textImage2;

  Future<void> getPostImage2() async {
    XFile? PickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    searcher = '';
    doctorSearcher = [''];
    if (PickedFile != null) {
      textImage2 = File(PickedFile.path);
      List<TextBlock> rectext = await recogniseText(textImage2);
      rectext.forEach((element) {
        searcher = searcher + element.text;
        doctorSearcher.add("${element.text}");
      });
      var splitter = searcher.split('\n');
      doctorSearcher = splitter;
      doctorSearcher = doctorSearcher.toSet().toList();

      print(doctorSearcher);

      emit(PickImageSuccesState());
    } else {
      emit(PickImageErrorState());
    }
  }

  Future<String> getImageForSeacrhPatient() async {
    String search = '';
    XFile? PickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (PickedFile != null) {
      textImage2 = File(PickedFile.path);
      List<TextBlock> rectext = await recogniseText(textImage2);
      rectext.forEach((element) {
        search = search + element.text;
      });

      emit(PickImageSuccesState());
    } else {
      emit(PickImageErrorState());
    }
    return search;
  }

  static Future<List<TextBlock>> recogniseText(File? image) async {
    List<dynamic> s = [''];
    if (image == null) {
      return s[0];
    } else {
      try {
        final visionimage = await GoogleMlKit.vision
            .textRecognizer()
            .processImage(InputImage.fromFile(image));

        final text = visionimage.blocks;
        return text.isEmpty ? s[0] : text;
      } catch (error) {
        return s[0];
      }
    }
  }

  void addsearchpharmacymedicine(
      int medicineid, int pharmacyid, context, String search) {
    emit(ChangeMedicineSatteLoadingState());
    DioHelper.postData(url: postPharmacyMedicineEndPoint, data: {
      'medicineId': medicineid,
      'pharmacyId': pharmacyid,
      'price': 60,
      'quantity': 60,
      'productStatusId': 10,
    }).then((value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('تم تغيير حالة العلاج'),
          actions: [
            TextButton(
                onPressed: () {
                  getsearchmedicine(search);
                  Navigator.pop(context);
                },
                child: Text('تم'))
          ],
        ),
      );
      emit(ChangeMedicineSatteSuccesState());
    }).catchError((error) {
      print(error.toString());
      emit(ChangeMedicineSatteErrorState());
    });
  }

  void deletesearchpharmacymedicine(
      int medicineid, int pharmacyid, context, String search) {
    emit(ChangeMedicineSatteLoadingState());
    DioHelper.deletedata(
        url: 'PharmacyMedicine/$medicineid/$pharmacyid',
        data: {
          'medicineId': medicineid,
          'pharmacyId': pharmacyid,
          'price': 60,
          'quantity': 60,
          'productStatusId': 10,
        }).then((value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('تم تغيير حالة العلاج'),
          actions: [
            TextButton(
                onPressed: () {
                  getsearchmedicine(search);
                  Navigator.pop(context);
                },
                child: Text('تم'))
          ],
        ),
      );
      emit(ChangeMedicineSatteSuccesState());
    }).catchError((error) {
      print(error.toString());
      emit(ChangeMedicineSatteErrorState());
    });
  }

  bool isactive = false;
  void changeisactive() {
    isactive = !isactive;
    emit(ChangeMedicineSatteSuccesState());
  }

  void addpharmacymedicine(int medicineid, int pharmacyid, context, int id) {
    emit(ChangeMedicineSatteLoadingState());
    DioHelper.postData(url: postPharmacyMedicineEndPoint, data: {
      'medicineId': medicineid,
      'pharmacyId': pharmacyid,
      'price': 60,
      'quantity': 60,
      'productStatusId': 10,
    }).then((value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('تم تغيير حالة العلاج'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('تم'))
          ],
        ),
      );
      emit(ChangeMedicineSatteSuccesState());
    }).catchError((error) {
      print(error.toString());
      emit(ChangeMedicineSatteErrorState());
    });
  }

  void deletepharmacymedicine(int medicineid, int pharmacyid, context, int id) {
    emit(ChangeMedicineSatteLoadingState());
    DioHelper.deletedata(
        url: 'PharmacyMedicine/$medicineid/$pharmacyid',
        data: {
          'medicineId': medicineid,
          'pharmacyId': pharmacyid,
          'price': 60,
          'quantity': 60,
          'productStatusId': 10,
        }).then((value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('تم تغيير حالة العلاج'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('تم'))
          ],
        ),
      );
      emit(ChangeMedicineSatteSuccesState());
    }).catchError((error) {
      print(error.toString());
      emit(ChangeMedicineSatteErrorState());
    });
  }

  Future<Map<String, dynamic>> updatepharmacymedicinelist(
      List<String> pharmacymedicines, String type) async {
    Map<String, dynamic> data = {};
    var search = jsonEncode(pharmacymedicines);
    print(search);
    emit(UpdatePharmacyMedicineLoadingState());
    try {
      final response = await http.put(
        Uri.parse(
            'http://amc007-001-site8.etempurl.com/api/PharmacyMedicine/$type/${pharmamodel!.id}'),
        body: search,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Successful response
        data = jsonDecode(response.body);
        emit(UpdatePharmacyMedicineSuccesState());
      } else {
        // Handle other status codes (e.g., 500 Internal Server Error)
        print('Error: ${response.reasonPhrase}');
        emit(UpdatePharmacyMedicineErrorState());
      }
    } catch (error) {
      // Handle other errors
      print('Unexpected Error: $error');
      emit(UpdatePharmacyMedicineErrorState());
    }
    return data;
  }
  /*
   try {
      await DioHelper.updatedata(
              url: 'PharmacyMedicine/$type/${pharmamodel!.id}', data: search)
          .then((value) {
        print(value);
        data = value.data;
        emit(UpdatePharmacyMedicineSuccesState());
      }).catchError((error) {
        print(error.toString());
        emit(UpdatePharmacyMedicineErrorState());
      });
    } catch (error) {
      print(error);
    }
  */

  /* void changeproductstatus(
      int pharmacyid, int medicineid, int status, int id, context) {
    emit(ChangeMedicineSatteLoadingState());
    DioHelper.updatedata(
      url: 'PharmacyMedicine/36/34',
      data: {
        "medicineId": medicineid,
        "pharmacyId": pharmacyid,
        "price": 50,
        "quantity": 100,
        "productStatusId": status
      },
    ).then((value) {
      getdoctorpharmacy();

      print('success');
      emit(ChangeMedicineSatteSuccesState());
    }).then((value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('تم تغيير حالة العلاج'),
          actions: [
            TextButton(
                onPressed: () {
                  getmpharmacymedicinesbyid(id);
                  Navigator.pop(context);
                },
                child: Text('تم'))
          ],
        ),
      );
    }).catchError((error) {
      print(error.toString());
      emit(ChangeMedicineSatteErrorState());
    });
  }

  List<int> mediciensid = [];
  List<int> productstatusid = [];*/
  void getDoctorPharmacy({required String licenceId}) {
    emit(GetDoctorPharmacyLoadingState());
    DioHelper.getData(url: getPharmacyEndPoint).then((value) {
      value.data['data'].forEach((element) {
        if (element['licenceId'] == licenceId) {
          pharmamodel = PharmacyModel.fromJson(element);
        }
      });
      /*pharmamodel!.medicines!.forEach((element) {
        productstatusid.add(element['productStatusId']);
        mediciensid.add(element['medicineId']);
      });*/
      emit(GetDoctorPharmacySuccesState());
    }).catchError((error) {
      print(error);
      emit(GetDoctorPharmacyErrorState());
    });
  }

/*
  List<MedicineModel> pharmacymedicines = [];
  Future<List<MedicineModel>> getmpharmacymedicinesbyid(int genericId) async {
    pharmacymedicines = [];
    emit(GetDoctorPharmacyMedicineLoadingState());
    await DioHelper.getData(url: getMedicineEndPoint).then((value) {
      value.data['data'].forEach((element) {
        if (element['genericId'] == genericId) {
          for (int i = 0; i < mediciensid.length; i++) {
            if (mediciensid[i] == element['id']) {
              pharmacymedicines.add(MedicineModel(
                  id: element['id'].toString(),
                  image: element['image'],
                  name: element['name'],
                  status: productstatusid[i].toString()));
            }
          }
        }
      });
      print(pharmacymedicines[0].status.toString());
      emit(GetDoctorPharmacyMedicineSuccesState());
    }).catchError((error) {
      print(error.toString());
      emit(GetDoctorPharmacyMedicineErrorState());
    });
    return pharmacymedicines;
  }*/
  double lat = 0;
  double lng = 0;
  Future<String> _extractLatLng({required String link}) async {
    final RegExp latLngRegExp = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
    final match = latLngRegExp.firstMatch(link);
    if (match != null) {
      lat = double.parse(match.group(1)!);
      lng = double.parse(match.group(2)!);
      print("Latitude: $lat, Longitude: $lng");
      return "Latitude: $lat, Longitude: $lng";
    } else {
      print("Couldn't extract latitude and longitude from the link.");
      return "Couldn't extract latitude and longitude from the link.";
    }
  }

  void updatepharmacy(int pharmacyId, String newlocation, String newaddress,
      String phone, String licenceId, context) {
    emit(UpdatePharmacyLoadingState());
    print("//////////////");
    print(pharmacyId);
    print("//////////////");
    print("//////////////");
    if (licenceId == pharmamodel!.licenseId) {
      _extractLatLng(link: newlocation);
      DioHelper.updatedata(url: 'Pharmacy/$pharmacyId', data: {
        "id": int.parse(pharmamodel!.id.toString()),
        "licenceId": licenceId,
        "email": "ostaz@gmai.com",
        "mobile": "01111111123",
        "phone": phone,
        "street": pharmamodel!.street,
        "name": pharmamodel!.name,
        "image": "ممممممممممممم",
        "description": "SDSADSAD",
        "originCountryName": "SADSAD",
        "productStatus": true,
        "address": newaddress,
        "location": 'newlocation',
        "longitude": pressPosition == null
            ? lng.toString()
            : pressPosition?.longitude.toString(),
        "latitude": pressPosition == null
            ? lat.toString()
            : pressPosition?.latitude.toString(),
        "workTime": "2023-05-24T21:26:21.808Z",
        "block": pharmamodel!.block,
        "areaId": pharmamodel!.areaId,
        "localityId": pharmamodel!.localityId
      }).then((value) {
        showmydialog(context, 'تم تغيير بيانات الصيجلية', Icons.verified);
        emit(UpdatePharmacySuccesState());
      }).catchError((error) {
        showmydialog(context, 'حدث خطأ في تحديث البيانات', Icons.warning);
        print(error);
        emit(UpdatePharmacyErrorState());
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('رقم الرخضة غير صحيح'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('تم'))
          ],
        ),
      );
    }
  }

  void changeBottomNAv(int index, PageController? _pageController) {
    currentIndex = index;
    _pageController!.animateToPage(currentIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
    emit(changeBottomNAvState());
  }

  bool? ExpanasionTouche;
  void changeExpanasionTouche(
    bool value,
  ) {
    value != ExpanasionTouche;
    emit(changeExpanasionToucheState());
  }

  String? result;
  void changeBarCodeResult(String ScanMethodResult) {
    this.result = ScanMethodResult;
    emit(changeBarCodeResultState());
  }
}
