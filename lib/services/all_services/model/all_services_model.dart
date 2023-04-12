import 'package:church_ticker/utils/strings.dart';

class AllServiceModel {
  String actualTime;
  String decodedTime;
  int id;

  AllServiceModel({this.actualTime, this.decodedTime});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map[kActualTime] = this.actualTime;
    map[kReadableTime] = this.decodedTime;
    return map;
  }

  AllServiceModel.fromMap(Map<String, dynamic> map)
      : this.decodedTime = map[kReadableTime],
        this.actualTime = map[kActualTime];
}
