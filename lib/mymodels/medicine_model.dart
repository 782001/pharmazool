import 'package:pharmazool/api_dio/services_paths.dart';

class MedicineModel {
  String? id;
  String? name;
  String? tradeName;
  String? desc;
  String? categoryId;
  String? manufacturerName;
  String? originCountryName;
  String? image;
  bool? status;
  String? Stringstatus;

  double? price;
  int? quantity;
  List? pharmacyMedicines;

  MedicineModel(
      {this.id,
      this.name,
      this.tradeName,
      this.desc,
      this.manufacturerName,
      this.categoryId,
      this.image,
      this.price,
      this.originCountryName,
      this.quantity,
      this.status,
      this.Stringstatus,
      this.pharmacyMedicines});

  MedicineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    tradeName = json['tradeName'].toString();
    desc = json['description'];
    manufacturerName = json['manufacturer']['name'];

    image = json['image'];
    Stringstatus = json['productStatus']["name"];
    // status = json['productStatus']["name"];
    print("$Stringstatus=======");
    print("$tradeName=======");
    print("$name=======");
    if (Stringstatus == "On") {
      status = true;
      print("$status=======");
    } else {
      status = false;
      print("$status=======");
    }

    categoryId = json['genericId'].toString();
    originCountryName = json['originCountryName'];
    pharmacyMedicines = json['pharmacyMedicines'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': manufacturerName,
      'image': image,
      'genericId': categoryId,
      'originCountryName': originCountryName,
      'pharmacyMedicines': pharmacyMedicines
    };
  }
}
