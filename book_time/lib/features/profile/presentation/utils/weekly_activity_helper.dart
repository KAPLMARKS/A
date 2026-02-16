class WeeklyActivityHelper {
  WeeklyActivityHelper._();

  static int getMaxMinutes(Map<String, int> weekData) {
    return weekData.values.fold<int>(
      0,
      (max, value) => value > max ? value : max,
    );
  }

  static double calculateBarHeight(
    int minutes,
    int maxMinutes,
    double maxHeight,
  ) {
    if (maxMinutes == 0) return 0.0;
    return (minutes / maxMinutes) * maxHeight;
  }
}
