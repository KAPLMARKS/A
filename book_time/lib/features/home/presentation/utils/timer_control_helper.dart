import 'package:flutter/material.dart';

import '../bloc/home_state.dart';

class TimerControlHelper {
  TimerControlHelper._();

  static IconData getControlIcon(HomeState state) {
    return state.isRunning ? Icons.pause : Icons.play_arrow;
  }

  static String getControlLabel(HomeState state) {
    return state.isRunning ? 'Pause' : 'Start';
  }

  static void handleControlTap(
    HomeState state,
    Function() onResume,
    Function() onPause,
    Function() onStart,
  ) {
    if (state.isPaused) {
      onResume();
    } else if (state.isRunning) {
      onPause();
    } else {
      onStart();
    }
  }
}
