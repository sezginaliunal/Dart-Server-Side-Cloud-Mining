import 'package:cloud_mining/controllers/user_controller.dart';
import 'package:cloud_mining/model/jwt.dart';
import 'package:cloud_mining/services/auth/jwt_service.dart';
import 'package:cloud_mining/services/db/base_db.dart';
import 'package:cloud_mining/services/db/db.dart';
import 'package:cloud_mining/config/constants/collections.dart';
import 'package:cloud_mining/utils/extensions/hash_string.dart';
import 'package:cloud_mining/model/user.dart';

abstract class IAuthController {
  Future<void> register(User user);
  Future<User?> login(String email, String password);
  Future<Jwt> addToken(Jwt jwt);
  Future<bool> isUserExist(User user);
  Future<void> deleteJwtToken(String userId);
}

class AuthController extends IAuthController {
  final IBaseDb _dbInstance = MongoDatabase();
  final IUserController userController = UserController();
  final CollectionPath collectionName = CollectionPath.users;
  final jwtService = JwtService();

  @override
  Future<void> register(User user) async {
    await _dbInstance.insertData(
        collectionName, user.id.toString(), user.toJson());
  }

  @override
  Future<User?> login(String email, String password) async {
    final userJson =
        await _dbInstance.fetchOneData(collectionName, 'email', email);

    if (userJson != null) {
      final user = User.fromJson(userJson);
      if (password.verifySha256(user.password.toString())) {
        return user;
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  Future<Jwt> addToken(Jwt jwt) async {
    await _dbInstance.insertData(
        CollectionPath.tokens, jwt.id.toString(), jwt.toJson());
    return jwt;
  }

  @override
  Future<bool> isUserExist(User user) async {
    print(user.email);
    return await _dbInstance.isItemExist(collectionName, 'email', user.email);
  }

  @override
  Future<void> deleteJwtToken(String userId) {
    return _dbInstance.deleteData(CollectionPath.tokens, 'userId', userId);
  }
}
