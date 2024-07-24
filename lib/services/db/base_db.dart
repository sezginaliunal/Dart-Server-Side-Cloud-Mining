import 'package:cloud_mining/config/constants/collections.dart';
import 'package:mongo_dart/mongo_dart.dart';

abstract class IBaseDb {
  late Db db;
  Future<void> connectDb();
  Future<void> closeDb();
  Future<void> autoMigrate();
  Future<bool> isDbOpen();
  Future<bool> isItemExist(
    CollectionPath collectionName,
    String queryName,
    dynamic field,
  );
  Future<void> insertData(
    CollectionPath collectionName,
    String id,
    Map<String, dynamic> document,
  );
  Future<void> deleteData(
      CollectionPath collectionName, String fieldName, String id);
  Future<void> updateOneData(
    CollectionPath collectionName,
    String id,
    String field,
    dynamic value,
  );
  Future<Map<String, dynamic>?> fetchOneData(
    CollectionPath collectionName,
    String field,
    dynamic value,
  );
  Future<Map<String, dynamic>> addDocument(
    CollectionPath collectionName,
    dynamic value,
    String pushField,
    dynamic documentId,
  );
  Future<Map<String, dynamic>> deleteDocument(CollectionPath collectionName,
      String id, String documentFieldName, String documentId);
  Future<List<Map<String, dynamic>>> fetchAllData(
      CollectionPath collectionName);
  Future<List<Map<String, dynamic>>> fetchListById(
      CollectionPath collectionName, String fieldName, String id);
}
