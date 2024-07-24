enum WithdrawalStatus { approved, canceled, waiting }

extension WithdrawalStatusExtension on WithdrawalStatus {
  int get rawValue {
    switch (this) {
      case WithdrawalStatus.approved:
        return 0;
      case WithdrawalStatus.canceled:
        return 1;
      case WithdrawalStatus.waiting:
        return 2;
    }
  }
}
