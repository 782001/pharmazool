class LocalityModel {
  int? pageIndex;
  int? pageSize;
  int? totalCount;
  List<LocalityModelData>? data;

  LocalityModel({this.pageIndex, this.pageSize, this.totalCount, this.data});

  LocalityModel.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    if (json['data'] != null) {
      data = <LocalityModelData>[];
      json['data'].forEach((v) {
        data!.add(LocalityModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocalityModelData {
  int? id;
  String? name;
  int? stateId;
  String? created;
  String? createdBy;
  String? lastModified;
 

  LocalityModelData(
      {this.id,
      this.name,
      this.created,this.stateId,
      this.createdBy,
      this.lastModified,
   });

  LocalityModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
     stateId = json['stateId'];
    created = json['created'];
    createdBy = json['createdBy'];
    lastModified = json['lastModified'];
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['stateId'] = stateId;

    data['created'] = created;
    data['createdBy'] = createdBy;
    data['lastModified'] = lastModified;
  
    return data;
  }
}
