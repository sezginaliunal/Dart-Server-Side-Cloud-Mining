import 'package:alfred/alfred.dart';
import 'package:cloud_mining/config/constants/defaults.dart';
import 'package:cloud_mining/config/constants/withdrawal_status.dart';
import 'package:cloud_mining/controllers/default_controller.dart';
import 'package:cloud_mining/controllers/user_controller.dart';
import 'package:cloud_mining/controllers/withdrawal_controller.dart';
import 'package:cloud_mining/model/api_response.dart';
import 'package:cloud_mining/model/withdrawal.dart';
import 'package:cloud_mining/utils/extensions/body_parser.dart';
import 'package:uuid/uuid.dart';

abstract class IWithdrawalService {
  Future<void> addWithdrawal(HttpRequest req, HttpResponse res);
  Future<void> fetchWithdrawalByUserId(HttpRequest req, HttpResponse res);
  Future<void> fetchWithdrawalById(HttpRequest req, HttpResponse res);
  Future<void> fetchAllWithdrawals(HttpRequest req, HttpResponse res);
  Future<void> deleteWithdrawal(HttpRequest req, HttpResponse res);
  Future<void> updateWithdrawal(HttpRequest req, HttpResponse res);
}

class WithdrawalService extends IWithdrawalService {
  final IWithdrawalController withdrawalController = WithdrawalController();
  final IUserController userController = UserController();
  final IDefaultController defaultController = DefaultController();

  @override
  Future<void> addWithdrawal(HttpRequest req, HttpResponse res) async {
    double minimumPrice = Defaults.minimumWithdraw.rawValue;
    final minimumWithdraw =
        await defaultController.fetchDefault(Defaults.minimumWithdraw);
    if (minimumWithdraw != null) {
      minimumPrice = minimumWithdraw.value;
    }

    print(
        'Minimum Price: $minimumPrice'); // Debug: Minimum price değerini yazdır
    final jsonData = await req.parseBodyJson();
    if (jsonData != null) {
      final userId = jsonData['userId'];
      final walletId = jsonData['walletId'];
      final double quantity = jsonData['quantity'];

      print('Quantity: $quantity'); // Debug: Quantity değerini yazdır

      final withdrawal = Withdrawal(
        id: Uuid().v4(),
        userId: userId,
        walletId: walletId,
        status: WithdrawalStatus.waiting.rawValue,
        quantity: quantity,
      );

      final user = await userController.fetchUser(userId);
      if (user != null) {
        if (quantity < minimumPrice) {
          final response = ApiResponse<void>(
            success: false,
            message: 'Withdrawal quantity is below the minimum limit',
            data: null,
          );
          await res.json(response.toJson((_) => {}));
          return;
        }
        if (quantity > user.accountBalance!) {
          final response = ApiResponse<void>(
            success: false,
            message: 'Insufficient account balance',
            data: null,
          );
          await res.json(response.toJson((_) => {}));
          return;
        }
        await withdrawalController.addWithdrawal(
            withdrawal, userId, withdrawal.id.toString());
        final newValue = user.accountBalance! - quantity;
        await userController.updateUser(
            user.id.toString(), 'accountBalance', newValue);
        final response = ApiResponse<Withdrawal>(
          success: true,
          message: 'Withdrawal added successfully',
          data: withdrawal,
        );
        await res.json(response.toJson((withdrawal) => withdrawal.toJson()));
        return;
      } else {
        final response = ApiResponse<void>(
          success: false,
          message: 'User not found',
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
  Future<void> fetchWithdrawalByUserId(
      HttpRequest req, HttpResponse res) async {
    final userId = await req.params['userId'];
    final isUserExist = await userController.fetchUser(userId);
    if (isUserExist != null) {
      final result =
          await withdrawalController.fetchWithdrawalsByUserId(userId);
      final response = ApiResponse<List<Withdrawal>>(
        success: true,
        message: 'Withdrawals fetched successfully',
        data: result,
      );
      await res.json(response.toJson(
          (withdrawals) => withdrawals.map((w) => w.toJson()).toList()));
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
  Future<void> fetchWithdrawalById(HttpRequest req, HttpResponse res) async {
    final withdrawalId = await req.params['id'];
    final result = await withdrawalController.fetchWithdrawal(withdrawalId);
    if (result != null) {
      final response = ApiResponse<Withdrawal>(
        success: true,
        message: 'Withdrawal fetched successfully',
        data: result,
      );
      await res.json(response.toJson((withdrawal) => withdrawal.toJson()));
    } else {
      final response = ApiResponse<void>(
        success: false,
        message: 'Withdrawal not found',
        data: null,
      );
      await res.json(response.toJson((_) => {}));
    }
  }

  @override
  Future<void> deleteWithdrawal(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();
    if (jsonData != null) {
      final userId = jsonData['userId'];
      final withdrawalId = jsonData['withdrawalId'];
      await withdrawalController.deleteWithdrawal(withdrawalId, userId);
      final response = ApiResponse<void>(
        success: true,
        message: 'Withdrawal deleted successfully',
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
  Future<void> fetchAllWithdrawals(HttpRequest req, HttpResponse res) async {
    final withdrawals = await withdrawalController.fetchAllWithdrawal();
    final response = ApiResponse<List<Withdrawal>>(
      success: true,
      message: 'All withdrawals fetched successfully',
      data: withdrawals,
    );
    await res.json(response
        .toJson((withdrawals) => withdrawals.map((w) => w.toJson()).toList()));
  }

  @override
  Future<void> updateWithdrawal(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();
    if (jsonData != null) {
      final withdrawalId = jsonData['withdrawalId'];
      final int status = jsonData['status'];
      final withdrawal =
          await withdrawalController.fetchWithdrawal(withdrawalId);
      if (withdrawal != null) {
        final userId = withdrawal.userId!;
        final quantity = withdrawal.quantity!;
        await withdrawalController.updateWithdrawal(
          userId.toString(),
          withdrawalId.toString(),
          status,
          quantity,
        );
        final response = ApiResponse<void>(
          success: true,
          message: 'Withdrawal updated successfully',
          data: null,
        );
        await res.json(response.toJson((_) => {}));
        return;
      } else {
        final response = ApiResponse<void>(
          success: false,
          message: 'Withdrawal not found',
          data: null,
        );
        await res.json(response.toJson((_) => {}));
        return;
      }
    }
    final response = ApiResponse<void>(
      success: false,
      message: 'Invalid request',
      data: null,
    );
    await res.json(response.toJson((_) => {}));
  }
}
