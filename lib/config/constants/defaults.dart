enum Defaults {
  starterPrice,
  earnPrice,
  startTime,
  endTime,
  miningCheckTime,
  minimumWithdraw
}

extension DefaultsExtension on Defaults {
  dynamic get rawValue {
    switch (this) {
      case Defaults.starterPrice:
        return 2.3;
      case Defaults.earnPrice:
        return 0.2;
      case Defaults.startTime:
        return DateTime.now();
      case Defaults.endTime:
        return DateTime.now().add(Duration(minutes: 15));
      case Defaults.miningCheckTime:
        return Duration(seconds: 1);
      case Defaults.minimumWithdraw:
        return 25.0;
    }
  }

  String get defaultsId {
    switch (this) {
      case Defaults.starterPrice:
        return "1";

      case Defaults.earnPrice:
        return '2';
      case Defaults.startTime:
        return '3';
      case Defaults.endTime:
        return '4';
      case Defaults.miningCheckTime:
        return '5';
      case Defaults.minimumWithdraw:
        return '6';
    }
  }

  String get rawName {
    switch (this) {
      case Defaults.starterPrice:
        return "Başlangıç Parası";

      case Defaults.earnPrice:
        return 'Kazanç miktarı';
      case Defaults.startTime:
        return 'Başlangıç zamanı';
      case Defaults.endTime:
        return 'Bitiş zamanı';
      case Defaults.miningCheckTime:
        return 'Mining kontrol zamanı';
      case Defaults.minimumWithdraw:
        return 'Minimum çekim tutarı';
    }
  }
}
