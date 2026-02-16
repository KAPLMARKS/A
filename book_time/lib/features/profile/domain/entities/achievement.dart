import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String title;
  final bool isUnlocked;

  const Achievement({
    required this.title,
    required this.isUnlocked,
  });

  @override
  List<Object?> get props => [title, isUnlocked];
}
