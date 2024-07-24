import 'package:alfred/alfred.dart';
import 'package:cloud_mining/controllers/user_controller.dart';
import 'package:cloud_mining/controllers/wallet_controller.dart';
import 'package:cloud_mining/model/api_response.dart';
import 'package:cloud_mining/model/wallet.dart';
import 'package:cloud_mining/utils/extensions/body_parser.dart';
import 'package:uuid/uuid.dart';

abstract class IWalletService {
  Future<void> addWallet(HttpRequest req, HttpResponse res);
  Future<void> fetchWalletByUserId(HttpRequest req, HttpResponse res);
  Future<void> fetchWalletById(HttpRequest req, HttpResponse res);
  Future<void> deleteWallet(HttpRequest req, HttpResponse res);
  Future<void> updateWalletAddress(HttpRequest req, HttpResponse res);
}

class WalletService extends IWalletService {
  final IWalletController walletController = WalletController();
  final IUserController userController = UserController();

  @override
  Future<void> addWallet(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();
    if (jsonData != null) {
      final String userId = jsonData['userId'];
      final String name = jsonData['name'];
      final String address = jsonData['address'];
      final String network = jsonData['network'];
      final wallet = Wallet(
        id: Uuid().v4(),
        userId: userId,
        name: name,
        address: address,
        network: network,
      );

      final isWallet = await walletController.addWallet(wallet, userId);
      if (isWallet) {
        final response = ApiResponse<Wallet>(
          success: true,
          message: 'Wallet added successfully',
          data: wallet,
        );
        await res.json(response.toJson((wallet) => wallet.toJson()));
      } else {
        final response = ApiResponse<void>(
          success: false,
          message: 'Wallet already exists',
          data: null,
        );
        await res.json(response.toJson((_) => {}));
      }
    } else {
      final response = ApiResponse<void>(
        success: false,
        message: 'Invalid request',
        data: null,
      );
      await res.json(response.toJson((_) => {}));
    }
  }

  @override
  Future<void> fetchWalletByUserId(HttpRequest req, HttpResponse res) async {
    final userId = await req.params['userId'];
    final isUserExist = await userController.fetchUser(userId);
    if (isUserExist != null) {
      final result = await walletController.fetchWalletsByUserId(userId);
      final response = ApiResponse<List<Wallet>>(
        success: true,
        message: 'Wallets fetched successfully',
        data: result,
      );
      await res.json(response.toJson(
          (wallets) => wallets.map((wallet) => wallet.toJson()).toList()));
    } else {
      final response = ApiResponse<void>(
        success: false,
        message: 'User not found',
        data: null,
      );
      await res.json(response.toJson((_) => {}));
    }
  }

  @override
  Future<void> fetchWalletById(HttpRequest req, HttpResponse res) async {
    final walletId = await req.params['id'];
    final result = await walletController.fetchWallet(walletId);
    if (result != null) {
      final response = ApiResponse<Wallet>(
        success: true,
        message: 'Wallet fetched successfully',
        data: result,
      );
      await res.json(response.toJson((wallet) => wallet.toJson()));
    } else {
      final response = ApiResponse<void>(
        success: false,
        message: 'Wallet not found',
        data: null,
      );
      await res.json(response.toJson((_) => {}));
    }
  }

  @override
  Future<void> deleteWallet(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();

    if (jsonData != null) {
      final userId = jsonData['userId'];
      final walletId = jsonData['walletId'];
      await walletController.deleteWallet(walletId, userId);
      final response = ApiResponse<void>(
        success: true,
        message: 'Wallet deleted successfully',
        data: null,
      );
      await res.json(response.toJson((_) => {}));
    } else {
      final response = ApiResponse<void>(
        success: false,
        message: 'Invalid request',
        data: null,
      );
      await res.json(response.toJson((_) => {}));
    }
  }

  @override
  Future<void> updateWalletAddress(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();

    if (jsonData != null) {
      final walletId = jsonData['walletId'];
      final address = jsonData['address'];
      await walletController.updateWalletAddress(walletId, address);
      final response = ApiResponse<void>(
        success: true,
        message: 'Wallet address updated successfully',
        data: null,
      );
      await res.json(response.toJson((_) => {}));
    } else {
      final response = ApiResponse<void>(
        success: false,
        message: 'Invalid request',
        data: null,
      );
      await res.json(response.toJson((_) => {}));
    }
  }
}
