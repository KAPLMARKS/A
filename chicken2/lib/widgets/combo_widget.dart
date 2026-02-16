import 'package:flutter/material.dart';

/// Animated combo indicator shown during active combos.
class ComboWidget extends StatelessWidget {
  final int combo;
  final double topPad;

  const ComboWidget({
    super.key,
    required this.combo,
    required this.topPad,
  });

  @override
  Widget build(BuildContext context) {
    final isMaxed = combo >= 5;
    final text = isMaxed ? 'COMBO x$combo' : 'COMBO x$combo';

    return Positioned(
      top: topPad + 56,
      left: 0,
      right: 0,
      child: Center(
        child: TweenAnimationBuilder<double>(
          key: ValueKey(combo),
          tween: Tween(begin: 1.18, end: 1.0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          builder: (_, v, child) => Transform.scale(scale: v, child: child),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isMaxed
                    ? const [Color(0xFFF44336), Color(0xFF9C27B0)]
                    : const [Color(0xFFFF9800), Color(0xFFF44336)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: (isMaxed
                          ? const Color(0xFFF44336)
                          : const Color(0xFFFF9800))
                      .withValues(alpha: 0.6),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
