class AreaModel {
  int? pageIndex;
  int? pageSize;
  int? totalCount;
  List<AreaModelData>? data;

  AreaModel({this.pageIndex, this.pageSize, this.totalCount, this.data});

  AreaModel.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    if (json['data'] != null) {
      data = <AreaModelData>[];
      json['data'].forEach((v) {
        data!.add(AreaModelData.fromJson(v));
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

class AreaModelData {
  int? id;
  String? name;
  String? created;
  int? localityId;
  String? createdBy;
  String? lastModified;
   

  AreaModelData(
      {this.id,
      this.name,
      this.created,
      this.createdBy,
      this.localityId,
      this.lastModified,
   });

  AreaModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    created = json['created'];
     localityId = json['localityId'];
    createdBy = json['createdBy'];
    lastModified = json['lastModified'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
     data['localityId'] = localityId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['lastModified'] = lastModified;
    
    return data;
  }
}
