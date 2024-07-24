import 'package:alfred/alfred.dart';
import 'package:cloud_mining/services/routes/auth_routes.dart';
import 'package:cloud_mining/services/routes/transaction_routes.dart';
import 'package:cloud_mining/services/routes/users.routes.dart';
import 'package:cloud_mining/services/routes/wallet_routes.dart';
import 'package:cloud_mining/services/routes/withdrawal_routes.dart';

class IndexRoute {
  static Future<void> setupRoutes(Alfred app) async {
    final api = app.route('/api');
    await UsersRoute().setupRoutes(api);
    await AuthRoute().setupRoutes(api);
    await TransactionRoute().setupRoutes(api);
    await WalletRoute().setupRoutes(api);
    await WithdrawalRoute().setupRoutes(api);
  }
}
