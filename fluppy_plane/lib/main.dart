import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'utils/app_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait & hide system UI for immersive game experience
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  AppLogger.info('Fluppy Plane starting');
  runApp(const FluppyPlaneApp());
}
