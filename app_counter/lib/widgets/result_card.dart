import 'package:flutter/material.dart';

import '../models/earning_calculation.dart';

/// Displays the calculation result in a visually prominent card.
class ResultCard extends StatelessWidget {
  final EarningCalculation? calculation;

  const ResultCard({super.key, this.calculation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasResult = calculation != null;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Card(
        key: ValueKey(calculation?.totalEarnings ?? 0),
        color: hasResult
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            children: [
              Icon(
                hasResult
                    ? Icons.attach_money_rounded
                    : Icons.calculate_outlined,
                size: 40,
                color: hasResult
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                hasResult ? 'Ваш заработок' : 'Введите данные',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: hasResult
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (hasResult) ...[
                const SizedBox(height: 8),
                Text(
                  '\$${calculation!.totalEarnings.toStringAsFixed(2)}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${calculation!.appCount} × \$${calculation!.pricePerApp.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer
                        .withAlpha(180),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
