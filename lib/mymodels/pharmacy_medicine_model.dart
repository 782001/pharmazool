class PharmacyMedicineModel {
  String? id;
  String? name;
  String? pharmacyId;
  String? categoryId;
  String? manufacturerName;
  String? originCountryName;
  String? image;
  String? status;
  double? price;
  int? quantity;

  PharmacyMedicineModel(
      {this.id,
      this.name,
      this.pharmacyId,
      this.price,
      this.categoryId,
      this.image,
      this.originCountryName,
      this.quantity,
      this.status});

  PharmacyMedicineModel.fromJson(Map<String, dynamic> json) {
    id = json['medicineId'].toString();
    name = json['name'].toString();
    pharmacyId = json['pharmacyId'];
    price = json['price'];
    quantity = json['quantity'];
    status = json['productStatusId'].toString();
    originCountryName = json['originCountryName'];
  }
}
