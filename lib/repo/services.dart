import 'package:basic_utils/basic_utils.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/api_dio/dio.dart';
import 'package:pharmazool/mymodels/medicine_model.dart';

class GetMedicineData {
  Future<List> getmedicinelist(
      int id, String search, var requiredMedicineList) async {
    await DioHelper.getData(
      url: getMedicineEndPoint,
    ).then((value) {
      value.data['data'].forEach((element) {
        if (element['genericId'] == id) {
          if (search.isNotEmpty) {
            if (element['name']
                    .toString()
                    .contains(StringUtils.capitalize(search)) ||
                element['tradeName'].toString().contains(search)) {
              requiredMedicineList.add(MedicineModel.fromJson(element));
            }
          } else {
            requiredMedicineList.add(MedicineModel.fromJson(element));
          }
        }
      });
    }).catchError((error) {
      print(error.toString());
    });
    return requiredMedicineList;
  }

  Future<List> medicinelistpaginationRepo(
      List<MedicineModel> requiredlist, int id, int page, String search) async {
    if (requiredlist.isNotEmpty) {
      await DioHelper.getData(
        url:
            'Medicine/GetMedicineByGeneric?genericId=$id&PageIndex=$page&PageSize=15',
      ).then((value) {
        value.data['data'].forEach((element) {
          requiredlist.add(MedicineModel.fromJson(element));
        });
      }).catchError((error) {
        print(error.toString());
      });
    }

    return requiredlist;
  }
}
