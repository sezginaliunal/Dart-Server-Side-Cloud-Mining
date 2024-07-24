import 'dart:async';

import 'package:alfred/alfred.dart';
import 'package:cloud_mining/config/constants/roles.dart';
import 'package:cloud_mining/model/api_response.dart';
import 'package:cloud_mining/services/auth/jwt_service.dart';

class Middleware {
  final JwtService jwtService = JwtService();

  FutureOr<void> authorize(HttpRequest req, HttpResponse res) async {
    final authHeader = req.headers.value('Authorization');
    final userId = req.headers.value('userId');
    print(authHeader);
    print(userId);

    if (authHeader == null ||
        !authHeader.startsWith('Bearer ') ||
        userId == null) {
      final response = ApiResponse<void>(
        success: false,
        message: 'Unauthorized operation: Missing or invalid headers',
        data: null,
      );
      res.statusCode = 401;

      await res.json(response.toJson((_) => {}));
      return;
    }

    final token = authHeader.substring(7);

    final isTokenValid = await jwtService.checkJwt(token, userId);

    if (!isTokenValid) {
      final response = ApiResponse<void>(
        success: false,
        message: 'Unauthorized operation: Invalid token',
        data: null,
      );
      res.statusCode = 401;
      await res.json(response.toJson((_) => {}));
      return;
    }
  }

  FutureOr<void> isAdmin(HttpRequest req, HttpResponse res) async {
    final roleHeader = req.headers.value('role');
    if (roleHeader == null || roleHeader != Role.admin.rawValue.toString()) {
      print(roleHeader);
      print(roleHeader.runtimeType);
      final response = ApiResponse<void>(
        success: false,
        message: 'Unauthorized operation: Insufficient permissions',
        data: null,
      );
      res.statusCode = 401;
      await res.json(response.toJson((_) => {}));
      return;
    }
  }
}
