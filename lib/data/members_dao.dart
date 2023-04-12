import 'package:church_ticker/data/app_database.dart';
import 'package:church_ticker/membership/model/members_model.dart';
import 'package:get/get.dart';
import 'package:sembast/sembast.dart';

class MembersDAO {
  static const MEMBERS_STORE = 'members_store';

  final _memberStore = intMapStoreFactory.store(MEMBERS_STORE);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insertDate(MemberModel model) async {
    await _memberStore
        .add(await _db, model.toMap())
        .whenComplete(() => Get.snackbar('Sent', 'Done'));
  }

  Future update(MemberModel model) async {
    Finder finder = Finder(filter: Filter.byKey(model.id));
    await _memberStore.update(await _db, model.toMap(), finder: finder);
  }

  Future delete(MemberModel model) async {
    Finder finder = Finder(filter: Filter.byKey(model.id));
    await _memberStore.delete(await _db, finder: finder);
  }

  Future<List<MemberModel>> sort() async {
    Finder finder = Finder(sortOrders: [SortOrder('name')]);
    final recordSnapshot = await _memberStore.find(await _db, finder: finder);
    return recordSnapshot.map((snapshot) {
      final member = MemberModel.fromMap(snapshot.value);
      member.id = snapshot.key;
      return member;
    }).toList();
  }
}
