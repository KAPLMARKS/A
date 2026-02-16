import '../models/navigation_item.dart';
import 'navigation_constants.dart';
import 'navigation_labels.dart';

class BottomNavigationConstants {
  BottomNavigationConstants._();

  static const List<NavigationItem> navigationItems = [
    NavigationItem(
      iconPath: '',
      label: NavigationLabels.home,
      route: NavigationConstants.home,
    ),
    NavigationItem(
      iconPath: '',
      label: NavigationLabels.tasks,
      route: NavigationConstants.tasks,
    ),
    NavigationItem(
      iconPath: '',
      label: NavigationLabels.profile,
      route: NavigationConstants.profile,
    ),
  ];
}
