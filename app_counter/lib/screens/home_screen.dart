import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/earning_calculation.dart';
import '../services/calculation_service.dart';
import '../utils/logger.dart';
import '../widgets/input_card.dart';
import '../widgets/result_card.dart';

/// Main screen where the user enters data and sees the result.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _appCountController = TextEditingController();
  final _priceController = TextEditingController(text: '25');
  final _calculationService = const CalculationService();

  EarningCalculation? _result;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    AppLogger.info('HomeScreen initialized');
  }

  @override
  void dispose() {
    _appCountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      _errorMessage = null;
    });

    final result = _calculationService.calculate(
      appCountText: _appCountController.text.trim(),
      pricePerAppText: _priceController.text.trim(),
    );

    if (result == null) {
      setState(() {
        _errorMessage = 'Пожалуйста, введите корректные числа';
        _result = null;
      });
      return;
    }

    setState(() {
      _result = result;
    });
  }

  void _reset() {
    AppLogger.info('Reset performed');
    setState(() {
      _appCountController.clear();
      _priceController.text = '25';
      _result = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Counter'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Сбросить',
            onPressed: _reset,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final horizontalPadding = isWide
                ? (constraints.maxWidth - 500) / 2
                : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ResultCard(calculation: _result),
                  const SizedBox(height: 24),
                  InputCard(
                    label: 'Количество приложений',
                    hint: 'Например: 5',
                    icon: Icons.apps_rounded,
                    controller: _appCountController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 12),
                  InputCard(
                    label: 'Цена за приложение (\$)',
                    hint: 'Например: 25',
                    icon: Icons.monetization_on_outlined,
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _calculate,
                    child: const Text('Рассчитать'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
