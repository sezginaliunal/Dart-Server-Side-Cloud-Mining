import 'package:alfred/alfred.dart';
import 'package:cloud_mining/middleware/authorization.dart';
import 'package:cloud_mining/services/features/auth.dart';

class AuthRoute {
  final IAuthService userService = AuthService();
  final Middleware middleware = Middleware();

  Future<void> setupRoutes(NestedRoute app) async {
    app.post('/auth/register', userService.register);
    app.post('/auth/login', userService.login);
    app.post('/auth/logout', userService.logout,
        middleware: [middleware.authorize]);
    app.post(
      '/auth/resetPassword',
      userService.resetPassword,
    );
    app.post('/auth/checkToken', userService.checkToken);
  }
}
