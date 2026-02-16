import 'package:flutter/material.dart';

import '../core/constants.dart';

/// A styled button used across the game UI.
class MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double width;

  const MenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? GameConstants.primaryColor;

    return SizedBox(
      width: width,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: btnColor.withValues(alpha: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
