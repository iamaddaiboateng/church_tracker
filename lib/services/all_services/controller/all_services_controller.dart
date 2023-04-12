import 'package:church_ticker/data/app_database.dart';
import 'package:church_ticker/services/all_services/model/all_services_model.dart';
import 'package:church_ticker/utils/date_time.dart';
import 'package:church_ticker/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sembast/sembast.dart';

class AllServiceController with ChangeNotifier {
  static const String ALL_SERVICES = 'all_services_store';
  List<AllServiceModel> services = [];

  Future<Database> get _db async => await AppDatabase.instance.database;

  final _allService = intMapStoreFactory.store(ALL_SERVICES);

  Future insert() async {
    AllServiceModel model = AllServiceModel(
        actualTime: getDateInString(DateTime.now()),
        decodedTime: DateTime.now().toIso8601String());
    _allService
        .add(await _db, model.toMap())
        .whenComplete(() => Get.snackbar('title', 'message'));
    setDateToList();
  }

  Future delete(AllServiceModel model) async {
    final finder = Finder(filter: Filter.byKey(model.id));
    _allService.delete(await _db, finder: finder).whenComplete(() {
      Get.snackbar('title', 'Remove');
      setDateToList();
    });
  }

  Future<List<AllServiceModel>> getAllServices() async {
    Finder finder = Finder(sortOrders: [SortOrder(kActualTime)]);
    final allServiceSnapshot =
        await _allService.find(await _db, finder: finder);
    return allServiceSnapshot.map((snapshot) {
      final service = AllServiceModel.fromMap(snapshot.value);
      service.id = snapshot.key;
      return service;
    }).toList();
  }

  setDateToList() async {
    services = await getAllServices();
    notifyListeners();
  }
}
