import 'package:cloud_mining/controllers/transactions_controller.dart';
import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/services/db/db.dart';
import 'package:cloud_mining/services/server/server.dart';

void main() async {
  final IBaseDb db = MongoDatabase();
  await db.connectDb();
  await ServerService().startServer().then(
      (value) async => await TransactionController().startTransactionChecker());
}
