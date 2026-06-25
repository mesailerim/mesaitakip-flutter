import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';
import 'welcome_screen.dart';
import 'onboarding_screen.dart';
import 'pin_lock_screen.dart';
import 'main_dashboard.dart';

class AppContentManager extends ConsumerStatefulWidget {
  const AppContentManager({super.key});

  @override
  ConsumerState<AppContentManager> createState() => _AppContentManagerState();
}

class _AppContentManagerState extends ConsumerState<AppContentManager> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);
    final settings = state.settings;

    if (settings.userId.isEmpty) {
      return WelcomeScreen();
    }

    if (!settings.hasCompletedOnboarding) {
      return OnboardingScreen();
    }

    if (settings.isPinEnabled && !_unlocked) {
      return PinLockScreen(
        requiredPin: settings.pinCode,
        onSuccess: () => setState(() => _unlocked = true),
      );
    }

    return MainDashboard();
  }
}
