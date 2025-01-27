import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmazool/app/patient/nav_screens/barcode.dart';
import 'package:pharmazool/mymodels/GetPharmaciesByMedicineModel.dart';
import 'package:pharmazool/src/core/constant/app_constant.dart';
import 'package:pharmazool/src/core/utils/app_strings.dart';
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

  var searchPatientList = [];
  void getsearchmedicinePatient(String search) {
    searchPatientList = [];
    emit(GetMedicinesByIdLoadingState());
    //get data without pagination
    DioHelper.getData(
      url: 'Medicine/GetAllMedicine?Search=$search',
    ).then((value) {
      value.data['data'].forEach((element) {
        MedicineModel medicine = MedicineModel.fromJson(element);

        // Check if the name starts with the specified character
        if ((medicine.name!.toLowerCase().startsWith(search.toLowerCase()) ||
            medicine.name!.startsWith(search) ||
            medicine.tradeName!
                .toLowerCase()
                .startsWith(search.toLowerCase()) ||
            medicine.tradeName!.startsWith(search))) {
          // If it does, add it to the list
          searchPatientList.add(medicine);
        }
      });
      search = '';
      updatestatus(searchPatientList);
      emit(GetMedicinesByIdSuccesState());
    }).catchError((error) {
      print(error);
      emit(GetMedicinesByIdErrorState());
    });
  }

  var searchDoctorList = [];
  Future<void> getsearchmedicineDoctor(String search) async {
    searchDoctorList = [];
    emit(GetMedicinesByIdLoadingState());
    //get data without pagination
    await DioHelper.getData(
      url: 'Medicine/GetAllMedicine?Search=$search',
    )
        .then((value) {
          value.data['data'].forEach((element) {
            MedicineModel medicine = MedicineModel.fromJson(element);

            // Check if the name starts with the specified character
            if ((medicine.name!
                    .toLowerCase()
                    .startsWith(search.toLowerCase()) ||
                medicine.name!.startsWith(search) ||
                medicine.tradeName!
                    .toLowerCase()
                    .startsWith(search.toLowerCase()) ||
                medicine.tradeName!.startsWith(search))) {
              // If it does, add it to the list
              searchDoctorList.add(medicine);
            }
          });
        })
        .then((value) async => {
              await DioHelper.getData(
                url:
                    'PharmacyMedicine/GetMedicinesByPharmacyId/${int.parse(pharmamodel!.id!)}',
              ).then((value) {
                List<dynamic> secondApiResponse = value.data;
                print(secondApiResponse);
                print("${value.data[0]["name"]}======");
                // Update status based on matching names
                for (var medicine in searchDoctorList) {
                  var matchingItems = secondApiResponse
                      .where(
                        (item) => item['name'] == medicine.name,
                      )
                      .toList();
                  print("${medicine.name}   medicine.namemedicine.name");
                  if (matchingItems.isNotEmpty) {
                    medicine.status = true;
                    print("${medicine.status}  medicine.statusmedicine.status");
                  } else {
                    medicine.status = false;
                    print("${medicine.status}  medicine.statusmedicine.status");
                  }
                }

                search = '';
                // updatestatus(searchDoctorList);
                emit(GetMedicinesByIdSuccesState());
              }).catchError((error) {
                print(error);
                emit(GetMedicinesByIdErrorState());
              })
            })
        .catchError((error) {
          print(error);
          emit(GetMedicinesByIdErrorState());
        });
  }

  List<MedicineModel> medicinesPatientbyId = [];
  List<MedicineModel> medicinesDoctorbyId = [];

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
    medicinesPatientbyId = [];
    emit(SearchGenericMedicinePatientLoadingState());
    DioHelper.getData(
      url: 'Medicine/GetMedicineByGeneric?genericId=$id&Search=$search',
    ).then((value) {
      value.data['data'].forEach((element) {
        MedicineModel medicine = MedicineModel.fromJson(element);
        // Check if the name starts with the specified character
        if ((medicine.name!.toLowerCase().startsWith(search.toLowerCase()) ||
            medicine.name!.startsWith(search) ||
            medicine.tradeName!
                .toLowerCase()
                .startsWith(search.toLowerCase()) ||
            medicine.tradeName!.startsWith(search))) {
          // If it does, add it to the list
          medicinesPatientbyId.add(medicine);
        }
      });
      emit(SearchGenericMedicinePatientSuccesState());
    }).catchError((error) {
      emit(SearchGenericMedicinePatientErrorState());
    });
  }

  void getMedicinesDoctorByID({int id = 0, String search = ""}) async {
    medicinesDoctorbyId = [];
    emit(GetMedicinesByIdLoadingState());

    try {
      // Make the first API call
      var value = await DioHelper.getData(
        url:
            'Medicine/GetMedicineByGeneric?genericId=$id&PageSize=15&Search=$search',
      );

      // Process the response
      List<dynamic> data = value.data['data'];
      for (var element in data) {
        MedicineModel medicine = MedicineModel.fromJson(element);
        if ((medicine.name!.toLowerCase().startsWith(search.toLowerCase()) ||
            medicine.name!.startsWith(search) ||
            medicine.tradeName!
                .toLowerCase()
                .startsWith(search.toLowerCase()) ||
            medicine.tradeName!.startsWith(search))) {
          medicinesDoctorbyId.add(medicine);
        }
      }

      // Make the second API call
      value = await DioHelper.getData(
        url:
            'PharmacyMedicine/GetMedicinesByPharmacyId/${int.parse(pharmamodel!.id!)}',
      );

      // Process the second response and update medicine status
      List<dynamic> secondApiResponse = value.data;
      for (var medicine in medicinesDoctorbyId) {
        var matchingItems =
            secondApiResponse.where((item) => item['name'] == medicine.name);
        medicine.status = matchingItems.isNotEmpty;
      }

      // Update UI state
      search = '';
      emit(GetMedicinesByIdSuccesState());
    } catch (error) {
      print("$error errorrrr");
      emit(GetMedicinesByIdErrorState());
    }
  }

  void getMedicinesPatientByID({int id = 0, String search = ""}) {
    medicinesPatientbyId = [];
    emit(GetMedicinesByIdLoadingState());
    DioHelper.getData(
      url: 'Medicine/GetMedicineByGeneric?genericId=$id&Search=$search',
    ).then((value) {
      value.data['data'].forEach((element) {
        MedicineModel medicine = MedicineModel.fromJson(element);
        // Check if the name starts with the specified character
        print(id);
        if ((medicine.name!.toLowerCase().startsWith(search.toLowerCase()) ||
            medicine.name!.startsWith(search) ||
            medicine.tradeName!
                .toLowerCase()
                .startsWith(search.toLowerCase()) ||
            medicine.tradeName!.startsWith(search))) {
          // If it does, add it to the list
          medicinesPatientbyId.add(medicine);
        }
      });
      updatestatus(medicinesPatientbyId);
      emit(GetMedicinesByIdSuccesState());
    }).catchError((error) {
      emit(GetMedicinesByIdErrorState());
    });
  }

  // void medicinelistpagination(
  //     {List<MedicineModel>? medicinelist,
  //     int? page,
  //     int? id,
  //     String? search}) async {
  //   emit(IncreamentOfMedicineListLoadingState());
  //   GetMedicineData data = GetMedicineData();
  //   try {
  //     // await data.medicinelistpaginationRepo(medicinelist!, id!, page!, search!);
  //     if (medicinelist!.isNotEmpty) {
  //       await DioHelper.getData(
  //         url:
  //             'Medicine/GetMedicineByGeneric?genericId=$id&PageIndex=$page&PageSize=15',
  //       ).then((value) {
  //         value.data['data'].forEach((element) {
  //           emit(IncreamentOfMedicineListLoadingState());
  //           medicinelist.add(MedicineModel.fromJson(element));
  //         });
  //       }).then((value) async {
  //         await DioHelper.getData(
  //           url:
  //               'PharmacyMedicine/GetMedicinesByPharmacyId/${int.parse(pharmamodel!.id!)}',
  //         ).then((value) {
  //           List<dynamic> secondApiResponse = value.data;
  //           print(secondApiResponse);
  //           print("${value.data[0]["name"]}======");

  //           // Update status based on matching names
  //           for (var medicine in medicinelist) {
  //             var matchingItems = secondApiResponse
  //                 .where(
  //                   (item) => item['name'] == medicine.name,
  //                 )
  //                 .toList();
  //             print("${medicine.name}   medicine.namemedicine.name");
  //             if (matchingItems.isNotEmpty) {
  //               medicine.status = true;
  //               print("${medicine.status}  medicine.statusmedicine.status");
  //             } else {
  //               medicine.status = false;
  //               print("${medicine.status}  medicine.statusmedicine.status");
  //             }
  //           }

  //           search = '';
  //           emit(IncreamentOfMedicineListSuccesState());
  //         }).catchError((error) {
  //           print(error);
  //         });
  //       }).catchError((error) {
  //         print(error.toString());
  //       });
  //     }
  //     // emit(IncreamentOfMedicineListSuccesState());
  //     // return medicinelist;
  //   } catch (error) {
  //     print(error);
  //     emit(IncreamentOfMedicineListErrorState());
  //   }
  // }

  void medicinelistpagination({
    List<MedicineModel>? medicinelist,
    int? page,
    int? id,
    String? search,
  }) async {
    emit(IncreamentOfMedicineListLoadingState());

    try {
      if (medicinelist!.isEmpty) {
        // If the list is empty, return early
        return;
      }

      // Make the first API call to get medicines
      var value = await DioHelper.getData(
        url:
            'Medicine/GetMedicineByGeneric?genericId=$id&PageIndex=$page&PageSize=15',
      );

      // Process the response and add medicines to the list
      List<dynamic> data = value.data['data'];
      for (var element in data) {
        medicinelist.add(MedicineModel.fromJson(element));
      }

      // Make the second API call to get pharmacy medicines
      value = await DioHelper.getData(
        url:
            'PharmacyMedicine/GetMedicinesByPharmacyId/${int.parse(pharmamodel!.id!)}',
      );

      // Process the second response and update medicine status
      List<dynamic> secondApiResponse = value.data;
      for (var medicine in medicinelist) {
        var matchingItems =
            secondApiResponse.where((item) => item['name'] == medicine.name);
        medicine.status = matchingItems.isNotEmpty;
      }

      search = '';
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
      secureStorage.write(key: SecureStorageKey.patientName, value: username);

      secureStorage.write(key: SecureStorageKey.patientPhone, value: password);

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
      if (response.statusCode == 200) {
        print("Doctor login ******");

        print(response.data);
        print("Doctor login ******");
        DoctoruserName = response.data['userName'];
        Doctortoken = response.data['token'];
        print("sucsess${response.data['title']}");
        getPharmacyNameFromSignIn(PharmacyNameFromController: pharmacyName);
        PharmacyNameFromController = pharmacyName;
        print("$PharmacyNameFromController 00000000000");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeLayoutDoctor()));
        secureStorage.write(
            key: SecureStorageKey.doctorLicense, value: licenseId);

        secureStorage.write(
            key: SecureStorageKey.doctorPharmacyName, value: pharmacyName);
        secureStorage.write(
            key: SecureStorageKey.doctorUserName, value: username);
        secureStorage.write(key: SecureStorageKey.doctorPass, value: password);

        emit(DoctorLoginSuccesState());
      }
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

  void resetByDoctorPassword({
    required String phonenumber,
    required String newPassword,
    required String licenceId,
    required String pharmacyName,
    required context,
  }) async {
    try {
      final response = await DioHelper.postData(
          url: resetPasswordByPharmacistEndPoint,
          data: {
            "phoneNumber": phonenumber,
            "licenseId": licenceId,
            "pharmacyName": pharmacyName,
            "newPassword": newPassword
          });

      ResetResponseText = response.data;
      print("sucsess$ResetResponseText");
      showmydialog(context, ResetResponseText!, Icons.lock_open);
      emit(AppResetPasswordByDoctorSuccesState());
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
      emit(AppResetPasswordByDoctorErrorState());
    }
  }

  void resetPasswordByPatient({
    required String phonenumber,
    required String newPassword,
    required context,
  }) async {
    try {
      final response = await DioHelper.postData(
          url: resetPasswordByPatientEndPoint,
          data: {"phoneNumber": phonenumber, "newPassword": newPassword});

      ResetResponseText = response.data;
      print("sucsess$ResetResponseText");
      showmydialog(context, ResetResponseText!, Icons.lock_open);
      emit(AppResetPasswordByPatientSuccesState());
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
      emit(AppResetPasswordByPatientErrorState());
    }
  }

  Future<bool> checkpharmacy(String licId, String name) async {
    bool? isverified;
    await DioHelper.getData(url: "$GetPharmacyCheckEndPoint$licId/$name")
        .then((value) {
      isverified = value.data;
      print(isverified);
      emit(DoctorCheckRegisterSuccesState());
    }).catchError((error) {
      emit(DoctorCheckRegisterErrorState());
      print("$error ggggggggggggggggggggggggggggggggggggggggggg");
    });
    return isverified!;
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
    // required String password,
    // required int type,
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
        // 'password': password,
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
    print("position:$position");
    print("position  :$position");
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
  void getpharmacies({
    int? id,
    String? area,
    String? locality,
    String? street,
  }) {
    getCurrentLocation();
    nearestpharmacies = [];
    emit(GetPharmaciesLoadingState());
    DioHelper.getData(url: "Pharmacy").then((value) {
      pharmacyModelData = PharmacyModelData.fromJson(value.data);
      // to Store all pharmacy
      pharmacyModelData?.data?.forEach((element) {
        pharmacyList.add(element);
        // to Store All Street Pharmaces
        streetAllPharmacy.add(element.street ?? '');
      });

      // for (PharmacyModel pharmacy in pharmacyModelData!.data!) {
      //   if (pharmacy.name == PharmacyNameFromController) {
      //     pharmamodel = pharmacy;
      //     print("${pharmamodel!.id}================");
      //     emit(GetPharmaciesSuccesState());
      //     return;
      //   }
      // }

      print("${pharmamodel!.id}================");
      emit(GetPharmaciesSuccesState());
    }).catchError((error) {
      print(error);
      emit(GetPharmaciesErrorState());
    });
  }

  void getPharmacyNameFromSignIn(
      {int? id,
      String? area,
      String? locality,
      String? street,
      required String PharmacyNameFromController}) {
    getCurrentLocation();
    nearestpharmacies = [];
    emit(GetPharmaciesLoadingState());
    DioHelper.getData(url: "Pharmacy?Search=$PharmacyNameFromController")
        .then((value) {
      pharmacyModelData = PharmacyModelData.fromJson(value.data);
      // to Store all pharmacy
      pharmacyModelData?.data?.forEach((element) {
        pharmacyList.add(element);
        // to Store All Street Pharmaces
        streetAllPharmacy.add(element.street ?? '');
      });

      // Clear previous data
      // pharmamodel = null;
      // Find the pharmacy with matching name
      for (PharmacyModel pharmacy in pharmacyModelData!.data!) {
        if (pharmacy.name == PharmacyNameFromController) {
          pharmamodel = pharmacy;
          print("${pharmamodel!.id}=====0000000000===========");
          emit(GetPharmaciesSuccesState());
          return;
        }
      }
      // // Create PharmacyModel instances
      // pharmamodel = pharmacyModelData!.data![index];
      print("${pharmamodel!.id}================");
      emit(GetPharmaciesSuccesState());
    }).catchError((error) {
      print(error);
      emit(GetPharmaciesErrorState());
    });
  }

  void getPharmaciesByMedicineIdmodel(
      {required String? MedicineId,
      String? localityName,
      String? areaName,
      String? stateName}) async {
    PharmaciesByMedicineIdList = [];
    getCurrentLocation();
    emit(GetPharmaciesByMedicineLoadingState());

    await DioHelper.getData(
            url:
                "$getPharmaciesByMedicineIDEndPoint$MedicineId?localityName=$localityName&areaName=$areaName&stateName=$stateName")
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
      double? latitude;
      double? longitude;

      try {
        latitude = double.parse(pharmacy.latitude!);
      } catch (e) {
        latitude = 0.0; // default to 0 if parsing fails
      }

      try {
        longitude = double.parse(pharmacy.longitude!);
      } catch (e) {
        longitude = 0.0; // default to 0 if parsing fails
      }
      double distanceInMeters = Geolocator.distanceBetween(
          position!.latitude, position!.longitude, latitude, longitude);

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
    print("$MedicineId MedicineIdMedicineIdMedicineId");
    await DioHelper.getData(
            url: "$getPharmaciesByMedicineIDEndPoint$MedicineId")
        .then((value) async {
      List<dynamic> data = value.data;
      List<GetPharmaciesByMedicineModel> pharmacies = data
          .map((item) => GetPharmaciesByMedicineModel.fromJson(item))
          .toList();

      // Filter pharmacies by distance
      nearestpharmacies = await filterPharmaciesByDistance(
          pharmacies,
          // 199909,
          40000
          // Max distance in meters
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
                  getsearchmedicinePatient(search);
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
                  getsearchmedicineDoctor(search);
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
            'https://api.pharmazool.org/api/PharmacyMedicine/$type/${pharmamodel!.id}'),
        body: search,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Successful response
        data = jsonDecode(response.body);
        // print('Status Code: ${response.body}');
        emit(UpdatePharmacyMedicineSuccesState());
      } else {
        // Handle other status codes (e.g., 500 Internal Server Error)
        print('Status Code: ${response.body}');
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

  void updatepharmacymedicineItem(
      List<String> pharmacymedicine, String type, context) async {
    // Map<String, dynamic> data = {};
    var search = jsonEncode(pharmacymedicine);
    print(search);
    emit(UpdatePharmacyMedicineLoadingState());
    try {
      final response = await http.put(
        Uri.parse(
            'https://api.pharmazool.org/api/PharmacyMedicine/$type/${pharmamodel!.id}'),
        body: search,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(
              response.body.contains("هذا المنتج ليس موجود داخل الصيدلية")
                  ? "هذا المنتج ليس موجود داخل الصيدلية"
                  : response.body.contains("تم اضافة هذا المنتج بنجاح")
                      ? "تم اضافة هذا المنتج بنجاح"
                      : response.body.contains("تم حذف هذا المنتج بنجاح")
                          ? "تم حذف هذا المنتج بنجاح"
                          : response.body ?? "",
              style: TextStyles.styleblackDefault,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    // getsearchmedicine(pharmacymedicine);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'تم',
                    style: TextStyles.styleblackDefault,
                  ))
            ],
          ),
        );

        emit(UpdatePharmacyMedicineSuccesState());
      } else {
        // Handle other status codes (e.g., 500 Internal Server Error)
        print('Status Code: ${response.body}');
        print('Error: ${response.reasonPhrase}');
        emit(UpdatePharmacyMedicineErrorState());
      }
    } catch (error) {
      // Handle other errors
      print('Unexpected Error: $error');
      emit(UpdatePharmacyMedicineErrorState());
    }
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
        print("${pharmamodel!.id}================");
        if (element['licenceId'] == licenceId) {
          pharmamodel = PharmacyModel.fromJson(element);
          print("${pharmamodel!.id}================");
        }
        pharmamodel = PharmacyModel.fromJson(element);
        print("${pharmamodel!.id}================");
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

  String? access_provider_token;

  Future<UserCredential> signInWithGoogle(context) async {
    await GoogleSignIn().signOut();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final String accessToken = googleAuth!.idToken!;
    access_provider_token = accessToken;
    // Now you can pass this accessToken to your backend
    log('Access Provider Token:$accessToken');
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Print credential details
    log('Credential: ${credential.accessToken!}');
    log('idToken: ${googleAuth.idToken}');

    // Once signed in, return the UserCredential
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Print the UserCredential details
    log('UserCredential: ${userCredential.toString()}');
    log('User Info: ${userCredential.user.toString()}');
    log('Additional Info: ${userCredential.additionalUserInfo.toString()}');

    return userCredential;
  }

  void Googlelogin({
    required context,
  }) async {
    emit(GoogleLoginLoadingState());
    try {
      final response = await DioHelper.postData(
          url: patientGoogleloginEndPoint,
          data: {'tokenId': access_provider_token});

      print("Google Patient login ******");

      print(response.data);
      print(" GooglePatient login ******");
      PatientuserName = response.data['userName'];
      Patienttoken = response.data['token'];
      print("sucsess${response.data['title']}");
      // secureStorage.write(key: SecureStorageKey.patientName, value: username);

      // secureStorage.write(key: SecureStorageKey.patientPhone, value: password);

      emit(GoogleLoginSuccesState(uId: Patienttoken!));
    } on DioException catch (error) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        if (statusCode == 409) {
          // Handle conflict error
          final errorBody = error.response!.data;
          final errorMessage = errorBody['title'];
          showmydialog(context, errorMessage, Icons.warning);
          emit(GoogleLoginErrorState());
        } else {
          // Handle other errors
          showmydialog(context, 'حدث خطأ ما', Icons.warning);
          emit(GoogleLoginErrorState());
        }
      } else {
        // Handle DioError without response
        showmydialog(context, error.toString(), Icons.warning);
        emit(GoogleLoginErrorState());
      }
    } catch (error) {
      // Handle other errors
      showmydialog(context, 'حدث خطأ ما', Icons.warning);
      emit(GoogleLoginErrorState());
    }
  }
}
