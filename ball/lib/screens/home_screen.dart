import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/menu_button.dart';
import 'game_screen.dart';

/// Main menu / home screen of the game.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _startGame() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const GameScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              GameConstants.backgroundColor,
              GameConstants.surfaceColor,
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxHeight < 600;
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isSmall ? 20 : 50),
                      _buildBallIcon(),
                      SizedBox(height: isSmall ? 16 : 30),
                      _buildTitle(),
                      SizedBox(height: isSmall ? 8 : 12),
                      _buildSubtitle(),
                      SizedBox(height: isSmall ? 30 : 60),
                      MenuButton(
                        label: 'PLAY',
                        icon: Icons.play_arrow_rounded,
                        onPressed: _startGame,
                      ),
                      const SizedBox(height: 16),
                      MenuButton(
                        label: 'HOW TO PLAY',
                        icon: Icons.help_outline_rounded,
                        onPressed: _showInstructions,
                        color: GameConstants.surfaceColor,
                      ),
                      SizedBox(height: isSmall ? 20 : 50),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBallIcon() {
    return AnimatedBuilder(
      animation: _bounceAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_bounceAnim.value),
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            colors: [
              Colors.white.withValues(alpha: 0.9),
              GameConstants.accentColor,
              GameConstants.accentColor.withValues(alpha: 0.7),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: GameConstants.accentColor.withValues(alpha: 0.5),
              blurRadius: 24,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [GameConstants.primaryColor, GameConstants.accentColor],
      ).createShader(bounds),
      child: const Text(
        'BALL PHYSICS',
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.w900,
          letterSpacing: 4,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Realistic Bounce Playground',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.6),
        fontSize: 14,
        fontWeight: FontWeight.w300,
        letterSpacing: 2,
      ),
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: GameConstants.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'How to Play',
          style: TextStyle(color: GameConstants.textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InstructionRow(
              icon: Icons.touch_app,
              text: 'Drag the ball to aim and release to launch',
            ),
            SizedBox(height: 12),
            _InstructionRow(
              icon: Icons.ads_click,
              text: 'Tap anywhere to push the ball toward that point',
            ),
            SizedBox(height: 12),
            _InstructionRow(
              icon: Icons.star,
              text: 'Hit colored platforms for bonus points',
            ),
            SizedBox(height: 12),
            _InstructionRow(
              icon: Icons.trending_up,
              text: 'Every bounce earns you a point',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'GOT IT',
              style: TextStyle(color: GameConstants.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InstructionRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: GameConstants.primaryColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: GameConstants.textColor,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
