enum AccountStatus { active, passive, suspended, banned }

extension AccountStatusExtension on AccountStatus {
  int get rawValue {
    switch (this) {
      case AccountStatus.active:
        return 0;
      case AccountStatus.passive:
        return 1;
      case AccountStatus.suspended:
        return 2;

      case AccountStatus.banned:
        return 3;
    }
  }
}
