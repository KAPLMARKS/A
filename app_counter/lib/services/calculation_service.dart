import '../models/earning_calculation.dart';
import '../utils/logger.dart';

/// Service responsible for computing earnings.
class CalculationService {
  const CalculationService();

  /// Calculates total earnings based on [appCount] and [pricePerApp].
  ///
  /// Returns `null` if input values are invalid.
  EarningCalculation? calculate({
    required String appCountText,
    required String pricePerAppText,
  }) {
    try {
      final appCount = int.tryParse(appCountText);
      final pricePerApp = double.tryParse(pricePerAppText);

      if (appCount == null || appCount < 0) {
        AppLogger.info('Invalid app count input: "$appCountText"');
        return null;
      }

      if (pricePerApp == null || pricePerApp < 0) {
        AppLogger.info('Invalid price input: "$pricePerAppText"');
        return null;
      }

      final result = EarningCalculation(
        appCount: appCount,
        pricePerApp: pricePerApp,
      );

      AppLogger.info('Calculation performed: $result');
      return result;
    } catch (e, st) {
      AppLogger.error('Calculation failed', e, st);
      return null;
    }
  }
}
