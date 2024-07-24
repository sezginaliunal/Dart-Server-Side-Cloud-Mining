import 'dart:async';

import 'package:cloud_mining/config/constants/defaults.dart';
import 'package:cloud_mining/controllers/user_controller.dart';
import 'package:cloud_mining/model/transaction.dart';
import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/services/db/db.dart';
import 'package:cloud_mining/config/constants/collections.dart';

abstract class ITransactionController {
  Future<void> addTransaction(Transaction transaction);
  Future<void> checkTransactionStatus();
  Future<void> startTransactionChecker();
  Future<List<Transaction>> fetchAllTransaction();
  Future<List<Transaction>> fetchTransactionsByUserId(String userId);
  Future<Transaction?> fetchTransaction(String id);
  Future<void> updateTransactionStatus(String transactionId, bool value);
  Future<void> deleteTransaction(String transactionId, String userId);
}

class TransactionController extends ITransactionController {
  final IBaseDb _db = MongoDatabase();
  final CollectionPath collectionName = CollectionPath.transactions;
  final IUserController userController = UserController();
  @override
  Future<void> addTransaction(Transaction transaction) async {
    await _db.insertData(
        collectionName, transaction.id.toString(), transaction.toJson());
  }

  @override
  Future<List<Transaction>> fetchAllTransaction() async {
    final result = await _db.fetchAllData(collectionName);

    // result bir liste olduğundan her bir öğeyi Default nesnesine dönüştürmeliyiz
    final transactions =
        result.map<Transaction>((item) => Transaction.fromJson(item)).toList();

    return transactions;
  }

  @override
  Future<List<Transaction>> fetchTransactionsByUserId(String userId) async {
    final result = await _db.fetchListById(collectionName, 'userId', userId);

    final transactions =
        result.map<Transaction>((item) => Transaction.fromJson(item)).toList();

    return transactions;
  }

  @override
  Future<Transaction?> fetchTransaction(String id) async {
    final result = await _db.fetchOneData(collectionName, '_id', id);
    if (result != null) {
      final transaction = Transaction.fromJson(result);
      return transaction;
    }
    return null;
  }

  @override
  Future<void> checkTransactionStatus() async {
    final transactions = await _db.fetchAllData(collectionName);
    if (transactions.isNotEmpty) {
      final transactionList = Transaction().parseTransactions(transactions);

      for (var transaction in transactionList) {
        if (transaction.isActive! &&
            DateTime.now().isAfter(transaction.endTime!)) {
          await _db.updateOneData(
              collectionName, transaction.id.toString(), 'isActive', false);
          await userController.updateBalance(transaction.userId.toString());
        }
      }
    }
  }

  @override
  Future<void> startTransactionChecker() async {
    Timer.periodic(Defaults.miningCheckTime.rawValue, (Timer timer) async {
      await checkTransactionStatus();
    });
  }

  @override
  Future<void> updateTransactionStatus(String transactionId, bool value) async {
    await _db.updateOneData(collectionName, transactionId, 'isActive', value);
  }

  @override
  Future<void> deleteTransaction(String transactionId, String userId) async {
    await _db.deleteData(collectionName, '_id', transactionId);
    await userController.deleteDocument(userId, 'transactions', transactionId);
  }
}
