/// Model representing a single earning calculation.
class EarningCalculation {
  final int appCount;
  final double pricePerApp;

  const EarningCalculation({
    required this.appCount,
    required this.pricePerApp,
  });

  double get totalEarnings => appCount * pricePerApp;

  @override
  String toString() =>
      'EarningCalculation(apps: $appCount, price: $pricePerApp, total: $totalEarnings)';
}
