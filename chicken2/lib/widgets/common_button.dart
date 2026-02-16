import 'package:flutter/material.dart';

/// Reusable primary action button used across overlays.
class CommonButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CommonButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
        textStyle: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
      child: Text(label),
    );
  }
}
