 import 'package:pharmazool/src/core/config/routes/app_imports.dart';

part 'profilepharmacy_state.dart';

class ProfilePharmacyCubit extends Cubit<ProfilePharmacyState> {
  ProfilePharmacyCubit() : super(ProfilePharmacyInitial());

  static ProfilePharmacyCubit get(context) => BlocProvider.of(context);

  TextEditingController linkLocationController = TextEditingController();

  Position? pressPosition;
  void getPressLocation() async {
    emit(GetPressPositionProfileLoading());
    await Geolocator.getCurrentPosition().then((currentP) {
      pressPosition = currentP;
      linkLocationController =
          TextEditingController(text: "تم تحديد موقع الصيدلية بنحاح");
      emit(GetPressPositionProfileSuccess());
    }).catchError((e) {
      print("Error in get Press Position $e");
      emit(GetPressPositionProfileError());
    });
  }

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

  void ahmedUpdatePharmacyOptional(
      {required String newLocation,
      required String phone,
      required BuildContext context,
      required int areaId,
      required int localityId,
      required String street,
      required int stateId,
      required String address}) {
    pressPosition == null ? _extractLatLng(link: newLocation) : null;
    DioHelper.updatedata(url: 'Pharmacy/${pharmamodel?.id}', data: {
      "id": int.parse("${pharmamodel?.id}"),
      "licenceId": "${pharmamodel?.licenseId}",
      "email": "ostaz@gmai.com",
      "mobile": "01111111123",
      "phone": phone,
      "name": pharmamodel!.name,
      "image": "ممممممممممممم",
      "description": "SDSADSAD",
      "originCountryName": "SADSAD",
      "productStatus": true,
      "address": address,
      "location": 'newlocation',
      "longitude": pressPosition == null
          ? lng.toString()
          : pressPosition?.longitude.toString(),
      "latitude": pressPosition == null
          ? lat.toString()
          : pressPosition?.latitude.toString(),
      "workTime": "2023-05-24T21:26:21.808Z",
      "block": pharmamodel!.block,
      "areaId": areaId,
      "localityId": localityId,
      "stateId": stateId,
      "street": street,
    }).then((value) {
      print("in cubit success Profile Pharmacy cubit");
      emit(UpdatePharmacySuccessProfileState());
    }).catchError((error) {
      print(error);
      emit(UpdatePharmacyErrorProfileState());
    });
  }

  int? stateId;
  int? localityId;
  int? areaId;
  String? licenceID;

  List<PharmacyModel>? filteredList;
  void filterPharmacyByLocalityAndStateAndArea(
      {required String locality, required String area, required String state}) {
    filteredList = [];
    emit(FilterPharmacyByLocalityAndStateAndAreaLoading());
    try {
      pharmacyModelData?.data?.forEach((element) {
        if (locality.isEmpty && area.isEmpty && state.isEmpty) {
          filteredList?.add(element);
        } else {
          if (element.state?.name?.contains(state) ?? false) {
            print("in state the state is $state");
            if (element.locality?.contains(locality) ?? false) {
              print("in locality the input is $locality");
              print("locality ${element.area} and $area");

              if (element.area?.contains(area) ?? false) {
                print("in locality");

                filteredList?.add(element);
              }
            }
          }
        }
      });
      emit(FilterPharmacyByLocalityAndStateAndAreaSuccess());
      print(filteredList?.length);
    } catch (err) {
      print(err);
      emit(FilterPharmacyByLocalityAndStateAndAreaError());
    }
  }

  List<LocalityModelData> localityList = [];
  void filterLocalityByStateId({required int stateId}) {
    localityList = [];
    emit(FilterLocalityByStateIdLoading());
    DioHelper.getData(url: 'locality').then((value) {
      LocalityModel localityModel = LocalityModel.fromJson(value.data);

      localityModel.data?.forEach((localityItem) {
        if (localityItem.stateId == stateId) {
          localityList.add(localityItem);
          print(localityItem.name);
        }
      });
      emit(FilterLocalityByStateIdSuccess());
    }).catchError((e) {
      emit(FilterLocalityByStateIdError());
      print("Error in GEt locality $e");
    });
  }

  List<AreaModelData> filterAreaList = [];
  void filterAreaByLocalityId({required int localityId}) {
    filterAreaList = [];
    emit(FilterAreaByLocalityIdLoading());
    DioHelper.getData(url: 'area').then((value) {
      AreaModel areaModel = AreaModel.fromJson(value.data);
      areaModel.data?.forEach((areaElement) {
        if (areaElement.localityId == localityId) {
          filterAreaList.add(areaElement);
          print(areaElement.name);
        }
      });
      emit(FilterAreaByLocalityIdSuccess());
    }).catchError((e) {
      emit(FilterAreaByLocalityIdError());
    });
  }
}
