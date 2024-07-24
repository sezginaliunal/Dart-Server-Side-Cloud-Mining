import 'package:alfred/alfred.dart';
import 'package:cloud_mining/middleware/authorization.dart';
import 'package:cloud_mining/services/features/transaction.dart';

class TransactionRoute {
  final ITransactionService transactionService = TransactionService();
  final Middleware middleware = Middleware();

  Future<void> setupRoutes(NestedRoute app) async {
    app.get(
      '/transaction',
      transactionService.fetchAllTransactions,
      middleware: [middleware.authorize, middleware.isAdmin],
    );
    app.post(
      '/transaction',
      transactionService.addTransaction,
      middleware: [middleware.authorize],
    );

    app.get(
      '/transaction/:id',
      transactionService.fetchTransactionById,
      middleware: [middleware.authorize],
    );
    app.get(
      '/transaction/user/:userId',
      transactionService.fetchTransactionByUserId,
      middleware: [middleware.authorize],
    );
    app.delete(
      '/transaction',
      transactionService.deleteTransaction,
      middleware: [middleware.authorize, middleware.isAdmin],
    );
  }
}
