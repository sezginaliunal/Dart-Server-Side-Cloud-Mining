import 'package:alfred/alfred.dart';
import 'package:cloud_mining/middleware/authorization.dart';
import 'package:cloud_mining/services/features/withdrawal.dart';

class WithdrawalRoute {
  final IWithdrawalService withdrawalService = WithdrawalService();
  final Middleware middleware = Middleware();

  Future<void> setupRoutes(NestedRoute app) async {
    app.get(
      '/withdrawal',
      withdrawalService.fetchAllWithdrawals,
      middleware: [middleware.authorize, middleware.isAdmin],
    );
    app.post(
      '/withdrawal',
      withdrawalService.addWithdrawal,
      middleware: [middleware.authorize],
    );
    app.get(
      '/withdrawal/:id',
      withdrawalService.fetchWithdrawalById,
      middleware: [middleware.authorize],
    );
    app.get(
      '/withdrawal/:id',
      withdrawalService.fetchWithdrawalById,
      middleware: [middleware.authorize],
    );
    app.get(
      '/withdrawal/user/:userId',
      withdrawalService.fetchWithdrawalByUserId,
      middleware: [middleware.authorize],
    );
    app.delete(
      '/withdrawal',
      withdrawalService.deleteWithdrawal,
      middleware: [middleware.authorize],
    );
    app.put(
      '/withdrawal',
      withdrawalService.updateWithdrawal,
      middleware: [middleware.authorize, middleware.isAdmin],
    );
  }
}
