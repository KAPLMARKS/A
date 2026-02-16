import 'package:flutter/material.dart';

enum TaskCategory {
  focus,
  study,
  work,
  personal;

  String get displayName {
    switch (this) {
      case TaskCategory.focus:
        return 'Focus';
      case TaskCategory.study:
        return 'Study';
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.focus:
        return Icons.center_focus_strong;
      case TaskCategory.study:
        return Icons.menu_book;
      case TaskCategory.work:
        return Icons.work;
      case TaskCategory.personal:
        return Icons.person;
    }
  }
}
