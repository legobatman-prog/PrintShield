import 'package:flutter/foundation.dart';

/// UI-only job preferences. This is not a security assessment or policy engine.
class PrintJobDraft extends ChangeNotifier {
  int _copies = 1;
  int _expiryMinutes = 15;

  int get copies => _copies;
  int get expiryMinutes => _expiryMinutes;

  /// A visible MVP heuristic: lower access time and fewer copies score higher.
  int get demoPrivacyScore {
    final expiryScore = switch (_expiryMinutes) {
      5 => 96,
      15 => 90,
      _ => 80,
    };
    return expiryScore - ((_copies - 1) * 4);
  }

  String get scoreStatus =>
      demoPrivacyScore >= 90 ? 'Strong settings' : 'Review settings';

  String get scoreExplanation =>
      'Based on $_copies ${_copies == 1 ? 'copy' : 'copies'} and a $_expiryMinutes-minute expiry.';

  void updateCopies(int value) {
    _copies = value;
    notifyListeners();
  }

  void updateExpiry(int value) {
    _expiryMinutes = value;
    notifyListeners();
  }
}

final printJobDraft = PrintJobDraft();
