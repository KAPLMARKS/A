import 'package:flutter/material.dart';
import '../../screens/encyclopedia_screen.dart';
import '../common_button.dart';

/// Main menu overlay shown before the game starts.
class MenuOverlay extends StatelessWidget {
  final int highScore;
  final int bestWave;
  final int bestCombo;
  final int gamesPlayed;
  final int totalPops;
  final VoidCallback onPlay;

  const MenuOverlay({
    super.key,
    required this.highScore,
    required this.bestWave,
    required this.bestCombo,
    required this.gamesPlayed,
    required this.totalPops,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color(0x99000000),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🐔💥', style: TextStyle(fontSize: 72)),
                const SizedBox(height: 8),
                const Text(
                  'POP CHICKEN',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFFD54F),
                    shadows: [
                      Shadow(
                        color: Color(0xFFFF8A65),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 12,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Don't let them cross the river!",
                  style: TextStyle(fontSize: 17, color: Colors.white70),
                ),
                const SizedBox(height: 36),
                CommonButton(label: 'PLAY', onTap: onPlay),
                const SizedBox(height: 12),
                _EncyclopediaButton(),
                if (highScore > 0) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Best: $highScore',
                    style: const TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                ],
                if (bestWave > 1) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Best Wave: $bestWave',
                    style: const TextStyle(fontSize: 16, color: Colors.white54),
                  ),
                ],
                if (gamesPlayed > 0) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$gamesPlayed games  ·  $totalPops pops',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white38),
                        ),
                        if (bestCombo > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Best Combo: x$bestCombo',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.white38),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EncyclopediaButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => const EncyclopediaScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: child,
              ),
            );
          },
        ),
      ),
      icon: const Text('📖', style: TextStyle(fontSize: 20)),
      label: const Text('Encyclopedia'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }
}
