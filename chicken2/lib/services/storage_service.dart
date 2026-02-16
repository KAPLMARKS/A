import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

/// Persists player stats and settings using SharedPreferences.
/// All reads/writes are wrapped in try-catch for safety.
class StorageService {
  static const _tag = 'StorageService';

  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      Log.info(_tag, 'Initialized successfully');
    } catch (e, s) {
      Log.error(_tag, 'Failed to initialize SharedPreferences', e, s);
    }
  }

  // ── Getters ──────────────────────────────────────────────

  int get highScore => _getInt('highScore');
  int get bestWave => _getInt('bestWave');
  int get bestCombo => _getInt('bestCombo');
  int get totalPops => _getInt('totalPops');
  int get gamesPlayed => _getInt('gamesPlayed');
  bool get tutorialSeen => _getBool('tutorialSeen');

  // ── Save ─────────────────────────────────────────────────

  Future<void> saveGameResult({
    required int highScore,
    required int bestWave,
    required int bestCombo,
    required int totalPops,
    required int gamesPlayed,
  }) async {
    try {
      final p = _prefs;
      if (p == null) {
        Log.warn(_tag, 'SharedPreferences not initialized, skipping save');
        return;
      }
      await Future.wait([
        p.setInt('highScore', highScore),
        p.setInt('bestWave', bestWave),
        p.setInt('bestCombo', bestCombo),
        p.setInt('totalPops', totalPops),
        p.setInt('gamesPlayed', gamesPlayed),
        p.setBool('tutorialSeen', true),
      ]);
      Log.info(_tag, 'Game result saved');
    } catch (e, s) {
      Log.error(_tag, 'Failed to save game result', e, s);
    }
  }

  // ── Helpers ──────────────────────────────────────────────

  int _getInt(String key) {
    try {
      return _prefs?.getInt(key) ?? 0;
    } catch (e, s) {
      Log.error(_tag, 'Failed to read int "$key"', e, s);
      return 0;
    }
  }

  bool _getBool(String key) {
    try {
      return _prefs?.getBool(key) ?? false;
    } catch (e, s) {
      Log.error(_tag, 'Failed to read bool "$key"', e, s);
      return false;
    }
  }
}
