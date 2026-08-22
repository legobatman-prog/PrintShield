import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/pairing/presentation/qr_pairing_screen.dart';
import 'features/workflow/presentation/workflow_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PrintShieldApp());
}

class PrintShieldApp extends StatelessWidget {
  const PrintShieldApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'PrintShield',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    initialRoute: AppRoutes.splash,
    onGenerateRoute: AppRouter.onGenerateRoute,
  );
}

abstract final class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const selectDocument = '/select-document';
  static const analysis = '/analysis';
  static const securePrint = '/secure-print';
  static const jobStatus = '/job-status';
  static const verification = '/verification';
  static const qrPairing = '/qr-pairing';
}

abstract final class AppRouter {
  static Route<void> onGenerateRoute(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoutes.splash => const SplashScreen(),
      AppRoutes.home => const HomeScreen(),
      AppRoutes.selectDocument => const DocumentSelectionScreen(),
      AppRoutes.analysis => const DocumentAnalysisScreen(),
      AppRoutes.securePrint => const SecurePrintScreen(),
      AppRoutes.jobStatus => const PrintJobStatusScreen(),
      AppRoutes.verification => const VerificationScreen(),
      AppRoutes.qrPairing => const QrPairingScreen(),
      _ => const HomeScreen(),
    };
    return PageRouteBuilder<void>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: page,
      ),
      transitionDuration: const Duration(milliseconds: 260),
    );
  }
}
