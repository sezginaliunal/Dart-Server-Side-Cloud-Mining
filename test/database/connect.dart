import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/services/db/db.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

void main() {
  test('Connection', () async {
    // final IBaseDb db = MongoDatabase();
    // await db.connectDb();
    // final result = await db.isDbOpen();

    // expect(result, true);

    final conn = PostgreSQLConnection('localhost', 5432, "golang",
        username: 'postgres', password: "0808");
  });
}
