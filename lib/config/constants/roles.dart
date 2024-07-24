enum Role {
  admin,
  client,
}

extension RoleExtension on Role {
  int get rawValue {
    switch (this) {
      case Role.admin:
        return 0;
      case Role.client:
        return 1;
      default:
        return 1;
    }
  }
}
