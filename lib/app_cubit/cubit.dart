import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmazool/app/patient/nav_screens/barcode.dart';
import 'package:pharmazool/mymodels/GetPharmaciesByMedicineModel.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

import 'package:pharmazool/repo/services.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:http/http.dart' as http;
import 'package:pharmazool/mymodels/medicine_model.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isInitialized = false;

  int currentIndex = 0;
  List<Widget> screens = [
    const PatientHome(),
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

  void Patientlogin({
    required String username,
    required String password,
    required context,
  }) async {
    emit(PatientLoginLoadingState());
    try {
      final response = await DioHelper.postData(
          url: loginByPatientEndPoint,
          data: {'userName': username, 'password': password});

      print("Patient login ******");

      print(response.data);
      print("Patient login ******");
      PatientuserName = response.data['userName'];
      Patienttoken = response.data['token'];
      print("sucsess${response.data['title']}");
      emit(PatientLoginSuccesState(uId: Patienttoken!));
    } on DioException catch (error) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        if (statusCode == 409) {
          // Handle conflict error
          final errorBody = error.response!.data;
          final errorMessage = errorBody['title'];
          showmydialog(context, errorMessage, Icons.warning);
          emit(PatientLoginErrorState());
        } else {
          // Handle other errors
          showmydialog(context, 'حدث خطأ ما', Icons.warning);
          emit(PatientLoginErrorState());
        }
      } else {
        // Handle DioError without response
        showmydialog(context, error.toString(), Icons.warning);
        emit(PatientLoginErrorState());
      }
    } catch (error) {
      // Handle other errors
      showmydialog(context, 'حدث خطأ ما', Icons.warning);
      emit(PatientLoginErrorState());
    }
  }

  void Doctorlogin({
    required String username,
    required String password,
    required String licenseId,
    required String pharmacyName,
    required context,
  }) async {
    emit(DoctorLoginLoadingState());
    try {
      final response =
          await DioHelper.postData(url: loginByPharmacistEndPoint, data: {
        'userName': username,
        'password': password,
        "licenseId": licenseId,
        "pharmacyName": pharmacyName
      });

      print("Doctor login ******");

      print(response.data);
      print("Doctor login ******");
      DoctoruserName = response.data['userName'];
      Doctortoken = response.data['token'];
      print("sucsess${response.data['title']}");
      emit(DoctorLoginSuccesState());
    } on DioException catch (error) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        if (statusCode == 409) {
          // Handle conflict error
          final errorBody = error.response!.data;
          final errorMessage = errorBody['title'];
          showmydialog(context, errorMessage, Icons.warning);
        } else {
          // Handle other errors
          showmydialog(context, 'حدث خطأ ما', Icons.warning);
        }
      } else {
        // Handle DioError without response
        showmydialog(context, error.toString(), Icons.warning);
      }
    } catch (error) {
      // Handle other errors
      showmydialog(context, 'حدث خطأ ما', Icons.warning);
      emit(DoctorLoginErrorState());
    }
  }

  void resetPassword(
      {required String phonenumber,
      required String password,
      required String licenceId,
      required String pharmacyName,
      required int type}) {
    DioHelper.postData(url: resetPasswordEndPoint, data: {
      "phoneNumber": phonenumber,
      "licenseId": licenceId,
      "pharmacyName": pharmacyName,
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
          print("${element['licenceId']}licenceIdlicenceId");
        } else {
          print("${element['licenceId']}licenceId");
          print("${element['name']}name");
        }
      });
      emit(DoctorCheckRegisterSuccesState());
    }).catchError((error) {
      emit(DoctorCheckRegisterErrorState());
      print("$error ggggggggggggggggggggggggggggggggggggggggggg");
    });
    return isverified;
  }

  bool naveValidArabic = false;
  bool doesNotHaveArabic(String input) {
    return naveValidArabic = !RegExp(
            r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(input);
  }

  void patientRegister({
    required String username,
    required String phone,
    required String password,
    required int type,
    required context,
  }) async {
    emit(AppRegisterLoadingState());
    try {
      final response =
          await DioHelper.postData(url: registerByPatientEndPoint, data: {
        'firstName': 'hossam12',
        'lastName': 'string',
        'phone': phone,
        'email': 'hossam2@gmail.com',
        'userName': username,
        'password': password,
        // 'licenseId': 'sdas5445',
        // 'type': '$type'
      });
      showmydialog(
          context, 'تم انشاء الحساب', Icons.assignment_turned_in_outlined);
      emit(DoctorRegisterSuccesState());
    } on DioException catch (error) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        if (statusCode == 409) {
          // Handle conflict error
          final errorBody = error.response!.data;
          final errorMessage = errorBody['title'];
          print(errorMessage);
          showmydialog(context, errorMessage, Icons.warning);
        } else {
          // Handle other errors
          showmydialog(context, 'حدث خطأ ما', Icons.warning);
        }
      } else {
        // Handle DioError without response
        showmydialog(context, error.toString(), Icons.warning);
      }
      emit(AppRegisterErrorState(errorMessage: error.toString()));
    } catch (error) {
      // Handle other errors
      showmydialog(context, 'حدث خطأ ما', Icons.warning);
      emit(AppRegisterErrorState(errorMessage: error.toString()));
    }
  }

  void doctorRegister({
    required String username,
    required String phone,
    required String password,
    required int type,
    required String licenceId,
    required String pharmacyName,
    context,
  }) async {
    emit(DoctorRegisterLoadingState());

    try {
      final response =
          await DioHelper.postData(url: registerByPharmcistEndPoint, data: {
        'firstName': 'hossam13',
        'lastName': 'string',
        'phone': phone,
        'email': 'hossam4@gmail.com',
        'userName': username,
        'password': password,
        'licenseId': licenceId,
        'pharmacyName': pharmacyName,
      });

      print("Doctor Register ******");
      print(response.data);
      print("Doctor Register ******");

      PatientuserName = response.data['userName'];
      Patienttoken = response.data['token'];
      showmydialog(
          context, 'تم انشاء الحساب', Icons.assignment_turned_in_outlined);
      emit(DoctorRegisterSuccesState());
    } on DioException catch (error) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        if (statusCode == 409) {
          // Handle conflict error
          final errorBody = error.response!.data;
          final errorMessage = errorBody['title'];
          showmydialog(context, errorMessage, Icons.warning);
        } else {
          // Handle other errors
          showmydialog(context, 'حدث خطأ ما', Icons.warning);
        }
      } else {
        // Handle DioError without response
        showmydialog(context, error.toString(), Icons.warning);
      }
      emit(DoctorRegisterErrorState(error: error.toString()));
    } catch (error) {
      // Handle other errors
      showmydialog(context, 'حدث خطأ ما', Icons.warning);
      emit(DoctorRegisterErrorState(error: error.toString()));
    }
  }

  bool checkarea = false;
  // List<PharmacyModel>? filteredpharmacyList;
  List<PharmacyModel> pharmacyList = [];
  List<GetPharmaciesByMedicineModel> PharmaciesByMedicineIdList = [];
  List<Marker> pharmaciesmarkers = [];
  List<GetPharmaciesByMedicineModel> nearestpharmacies = [];
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
      print(
          "pressPositionpressPositionpressPositionpressPositionpressPosition $pressPosition");
      controller2 = TextEditingController(text: "تم تحديد موقع الصيدلية بنحاح");
      emit(GetPressPositionSuccess());
    }).catchError((e) {
      print("Error in get Press Position $e");
      emit(GetPressPositionError());
    });
  }

  List<String> streetAllPharmacy = [];
  void getpharmacies(
      {int? id, String? area, String? locality, String? street}) {
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
      // for (GetPharmaciesByMedicineModel pharmacyItem in pharmacyModelData?.data ?? []) {
      //   if (pharmacyItem.latitude!= '' || pharmacyItem.longitude != '') {
      //     var distance = Geolocator.distanceBetween(
      //       double.parse(pharmacyItem.latitude ?? '0.0'),
      //       double.parse(pharmacyItem.longitude ?? '0.0'),
      //       position?.latitude ?? 0.0,
      //       position?.longitude ?? 0.0,
      //     );

      //     if (distance <= 199909) {
      //       nearestpharmacies.add(
      //         pharmacyItem,
      //       );
      //     }
      //   }
      // }

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

  void getPharmaciesByMedicineIdmodel({required String? MedicineId}) async {
    PharmaciesByMedicineIdList = [];
    getCurrentLocation();
    emit(GetPharmaciesByMedicineLoadingState());

    await DioHelper.getData(
            url: "PharmacyMedicine/GetPharmaciesByMedicineId/$MedicineId")
        .then((value) {
      List<dynamic> data = value.data;
      List<GetPharmaciesByMedicineModel> pharmacies = data
          .map((item) => GetPharmaciesByMedicineModel.fromJson(item))
          .toList();
      PharmaciesByMedicineIdList.addAll(pharmacies);
      emit(GetPharmaciesByMedicineSuccesState());
    }).catchError((error) {
      print(error);
      emit(GetPharmaciesByMedicineErrorState());
    });
  }

// Define a method to filter pharmacies by nearest place within the specified distance
  List<GetPharmaciesByMedicineModel> filteredPharmacies = [];

  Future<List<GetPharmaciesByMedicineModel>> filterPharmaciesByDistance(
    List<GetPharmaciesByMedicineModel> pharmacies,
    double maxDistance,
  ) async {
    // Get current device location
    // Position position = await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.high,
    // );

    // Filter pharmacies by distance

    for (var pharmacy in pharmacies) {
      double distanceInMeters = Geolocator.distanceBetween(
        position!.latitude,
        position!.longitude,
        double.parse(pharmacy.latitude!), // Assuming lat is a String
        double.parse(pharmacy.longitude!), // Assuming long is a String
      );

      print(pharmacy.latitude!);
      print(pharmacy.longitude!);
      print(position!.latitude);
      print(position!.longitude);
      print("distanceInMeters$distanceInMeters");
      if (distanceInMeters <= maxDistance) {
        filteredPharmacies.add(pharmacy);
      }
    }

    return filteredPharmacies;
  }

// Call this method in your getFilteredPharmaciesByMedicineIdmodel function
  void getFilteredPharmaciesByMedicineIdmodel(
      {required String? MedicineId}) async {
    nearestpharmacies = [];
    filteredPharmacies = [];
    getCurrentLocation();
    emit(GetFilteredPharmaciesByMedicineLoadingState());

    await DioHelper.getData(
            url: "PharmacyMedicine/GetPharmaciesByMedicineId/$MedicineId")
        .then((value) async {
      List<dynamic> data = value.data;
      List<GetPharmaciesByMedicineModel> pharmacies = data
          .map((item) => GetPharmaciesByMedicineModel.fromJson(item))
          .toList();

      // Filter pharmacies by distance
      nearestpharmacies = await filterPharmaciesByDistance(
        pharmacies,
        199909, // Max distance in meters
      );

      emit(GetFilteredPharmaciesByMedicineSuccesState());
    }).catchError((error) {
      print(error);
      emit(GetFilteredPharmaciesByMedicineErrorState());
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

  void getStateList({int count = 8}) {
    emit(GetStateLoading());
    DioHelper.getData(url: 'State', query: {'PageSize': 19}).then((value) {
      stateModel = StateModel.fromJson(value.data);
      print(stateModel?.data?.length);
      emit(GetStateSuccess());
    }).catchError((e) {
      emit(GetStateError());
      print("Error in GEt Area");
    });
  }

  AreaModel? areaModel;

  void getAreaList({int count = 8}) {
    emit(GetAreaListLoading());
    DioHelper.getData(url: 'Area', query: {'PageSize': 2288}).then((value) {
      areaModel = AreaModel.fromJson(value.data);
      emit(GetAreaListSuccess());
    }).catchError((e) {
      emit(GetAreaListError());
      print("Error in GEt Area");
    });
  }

  LocalityModel? localityModel;
  void getLocalityList({int count = 8}) {
    emit(GetLocalityLoading());
    DioHelper.getData(url: 'Locality', query: {"PageSize": 110}).then((value) {
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

// ...

  Future<String> getGalleryImageForPatientSearch() async {
// create an instance of AppCubit

    String search = '';
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      textImage = File(pickedFile.path);

      // Open the image in the cropper and get the cropped image
      File? croppedFile = await CropImage(textImage!);

      print('Cropped Image Path: ${croppedFile?.path}');

      if (croppedFile != null) {
        List<TextBlock> rectext = await recogniseText(croppedFile);
        for (var element in rectext) {
          search = search + element.text;
        }

        emit(PickImageSuccesState());
      } else {
        emit(PickImageErrorState());
      }
    } else {
      emit(PickImageErrorState());
    }

    return search;
  }

  Future<File?> CropImage(File originalImage) async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: originalImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'قص الصوره ',
        toolbarColor: Color(0xff1F252F),
        toolbarWidgetColor: ui.Color.fromARGB(255, 230, 167, 128),
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );
    print('Original Image Path: ${originalImage.path}');
    return croppedFile;
  }

  Future<void> getPostImage() async {
    XFile? PickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    searcher = '';
    doctorSearcher = [''];
    if (PickedFile != null) {
      textImage = File(PickedFile.path);
      // Open the image in the cropper and get the cropped image
      File? croppedFile = await CropImage(textImage!);

      print('Cropped Image Path: ${croppedFile?.path}');
      if (croppedFile != null) {
        List<TextBlock> rectext = await recogniseText(croppedFile);
        for (var element in rectext) {
          searcher = searcher + element.text;
          doctorSearcher.add(element.text);
        }
        var splitter = searcher.split('\n');
        doctorSearcher = splitter;
        doctorSearcher = doctorSearcher.toSet().toList();

        emit(PickImageSuccesState());
      } else {
        emit(PickImageErrorState());
      }
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
      // Open the image in the cropper and get the cropped image
      File? croppedFile = await CropImage(textImage2!);
      print('Cropped Image Path: ${croppedFile?.path}');
      if (croppedFile != null) {
        List<TextBlock> rectext = await recogniseText(croppedFile);
        for (var element in rectext) {
          searcher = searcher + element.text;
          doctorSearcher.add(element.text);
        }
        var splitter = searcher.split('\n');
        doctorSearcher = splitter;
        doctorSearcher = doctorSearcher.toSet().toList();

        print(doctorSearcher);

        emit(PickImageSuccesState());
      } else {
        emit(PickImageErrorState());
      }
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

      // Open the image in the cropper and get the cropped image
      File? croppedFile = await CropImage(textImage2!);

      print('Cropped Image Path: ${croppedFile?.path}');

      if (croppedFile != null) {
        List<TextBlock> rectext = await recogniseText(croppedFile);
        for (var element in rectext) {
          search = search + element.text;
        }

        emit(PickImageSuccesState());
      } else {
        emit(PickImageErrorState());
      }
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
          title: const Text(
            'تم تغيير حالة العلاج',
            style: TextStyles.styleblackDefault,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  getsearchmedicine(search);
                  Navigator.pop(context);
                },
                child: const Text(
                  'تم',
                  style: TextStyles.styleblackDefault,
                ))
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
          title: const Text(
            'تم تغيير حالة العلاج',
            style: TextStyles.styleblackDefault,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  getsearchmedicine(search);
                  Navigator.pop(context);
                },
                child: const Text(
                  'تم',
                  style: TextStyles.styleblackDefault,
                ))
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
          title: const Text(
            'تم تغيير حالة العلاج',
            style: TextStyles.styleblackDefault,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'تم',
                  style: TextStyles.styleblackDefault,
                ))
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
          title: const Text(
            'تم تغيير حالة العلاج',
            style: TextStyles.styleblackDefault,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'تم',
                  style: TextStyles.styleblackDefault,
                ))
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
          title: const Text(
            'رقم الرخضة غير صحيح',
            style: TextStyles.styleblackDefault,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('تم'))
          ],
        ),
      );
    }
  }

  void changeBottomNAv(int index, PageController? pageController) {
    currentIndex = index;
    pageController!.animateToPage(currentIndex,
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
    result = ScanMethodResult;
    emit(changeBarCodeResultState());
  }
}
