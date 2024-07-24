import 'dart:async';

import 'package:cloud_mining/config/constants/collections.dart';
import 'package:cloud_mining/config/constants/withdrawal_status.dart';
import 'package:cloud_mining/controllers/user_controller.dart';
import 'package:cloud_mining/model/withdrawal.dart';
import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/services/db/db.dart';

abstract class IWithdrawalController {
  Future<void> addWithdrawal(
      Withdrawal withdrawal, String userId, String withdrawalId);
  Future<List<Withdrawal>> fetchAllWithdrawal();
  Future<List<Withdrawal>> fetchWithdrawalsByUserId(String userId);
  Future<Withdrawal?> fetchWithdrawal(String id);
  Future<void> updateWithdrawal(
      String userId, String withdrawalId, int status, double quantity);
  Future<void> deleteWithdrawal(String withdrawalId, String userId);
}

class WithdrawalController extends IWithdrawalController {
  final IBaseDb _db = MongoDatabase();
  final CollectionPath collectionName = CollectionPath.withdrawals;
  final IUserController userController = UserController();
  @override
  Future<void> addWithdrawal(
      Withdrawal withdrawal, String userId, String withdrawalId) async {
    await _db.insertData(
        collectionName, withdrawal.id.toString(), withdrawal.toJson());
    await userController.addWithdrawal(userId, withdrawal.id.toString());
  }

  @override
  Future<List<Withdrawal>> fetchAllWithdrawal() async {
    final result = await _db.fetchAllData(collectionName);

    final withdrawals =
        result.map<Withdrawal>((e) => Withdrawal.fromJson(e)).toList();
    return withdrawals;
  }

  @override
  Future<Withdrawal?> fetchWithdrawal(String id) async {
    final result = await _db.fetchOneData(collectionName, '_id', id);

    if (result != null) {
      final withdrawal = Withdrawal.fromJson(result);
      return withdrawal;
    }
    return null;
  }

  @override
  Future<List<Withdrawal>> fetchWithdrawalsByUserId(String userId) async {
    final result = await _db.fetchListById(collectionName, 'userId', userId);

    final withdrawals =
        result.map<Withdrawal>((e) => Withdrawal.fromJson(e)).toList();
    return withdrawals;
  }

  @override
  Future<void> updateWithdrawal(
      String userId, String withdrawalId, int status, double quantity) async {
    final user = await userController.fetchUser(userId);
    if (user != null) {
      await _db.updateOneData(collectionName, withdrawalId, 'status', status);
      if (status == WithdrawalStatus.canceled.rawValue) {
        final newBalance = user.accountBalance! + quantity;
        await userController.updateUser(userId, 'accountBalance', newBalance);
      }

      await _db.updateOneData(collectionName, withdrawalId, 'status', status);
    }
  }

  @override
  Future<void> deleteWithdrawal(String withdrawalId, String userId) async {
    await _db.deleteData(collectionName, '_id', withdrawalId);
    await userController.deleteDocument(userId, 'withdrawals', withdrawalId);
  }
}
