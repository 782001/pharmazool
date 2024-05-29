class GetPharmaciesByMedicineModel {
  final int? id;
  final String? name;
  final String? licenceId;
  final String? email;
  final String? mobile;
  final String? phone;
  final String? address;
  final String? location;
  final String? workTime;
  final String? street;
  final String? block;
  final String? longitude;
  final String? latitude;
  final String? area;
  final String? locality;
  final int? areaId;
  final int? localityId;
  final int? stateId;

  GetPharmaciesByMedicineModel({
    this.id,
    this.name,
    this.licenceId,
    this.email,
    this.mobile,
    this.phone,
    this.address,
    this.location,
    this.workTime,
    this.street,
    this.block,
    this.longitude,
    this.latitude,
    this.areaId,
    this.localityId,
    this.stateId,
    this.area,
    this.locality,
  });

  factory GetPharmaciesByMedicineModel.fromJson(Map<String?, dynamic> json) {
    return GetPharmaciesByMedicineModel(
      id: json['id'],
      name: json['name'] ?? "",
      licenceId: json['licenceId'] ?? "",
      email: json['email'] ?? "",
      mobile: json['mobile'] ?? "",
      phone: json['phone'] ?? "",
      address: json['address'] ?? "",
      location: json['location'] ?? "",
      workTime: json['workTime'] ?? "",
      street: json['street'] ?? "",
      block: json['block'] ?? "",
      longitude: json['longitude'],
      latitude: json['latitude'],
      areaId: json['areaId'],
      localityId: json['localityId'],
      stateId: json['stateId'],
      area: json['area'] != null ? json['area']["name"] ?? "" : "",
      locality: json['locality'] != null ? json['locality']["name"] ?? "" : "",
    );
  }
}
