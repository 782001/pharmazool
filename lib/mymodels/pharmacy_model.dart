class PharmacyModelData {
  int? pageIndex;
  int? pageSize;
  int? totalCount;
  List<PharmacyModel>? data;

  PharmacyModelData(
      {this.pageIndex, this.pageSize, this.totalCount, this.data});

  PharmacyModelData.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    if (json['data'] != null) {
      data = <PharmacyModel>[];
      json['data'].forEach((v) {
        data!.add(PharmacyModel.fromJson(v));
      });
    }
  }
}

class PharmacyModel {
  String? id;
  String? name;
  String? licenseId;
  String? street;
  String? block;
  String? area;
  String? address;
  String? locality;
  String? location;
  String? phone;
  String? long;
  String? lat;
  String? worktime;
  bool? productstatues;
  int? areaId;
  int? stateId;
  StateModelDataPharmacy? state;
  int? localityId;
  List? medicines;
  int? distance;

  PharmacyModel(
      {this.id,
      this.name,
      this.area,
      this.block,
      this.stateId,
      this.state,
      this.address,
      this.worktime,
      this.licenseId,
      this.locality,
      this.long,
      this.productstatues,
      this.lat,
      this.localityId,
      this.areaId,
      this.location,
      this.phone,
      this.street,
      this.medicines,
      this.distance});

  PharmacyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    area = json['area']['name'].toString();
    address = json['address'].toString();
    street = json['street'].toString();
    licenseId = json['licenceId'];
    locality = json['locality']['name'].toString();
    phone = json['phone'].toString();
    block = json['block'].toString();
    long = json['longitude'].toString();
    lat = json['latitude'].toString();
    areaId = json['areaId'];
    localityId = json['localityId'];
    state = json['state'] != null ?   StateModelDataPharmacy.fromJson(json['state']) : null;
    stateId = json['stateId'];
    worktime = json['workTime'];
    location = json['location'];
    medicines = json['pharmacyMedicines'];
  }
}

class StateModelDataPharmacy {
  String? name;
  String? created;
  String? lastModified;
  int? id;

  StateModelDataPharmacy({this.name, this.created, this.lastModified, this.id});

  StateModelDataPharmacy.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    created = json['created'];
    lastModified = json['lastModified'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['created'] = created;
    data['lastModified'] = lastModified;
    data['id'] = id;
    return data;
  }
}
