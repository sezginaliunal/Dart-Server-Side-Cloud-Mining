import 'package:alfred/alfred.dart';
import 'package:cloud_mining/config/constants/account_status.dart';
import 'package:cloud_mining/config/constants/defaults.dart';
import 'package:cloud_mining/config/constants/roles.dart';
import 'package:cloud_mining/controllers/auth_controller.dart';
import 'package:cloud_mining/controllers/default_controller.dart';
import 'package:cloud_mining/controllers/user_controller.dart';
import 'package:cloud_mining/model/api_response.dart';
import 'package:cloud_mining/model/jwt.dart';
import 'package:cloud_mining/model/user.dart';
import 'package:cloud_mining/services/auth/jwt_service.dart';
import 'package:cloud_mining/services/server/smtp.dart';
import 'package:cloud_mining/utils/extensions/body_parser.dart';
import 'package:cloud_mining/utils/extensions/hash_string.dart';
import 'package:cloud_mining/utils/extensions/validators.dart';
import 'package:cloud_mining/utils/helpers/generate_password.dart';
import 'package:uuid/uuid.dart';

abstract class IAuthService {
  Future<void> register(HttpRequest req, HttpResponse res);
  Future<void> login(HttpRequest req, HttpResponse res);
  Future<void> logout(HttpRequest req, HttpResponse res);
  Future<void> resetPassword(HttpRequest req, HttpResponse res);
  Future<void> checkToken(HttpRequest req, HttpResponse res);
}

class AuthService extends IAuthService {
  final IAuthController authController = AuthController();
  final IUserController userController = UserController();
  final IDefaultController defaultController = DefaultController();
  final StmpService smtpService = StmpService();
  final JwtService jwtService = JwtService();

  @override
  Future<void> register(HttpRequest req, HttpResponse res) async {
    late double? accountBalance;
    final starterPrice =
        await defaultController.fetchDefault(Defaults.starterPrice);
    if (starterPrice != null) {
      accountBalance = starterPrice.value;
    }
    final jsonData = await req.parseBodyJson();
    if (jsonData != null) {
      final String name = jsonData['name'];
      final String surname = jsonData['surname'];
      final String email = jsonData['email'];
      final String password = jsonData['password'];
      final String pushNotificationId = jsonData['pushNotificationId'];
      if (email.isValidEmail && password.isValidPassword) {
        final user = User(
          id: Uuid().v4(),
          pushNotificationId: pushNotificationId,
          email: email,
          password: password.toSha256(),
          accountBalance: accountBalance ?? Defaults.starterPrice.rawValue,
          accountRole: Role.client.rawValue,
          accountStatus: AccountStatus.active.rawValue,
          name: name,
          surname: surname,
          transactions: [],
          wallets: [],
          withdrawals: [],
        );

        final isUserExist = await authController.isUserExist(user);
        if (isUserExist) {
          final response = ApiResponse<void>(
            success: false,
            message: 'User already exists',
            data: null,
          );
          await res.json(response.toJson((_) => {}));
        } else {
          await authController.register(user);
          final response = ApiResponse<void>(
            success: true,
            message: 'User registered successfully',
            data: null,
          );
          await res.json(response.toJson((_) => {}));
        }
      } else {
        final response = ApiResponse<void>(
          success: false,
          message: 'Invalid email or password',
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
  Future<void> login(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();

    if (jsonData != null) {
      final String email = jsonData['email'];
      final String password = jsonData['password'];

      if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
        final user = await authController.login(email, password);
        if (user != null) {
          final jwt = await JwtService().createJwt(user);
          final jwtDoc = Jwt(
            id: Uuid().v4(),
            token: jwt,
            userId: user.id,
          );
          await authController.deleteJwtToken(user.id.toString());

          await authController.addToken(jwtDoc);
          final response = ApiResponse<Jwt>(
            success: true,
            message: 'Login successful',
            data: jwtDoc,
          );
          await res.json(response.toJson((jwt) => jwt.toJson()));
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
          message: 'All fields must be filled',
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
  Future<void> logout(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();
    if (jsonData != null) {
      final String userId = jsonData['userId'];
      await authController.deleteJwtToken(userId);
      final response = ApiResponse<void>(
        success: true,
        message: 'User logged out successfully',
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
  Future<void> resetPassword(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();
    if (jsonData != null) {
      final String email = jsonData['email'];
      final user = await userController.fetchUserByEmail(email);
      if (user != null) {
        final newPassword = PasswordGenerator.generatePassword();
        await userController.updateUser(
            user.id.toString(), 'password', newPassword.toSha256());

        await smtpService.sendMessage(user.email.toString(), newPassword,
            "${user.name!} ${user.surname}");
        final response = ApiResponse<void>(
          success: true,
          message: 'New password sent to your email',
          data: null,
        );
        await res.json(response.toJson((_) => {}));
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
  Future<void> checkToken(HttpRequest req, HttpResponse res) async {
    final jsonData = await req.parseBodyJson();
    if (jsonData != null) {
      final String token = jsonData['token'];
      final String userId = jsonData['userId'];
      final isChecked = await jwtService.checkJwt(token, userId);
      if (isChecked) {
        final response = ApiResponse<void>(
          success: true,
          message: 'Token valid',
        );
        await res.json(response.toJson((_) => {}));
      } else {
        final response = ApiResponse<void>(
          success: false,
          message: 'Token invalid',
          data: null,
        );
        await res.json(response.toJson((_) => {}));
      }
    }
  }
}
