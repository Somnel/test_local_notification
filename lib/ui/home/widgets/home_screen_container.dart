import 'package:flutter/material.dart';

import 'package:test_notifications/ui/core/ui/bottom_border.dart';
import 'package:test_notifications/ui/home/widgets/home_screen.dart';

class HomeScreenContainer extends StatelessWidget {
  const HomeScreenContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 60,
            children: [
              DecoratedBox(
                decoration: BottomBorder(Theme.of(context).colorScheme.outline),
                child: Padding(
                  padding: const .symmetric(vertical: 16),
                  child: Text(
                    'Criar Notificações', 
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface) 
                          ?? const TextStyle(fontSize: 26)
                  ),
                ),
              ),
              Expanded(child: HomeScreen()),
            ],
          )
        ),
      ),
    );
  }
}