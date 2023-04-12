import 'package:meta/meta.dart';

class MemberModel {
  int id;
  String name, contact, location, status;

  MemberModel(
      {@required this.name,
      this.contact,
      this.location,
      this.status = 'Member'});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['name'] = this.name;
    map['contact'] = this.contact;
    map['location'] = this.location;
    map['status'] = this.status;

    return map;
  }

  MemberModel.fromMap(Map<String, dynamic> map)
      : this.name = map['name'],
        this.status = map['status'],
        this.location = map['location'],
        this.contact = map['contact'];
}
