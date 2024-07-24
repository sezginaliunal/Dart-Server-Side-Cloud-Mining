import 'package:cloud_mining/config/constants/collections.dart';
import 'package:cloud_mining/model/jwt.dart';
import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/services/db/db.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:cloud_mining/config/load_env.dart';
import 'package:cloud_mining/model/user.dart';

class JwtService {
  static final JwtService _instance = JwtService._init();
  late final Env _env;
  final IBaseDb _db = MongoDatabase();

  JwtService._init() {
    _env = Env();
  }

  factory JwtService() => _instance;

  Future<String> createJwt(User user) async {
    final payload = {
      'sub': user.id,
      'name': user.email,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) +
          int.parse(_env.envConfig.jwtExpirationSeconds),
    };

    final jwt = JWT(
      payload,
      issuer: _env.envConfig.jwtIssuer,
    );

    final secretKey = SecretKey(_env.envConfig.jwtSecretKey);
    final token = jwt.sign(secretKey);

    return token;
  }

  Future<bool> checkJwt(String token, String userId) async {
    try {
      final isTokenExist =
          await _db.isItemExist(CollectionPath.tokens, 'token', token);

      if (isTokenExist) {
        final getToken =
            await _db.fetchOneData(CollectionPath.tokens, 'token', token);
        if (getToken != null) {
          final parsedJwt = Jwt.fromJson(getToken);
          if (parsedJwt.userId != userId) {
            return false;
          }
          JWT.verify(parsedJwt.token.toString(),
              SecretKey(_env.envConfig.jwtSecretKey));
          return true;
        }
      }
      return false;
    } on JWTExpiredException {
      print('expired');
      return false;
    } on JWTException {
      return false;
    }
  }
}
