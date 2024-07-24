enum CollectionPath {
  users,
  transactions,
  tokens,
  defaults,
  wallets,
  withdrawals
}

extension CollectionPathExtension on CollectionPath {
  String get rawValue {
    switch (this) {
      case CollectionPath.users:
        return 'users';
      case CollectionPath.transactions:
        return 'transactions';
      case CollectionPath.tokens:
        return 'tokens';
      case CollectionPath.defaults:
        return 'defaults';
      case CollectionPath.wallets:
        return 'wallets';
      case CollectionPath.withdrawals:
        return 'withdrawals';
    }
  }
}
