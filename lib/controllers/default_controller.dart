import 'package:cloud_mining/config/constants/defaults.dart';
import 'package:cloud_mining/model/default.dart';
import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/services/db/db.dart';
import 'package:cloud_mining/config/constants/collections.dart';

abstract class IDefaultController {
  Future<void> addDefault(Default df);
  Future<Default?> fetchDefault(Defaults defaultId);
  Future<void> deleteDefault(Defaults name);
  Future<void> updateDefault(String id, String field, dynamic value);
  Future<List<Default>> fetchAllDefault();
}

class DefaultController extends IDefaultController {
  final IBaseDb _db = MongoDatabase();
  final CollectionPath collectionName = CollectionPath.defaults;

  @override
  Future<void> addDefault(Default df) async {
    final isDefaultExist =
        await _db.isItemExist(collectionName, 'name', df.name);
    if (!isDefaultExist) {
      await _db.insertData(collectionName, df.id.toString(), df.toJson());
    }
  }

  @override
  Future<void> deleteDefault(Defaults name) async {
    await _db.deleteData(collectionName, 'name', name.rawValue);
  }

  @override
  Future<void> updateDefault(String id, String field, value) async {
    await _db.updateOneData(collectionName, id, field, value);
  }

  @override
  Future<List<Default>> fetchAllDefault() async {
    final result = await _db.fetchAllData(collectionName);

    // result bir liste olduğundan her bir öğeyi Default nesnesine dönüştürmeliyiz
    final defaults =
        result.map<Default>((item) => Default.fromJson(item)).toList();

    return defaults;
  }

  @override
  Future<Default?> fetchDefault(Defaults defaultId) async {
    final result =
        await _db.fetchOneData(collectionName, '_id', defaultId.defaultsId);
    if (result != null) {
      final defaults = Default.fromJson(result);

      return defaults;
    } else {
      return null;
    }
  }
}
