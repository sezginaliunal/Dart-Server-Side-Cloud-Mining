import 'package:cloud_mining/config/constants/defaults.dart';
import 'package:cloud_mining/model/user.dart';
import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/services/db/db.dart';
import 'package:cloud_mining/config/constants/collections.dart';

abstract class IUserController {
  Future<User?> fetchUser(String id);
  Future<User?> fetchUserByEmail(String email);
  Future delete(String id);
  Future deleteDocument(String id, String documentFieldName, String documentId);
  Future updateUser(String id, String field, dynamic value);
  Future<List<User>> fetchAllUser();
  Future<void> addTransaction(String userId, String transactionId);
  Future<void> addWallet(String userId, String walletId);
  Future<void> addWithdrawal(String userId, String withdrawalId);
  Future<void> updateBalance(String userId);
}

class UserController extends IUserController {
  final IBaseDb _db = MongoDatabase();
  final CollectionPath collectionName = CollectionPath.users;

  @override
  Future delete(String id) async {
    await _db.deleteData(collectionName, '_id', id);
  }

  @override
  Future deleteDocument(
      String id, String documentFieldName, String documentId) async {
    await _db.deleteDocument(collectionName, id, documentFieldName, documentId);
  }

  @override
  Future updateUser(String id, String field, dynamic value) async {
    await _db.updateOneData(collectionName, id, field, value);
  }

  @override
  Future<List<User>> fetchAllUser() async {
    final result = await _db.fetchAllData(collectionName);

    final users = result.map<User>((item) => User.fromJson(item)).toList();
    return users;
  }

  @override
  Future<User?> fetchUser(String id) async {
    final result = await _db.fetchOneData(collectionName, '_id', id);
    if (result != null) {
      final user = User.fromJson(result);
      final filtredFields = User().copyWith(
        id: user.id,
        email: user.email,
        name: user.name,
        surname: user.surname,
        transactions: user.transactions,
        wallets: user.wallets,
        accountRole: user.accountRole,
        accountBalance: user.accountBalance,
      );

      return filtredFields;
    } else {
      return null;
    }
  }

  @override
  Future<User?> fetchUserByEmail(String email) async {
    final result = await _db.fetchOneData(collectionName, 'email', email);
    if (result != null) {
      final user = User.fromJson(result);
      final filtredFields = User().copyWith(
        id: user.id,
        email: user.email,
        name: user.name,
        surname: user.surname,
        transactions: user.transactions,
        wallets: user.wallets,
        accountRole: user.accountRole,
        accountBalance: user.accountBalance,
      );

      return filtredFields;
    } else {
      return null;
    }
  }

  @override
  Future<void> addWallet(String userId, String walletId) async {
    await _db.addDocument(
      collectionName,
      userId,
      'wallets',
      walletId,
    );
  }

  @override
  Future<void> addTransaction(String userId, String transactionId) async {
    await _db.addDocument(
        collectionName, userId, 'transactions', transactionId);
  }

  @override
  Future<void> updateBalance(String userId) async {
    final user = await fetchUser(userId);
    if (user != null) {
      final double userBalance =
          user.accountBalance ?? Defaults.starterPrice.rawValue;
      final double updatedBalance = userBalance + Defaults.earnPrice.rawValue;
      await _db.updateOneData(
          collectionName, userId, 'accountBalance', updatedBalance);
    }
  }

  @override
  Future<void> addWithdrawal(String userId, String withdrawalId) async {
    await _db.addDocument(
      collectionName,
      userId,
      'withdrawals',
      withdrawalId,
    );
  }
}
