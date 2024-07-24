import 'package:alfred/alfred.dart';
import 'package:cloud_mining/config/constants/defaults.dart';
import 'package:cloud_mining/controllers/default_controller.dart';
import 'package:cloud_mining/controllers/transactions_controller.dart';
import 'package:cloud_mining/controllers/user_controller.dart';
import 'package:cloud_mining/model/api_response.dart';
import 'package:cloud_mining/model/transaction.dart';
import 'package:cloud_mining/utils/extensions/body_parser.dart';
import 'package:uuid/uuid.dart';

abstract class ITransactionService {
  Future<void> addTransaction(HttpRequest req, HttpResponse res);
  Future<void> fetchTransactionByUserId(HttpRequest req, HttpResponse res);
  Future<void> fetchTransactionById(HttpRequest req, HttpResponse res);
  Future<void> fetchAllTransactions(HttpRequest req, HttpResponse res);
  Future<void> deleteTransaction(HttpRequest req, HttpResponse res);
}

class TransactionService extends ITransactionService {
  final ITransactionController transactionController = TransactionController();
  final IUserController userController = UserController();
  final IDefaultController defaultController = DefaultController();

  @override
  Future<void> addTransaction(HttpRequest req, HttpResponse res) async {
    double? price;
    final earnPrice = await defaultController.fetchDefault(Defaults.earnPrice);
    if (earnPrice != null) {
      price = earnPrice.value;
    }
    final jsonData = await req.parseBodyJson();
    if (jsonData != null) {
      final userId = jsonData['userId'];
      final transaction = Transaction(
        id: Uuid().v4(),
        userId: userId,
        price: price ?? Defaults.earnPrice.rawValue,
        isActive: true,
        startTime: Defaults.startTime.rawValue,
        endTime: Defaults.endTime.rawValue,
      );

      await transactionController.addTransaction(transaction);
      await userController.addTransaction(userId, transaction.id.toString());

      final response = ApiResponse<Transaction>(
        success: true,
        message: 'Transaction added successfully',
        data: transaction,
      );
      await res.json(response.toJson((transaction) => transaction.toJson()));
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
  Future<void> fetchTransactionByUserId(
      HttpRequest req, HttpResponse res) async {
    final userId = await req.params['userId'];
    final isUserExist = await userController.fetchUser(userId);
    if (isUserExist != null) {
      final result =
          await transactionController.fetchTransactionsByUserId(userId);
      final response = ApiResponse<List<Transaction>>(
        success: true,
        message: 'Transactions fetched successfully',
        data: result,
      );
      await res.json(response.toJson((transactions) =>
          transactions.map((transaction) => transaction.toJson()).toList()));
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
  Future<void> fetchTransactionById(HttpRequest req, HttpResponse res) async {
    final transactionId = await req.params['id'];
    final result = await transactionController.fetchTransaction(transactionId);
    if (result != null) {
      final response = ApiResponse<Transaction>(
        success: true,
        message: 'Transaction fetched successfully',
        data: result,
      );
      await res.json(response.toJson((transaction) => transaction.toJson()));
    } else {
      final response = ApiResponse<void>(
        success: false,
        message: 'Transaction not found',
        data: null,
      );
      await res.json(response.toJson((_) => {}));
    }
  }

  @override
  Future<void> fetchAllTransactions(HttpRequest req, HttpResponse res) async {
    final transactions = await transactionController.fetchAllTransaction();
    final response = ApiResponse<List<Transaction>>(
      success: true,
      message: 'All transactions fetched successfully',
      data: transactions,
    );
    await res.json(response.toJson((transactions) =>
        transactions.map((transaction) => transaction.toJson()).toList()));
  }

  @override
  Future<void> deleteTransaction(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();

    if (jsonData != null) {
      final String userId = jsonData['userId'];
      final String transactionId = jsonData['transactionId'];

      final user = await userController.fetchUser(userId);
      final transaction =
          await transactionController.fetchTransaction(transactionId);

      if (transaction == null) {
        final response = ApiResponse<void>(
          success: false,
          message: 'Transaction not found',
          data: null,
        );
        await res.json(response.toJson((_) => {}));
        return;
      }

      if (user == null) {
        final response = ApiResponse<void>(
          success: false,
          message: 'User not found',
          data: null,
        );
        await res.json(response.toJson((_) => {}));
        return;
      }

      await transactionController.deleteTransaction(transactionId, userId);
      if (!transaction.isActive!) {
        final double newValue = user.accountBalance! - transaction.price!;
        await userController.updateUser(userId, 'accountBalance', newValue);
      }
      await userController.deleteDocument(
          userId, 'transactions', transactionId);

      final response = ApiResponse<void>(
        success: true,
        message: 'Transaction deleted successfully',
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
