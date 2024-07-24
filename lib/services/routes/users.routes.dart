import 'package:alfred/alfred.dart';
import 'package:cloud_mining/middleware/authorization.dart';
import 'package:cloud_mining/services/features/user.dart';

class UsersRoute {
  final IUserService userService = UserService();
  final Middleware middleware = Middleware();

  Future<void> setupRoutes(NestedRoute app) async {
    app.get(
      '/users',
      userService.getAllUsers,
      middleware: [
        middleware.authorize,
        middleware.isAdmin,
      ],
    );
    app.get(
      '/users/:id',
      userService.getUserById,
      middleware: [middleware.authorize],
    );
  }
}
