import 'dart:async';

import 'package:cloud_mining/config/constants/collections.dart';
import 'package:cloud_mining/controllers/user_controller.dart';
import 'package:cloud_mining/model/wallet.dart';
import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/services/db/db.dart';

abstract class IWalletController {
  Future<bool> addWallet(Wallet wallet, String userId);
  Future<List<Wallet>> fetchAllWallet();
  Future<List<Wallet>> fetchWalletsByUserId(String userId);
  Future<Wallet?> fetchWallet(String id);
  Future<void> updateWalletAddress(String walletId, String value);
  Future<void> deleteWallet(String walletId, String userId);
}

class WalletController extends IWalletController {
  final IBaseDb _db = MongoDatabase();
  final CollectionPath collectionName = CollectionPath.wallets;
  final IUserController userController = UserController();
  @override
  Future<bool> addWallet(Wallet wallet, String userId) async {
    final isWalletExist =
        await _db.isItemExist(collectionName, 'address', wallet.address);
    if (!isWalletExist) {
      await _db.insertData(
          collectionName, wallet.id.toString(), wallet.toJson());
      await userController.addWallet(userId, wallet.id.toString());
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<Wallet>> fetchAllWallet() async {
    final result = await _db.fetchAllData(collectionName);

    final wallets =
        result.map<Wallet>((item) => Wallet.fromJson(item)).toList();

    return wallets;
  }

  @override
  Future<Wallet?> fetchWallet(String id) async {
    final result = await _db.fetchOneData(collectionName, '_id', id);
    if (result != null) {
      final wallet = Wallet.fromJson(result);
      return wallet;
    }
    return null;
  }

  @override
  Future<List<Wallet>> fetchWalletsByUserId(String userId) async {
    final result = await _db.fetchListById(collectionName, 'userId', userId);

    final wallets =
        result.map<Wallet>((item) => Wallet.fromJson(item)).toList();

    return wallets;
  }

  @override
  Future<void> updateWalletAddress(String walletId, String value) async {
    await _db.updateOneData(collectionName, walletId, 'address', value);
  }

  @override
  Future<void> deleteWallet(String walletId, String userId) async {
    await _db.deleteData(collectionName, '_id', walletId);
    await userController.deleteDocument(userId, 'wallets', walletId);
  }
}
