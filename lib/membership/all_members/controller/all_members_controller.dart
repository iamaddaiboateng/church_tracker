import 'dart:io';

import 'package:church_ticker/data/app_database.dart';
import 'package:church_ticker/membership/add_new_member/add_bulk_member.dart';
import 'package:church_ticker/membership/add_new_member/add_single_member.dart';
import 'package:church_ticker/membership/model/members_model.dart';
import 'package:church_ticker/utils/country_code_numbering.dart';
import 'package:church_ticker/utils/toast.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/sembast.dart';

class AllMemberController with ChangeNotifier {
  bool inProgress = false;
  static const MEMBERS_STORE = 'members_store';
  static const NEW_MEMBERS_STORE = 'new_members';

  final _memberStore = intMapStoreFactory.store(MEMBERS_STORE);
  final _newMembersStore = intMapStoreFactory.store(NEW_MEMBERS_STORE);

  Future<Database> get _db async => await AppDatabase.instance.database;

  File csvFile;

  List<MemberModel> members = [];
  List<List<dynamic>> personnelList = [];
  List<MemberModel> allMembers = [];

  Future addSingleMembers(
      MemberModel model,
      context,
      TextEditingController nameController,
      TextEditingController contactController,
      TextEditingController locationController) async {
    inProgress = true;
    notifyListeners();

    Finder finder = Finder(
        filter: Filter.equals('name', nameController.text) &
            Filter.equals('contact', contactController.text));
    var snapshot = _memberStore.find(await _db, finder: finder);
    var queryList = await snapshot;

    if (queryList.isEmpty)

      // add member to members store
      await _memberStore.add(await _db, model.toMap()).whenComplete(() async {
        // afterwards group new members within a day into one store
        await _newMembersStore.add(await _db, model.toMap());
        ToastMessage.toast(context, 'Member added successfully');

        inProgress = false;
        nameController.clear();
        contactController.clear();
        locationController.clear();
        notifyListeners();
      });
    else
      ToastMessage.toast(context, 'Member Already exist');
    inProgress = false;
    notifyListeners();
  }

  addBulkMembers() async {
    inProgress = true;
    notifyListeners();
    for (var member in members) {
      Finder finder = Finder(
          filter: Filter.equals('name', member.name) &
              Filter.equals('contact', member.contact));
      var snapshot = _memberStore.find(await _db, finder: finder);
      var queryList = await snapshot;
      if (queryList.isEmpty) {
        _memberStore.add(await _db, member.toMap()).whenComplete(
          () {
            members.remove(member);
            if (members.isEmpty) {
              inProgress = false;
              notifyListeners();
            }
          },
        );
      }
    }
  }

  pickCSVFile() async {
    //check permission
    var status = await Permission.storage.status;
    print(status);

    if (status == PermissionStatus.granted) {
      // pick file from device
      csvFile = await FilePicker.getFile(
          type: FileType.custom, allowedExtensions: ['csv']);
    } else if (status == PermissionStatus.denied) {
      await Permission.storage.request().whenComplete(() async {
        if (await Permission.storage.status.isGranted) {
          csvFile = await FilePicker.getFile(
              type: FileType.custom, allowedExtensions: ['csv']);
        }
      });
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else if (status == PermissionStatus.undetermined) {
      await Permission.storage.request();
    } else if (status == PermissionStatus.restricted) {
      openAppSettings();
    }

    // clear models before adding new list to ensure list do not repeat
    if (csvFile != null) {
      members.clear();
      notifyListeners();
    }

    if (csvFile != null) {
      //  print(csvFile.readAsBytes());

      personnelList =
          CsvToListConverter().convert(await csvFile.readAsString());
      for (int i = 0; i <= personnelList.length - 1; i++) {
        if (i != 0) {
          MemberModel model = MemberModel(
              name: personnelList[i][0].toString(),
              contact: numberWithCountryCode(personnelList[i][1].toString()),
              location: personnelList[i][2].toString());
          members.add(model);
          notifyListeners();
        }
      }
    }
  }

  addMemberDialog() {
    Get.dialog(AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: Text("Add single member"),
            onPressed: () {
              Get.off(AddSingleUserPage());
            },
          ),
          FlatButton(
            child: Text("Add bulk member"),
            onPressed: () {
              Get.off(AddBulkMembers());
            },
          )
        ],
      ),
    ));
  }

  Future<List<MemberModel>> getAllMembers() async {
    var membersSnapshot = await _memberStore.find(await _db);
    return membersSnapshot.map((e) {
      MemberModel model = MemberModel.fromMap(e.value);
      model.id = e.key;
      return model;
    }).toList();
  }

  setAllMemberToMembersList() async {
    allMembers = await getAllMembers();
    notifyListeners();
  }
}
