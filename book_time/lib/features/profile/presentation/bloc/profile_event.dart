import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStatisticsLoaded extends ProfileEvent {
  const ProfileStatisticsLoaded();
}

class ProfileStatisticsReset extends ProfileEvent {
  const ProfileStatisticsReset();
}

class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested();
}
