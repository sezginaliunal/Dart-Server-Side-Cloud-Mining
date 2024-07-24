import 'package:alfred/alfred.dart';
import 'package:cloud_mining/controllers/user_controller.dart';
import 'package:cloud_mining/model/api_response.dart';
import 'package:cloud_mining/model/user.dart';

abstract class IUserService {
  Future<void> getAllUsers(HttpRequest req, HttpResponse res);
  Future<void> getUserById(HttpRequest req, HttpResponse res);
}

class UserService extends IUserService {
  final IUserController userController = UserController();

  @override
  Future<void> getAllUsers(HttpRequest req, HttpResponse res) async {
    final users = await userController.fetchAllUser();

    final userList = users.map((user) {
      return user.copyWith(
        id: user.id,
        wallets: user.wallets,
        transactions: user.transactions,
        email: user.email,
        name: user.name,
        surname: user.surname,
        accountBalance: user.accountBalance,
        accountRole: user.accountRole,
        accountStatus: user.accountStatus,
      );
    }).toList();

    final response = ApiResponse<List<User>>(
      message: 'Users fetched successfully',
      data: userList,
    );

    await res.json(response.toJson((user) => user.toList()));
  }

  @override
  Future<void> getUserById(HttpRequest req, HttpResponse res) async {
    String userId = req.params['id']!;
    final user = await userController.fetchUser(userId);
    if (user != null) {
      final filtredUser = user.copyWith(
        id: user.id,
        wallets: user.wallets,
        transactions: user.transactions,
        email: user.email,
        name: user.name,
        surname: user.surname,
        accountBalance: user.accountBalance,
        accountRole: user.accountRole,
        accountStatus: user.accountStatus,
      );
      final response = ApiResponse<User>(
        message: 'User fetched successfully',
        data: filtredUser,
      );
      await res.json(response.toJson((user) => user.toJson()));
    } else {
      final response = ApiResponse<User>(
        success: false,
        message: 'User not found',
        data: null,
      );
      await res.json(response.toJson((user) => user.toJson()));
    }
  }
}
