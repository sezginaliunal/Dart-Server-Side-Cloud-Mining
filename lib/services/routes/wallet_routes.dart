import 'package:alfred/alfred.dart';
import 'package:cloud_mining/middleware/authorization.dart';
import 'package:cloud_mining/services/features/wallet.dart';

class WalletRoute {
  final IWalletService walletService = WalletService();
  final Middleware middleware = Middleware();

  Future<void> setupRoutes(NestedRoute app) async {
    app.post(
      '/wallet',
      walletService.addWallet,
      middleware: [middleware.authorize],
    );
    app.get(
      '/wallet/:id',
      walletService.fetchWalletById,
      middleware: [middleware.authorize],
    );
    app.get(
      '/wallet/user/:userId',
      walletService.fetchWalletByUserId,
      middleware: [middleware.authorize],
    );
    app.delete(
      '/wallet',
      walletService.deleteWallet,
      middleware: [middleware.authorize],
    );
    app.put(
      '/wallet',
      walletService.updateWalletAddress,
      middleware: [middleware.authorize],
    );
  }
}
