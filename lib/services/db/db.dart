import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/config/load_env.dart';
import 'package:cloud_mining/config/constants/collections.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase extends IBaseDb {
  late Db _db;
  @override
  Db get db => _db;
  static final MongoDatabase _instance = MongoDatabase._init();
  final _env = Env();

  MongoDatabase._init() {
    _db = Db(_env.envConfig.db);
  }

  factory MongoDatabase() => _instance;

  // Connect to database
  @override
  Future<void> connectDb() async {
    await db.open();
    await autoMigrate();
  }

  // Close to database
  @override
  Future<void> closeDb() async {
    await db.close();
  }

  // Auto migrate for collections
  @override
  Future<void> autoMigrate() async {
    var collectionInfos = await db.getCollectionNames();
    for (var collectionInfo in collectionInfos) {
      for (var collectionName in CollectionPath.values) {
        if (!collectionInfo!.contains(collectionName.rawValue)) {
          await db.createCollection(collectionName.rawValue);
        }
      }
    }
  }

  // Return bool value for db status
  @override
  Future<bool> isDbOpen() async {
    return _db.isConnected;
  }

  // Check exist data
  @override
  Future<bool> isItemExist(
      CollectionPath collectionName, String queryName, dynamic field) async {
    var result = await _db
        .collection(collectionName.rawValue)
        .findOne(where.eq(queryName, field));
    return result != null;
  }

  // Add Data
  @override
  Future<void> insertData(CollectionPath collectionName, String id,
      Map<String, dynamic> document) async {
    await _db.collection(collectionName.rawValue).insert(document);
  }

  // Delete data
  @override
  Future<void> deleteData(
      CollectionPath collectionName, String fieldName, String id) async {
    final isItemExistSuccess = await isItemExist(collectionName, fieldName, id);

    if (isItemExistSuccess) {
      await _db.collection(collectionName.rawValue).deleteOne({fieldName: id});
    }
  }

  @override
  Future<void> updateOneData(CollectionPath collectionName, String id,
      String field, dynamic value) async {
    final isItemExistSuccess = await isItemExist(collectionName, '_id', id);
    if (isItemExistSuccess) {
      await _db
          .collection(collectionName.rawValue)
          .updateOne(where.eq('_id', id), modify.set(field, value));
    }
  }

  // Get Data
  @override
  Future<Map<String, dynamic>?> fetchOneData(
      CollectionPath collectionName, String field, dynamic value) async {
    final data = await _db
        .collection(collectionName.rawValue)
        .findOne(where.eq(field, value));
    if (data != null) {
      return data;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> addDocument(
    CollectionPath collectionName,
    dynamic value,
    String pushField,
    dynamic documentId,
  ) async {
    return await _db.collection(collectionName.rawValue).update(
          where.eq('_id', value),
          modify.push(pushField, documentId),
        );
  }

  // Delete a document from the transactions array
  @override
  Future<Map<String, dynamic>> deleteDocument(CollectionPath collectionName,
      String id, String documentFieldName, String documentId) async {
    return await _db.collection(collectionName.rawValue).update(
        where.eq('_id', id), modify.pull(documentFieldName, documentId));
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllData(
      CollectionPath collectionName) async {
    return await _db.collection(collectionName.rawValue).find().toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchListById(
      CollectionPath collectionName, String fieldName, String id) async {
    return await _db
        .collection(collectionName.rawValue)
        .find(where.eq(fieldName, id))
        .toList();
  }
}
