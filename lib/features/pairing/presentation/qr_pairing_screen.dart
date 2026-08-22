import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/state/print_job_draft.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../main.dart';

class QrPairingScreen extends StatefulWidget {
  const QrPairingScreen({super.key});

  @override
  State<QrPairingScreen> createState() => _QrPairingScreenState();
}

class _QrPairingScreenState extends State<QrPairingScreen> {
  static const _jobId = 'PS-DEMO-4821';
  late int _secondsRemaining;
  Timer? _timer;

  String get _pairingPayload =>
      'printshield://pair?job=$_jobId&expires=$_secondsRemaining&mode=demo';

  @override
  void initState() {
    super.initState();
    _secondsRemaining = printJobDraft.expiryMinutes * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining == 0) {
        _timer?.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    final expired = _secondsRemaining == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pair print shop',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionLabel('STEP 4 OF 4'),
              const SizedBox(height: 14),
              const Text(
                'Scan to pair this job',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ask the shop to scan this code from its PrintShield client.',
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: expired ? .42 : 1,
                    child: InfoCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: QrImageView(
                              data: _pairingPayload,
                              size: 205,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: AppColors.navy,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Temporary pairing code',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          StatusPill(
                            label: expired
                                ? 'EXPIRED'
                                : 'EXPIRES IN $minutes:$seconds',
                            color: expired ? AppColors.slate : AppColors.mint,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'QR contains only a demo job reference and expiry. It does not contain your document.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (!expired)
                FilledButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.jobStatus,
                  ),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Simulate pairing confirmation'),
                )
              else
                FilledButton.icon(
                  onPressed: () => setState(
                    () => _secondsRemaining = printJobDraft.expiryMinutes * 60,
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Generate new code'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO(pairing): Validate the client identity and use a one-time authenticated exchange.
// TODO(delivery): Retrieve/decrypt document material only after pairing succeeds on a real print client.
