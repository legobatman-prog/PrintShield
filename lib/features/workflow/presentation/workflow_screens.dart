import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/state/print_job_draft.dart';
import '../../../main.dart';

class DocumentSelectionScreen extends StatelessWidget {
  const DocumentSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) => WorkflowScaffold(
    title: 'Select document',
    step: 'STEP 1 OF 4',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Choose what you want to print',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        const Text('File selection is a UI-only placeholder in this MVP.'),
        const SizedBox(height: 32),
        InfoCard(
          child: Column(
            children: [
              const Icon(
                Icons.upload_file_rounded,
                size: 56,
                color: AppColors.mintDeep,
              ),
              const SizedBox(height: 16),
              const Text(
                'Select a document',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              const SizedBox(height: 6),
              const Text(
                'PDF, image, or supported document',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.analysis),
                icon: const Icon(Icons.folder_open_outlined),
                label: const Text('Use demo document'),
              ),
            ],
          ),
        ),
        const Spacer(),
        FilledButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.analysis),
          child: const Text('Continue to review'),
        ),
      ],
    ),
  );
}

class DocumentAnalysisScreen extends StatelessWidget {
  const DocumentAnalysisScreen({super.key});
  @override
  Widget build(BuildContext context) => WorkflowScaffold(
    title: 'Review document',
    step: 'STEP 2 OF 4',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Choose what to include',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'The following are mock review suggestions, not AI analysis.',
        ),
        const SizedBox(height: 24),
        const _DocumentPreview(),
        const SizedBox(height: 18),
        const _Finding(
          title: 'Identity number',
          subtitle: 'Demo suggestion · selected for print',
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 10),
        const _Finding(
          title: 'Home address',
          subtitle: 'Demo suggestion · selected for print',
          icon: Icons.location_on_outlined,
        ),
        const Spacer(),
        FilledButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.securePrint),
          child: const Text('Continue to print setup'),
        ),
      ],
    ),
  );
}

class SecurePrintScreen extends StatefulWidget {
  const SecurePrintScreen({super.key});

  @override
  State<SecurePrintScreen> createState() => _SecurePrintScreenState();
}

class _SecurePrintScreenState extends State<SecurePrintScreen> {
  Future<void> _chooseCopies() async {
    final choice = await _chooseOption<int>(
      title: 'Print limit',
      options: const {1: '1 copy', 2: '2 copies', 3: '3 copies'},
    );
    if (choice != null) printJobDraft.updateCopies(choice);
  }

  Future<void> _chooseExpiry() async {
    final choice = await _chooseOption<int>(
      title: 'Access expiry',
      options: const {5: '5 minutes', 15: '15 minutes', 30: '30 minutes'},
    );
    if (choice != null) printJobDraft.updateExpiry(choice);
  }

  Future<T?> _chooseOption<T>({
    required String title,
    required Map<T, String> options,
  }) => showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppColors.surface,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...options.entries.map(
              (entry) => ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                title: Text(
                  entry.value,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pop(sheetContext, entry.key),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: printJobDraft,
    builder: (context, child) => WorkflowScaffold(
      title: 'Secure print',
      step: 'STEP 3 OF 4',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Set temporary access',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'These controls model the intended flow; no encryption or pairing runs in this MVP.',
          ),
          const SizedBox(height: 24),
          _Setting(
            icon: Icons.schedule_outlined,
            title: 'Expires after printing',
            value: '${printJobDraft.expiryMinutes} minutes',
            onTap: _chooseExpiry,
          ),
          const SizedBox(height: 12),
          _Setting(
            icon: Icons.print_outlined,
            title: 'Print limit',
            value:
                '${printJobDraft.copies} ${printJobDraft.copies == 1 ? 'copy' : 'copies'}',
            onTap: _chooseCopies,
          ),
          const SizedBox(height: 12),
          _Setting(
            icon: Icons.qr_code_scanner_rounded,
            title: 'Pair with a print shop',
            value: 'Generate a temporary pairing QR',
            onTap: () => Navigator.pushNamed(context, AppRoutes.qrPairing),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.qrPairing),
            icon: const Icon(Icons.qr_code_2_rounded),
            label: const Text('Generate pairing QR'),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Creates no file or security credential.',
              style: TextStyle(fontSize: 12, color: AppColors.slate),
            ),
          ),
        ],
      ),
    ),
  );
}

class PrintJobStatusScreen extends StatelessWidget {
  const PrintJobStatusScreen({super.key});
  @override
  Widget build(BuildContext context) => WorkflowScaffold(
    title: 'Print job status',
    step: 'STEP 4 OF 4',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Your demo job is ready',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 22),
        InfoCard(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: Color(0xFF2A1644),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.mintDeep,
                  size: 45,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Awaiting print-shop pairing',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'QR pairing and job delivery will be integrated here.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              const StatusPill(label: 'DEMO JOB', color: AppColors.warning),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const _Setting(
          icon: Icons.timer_outlined,
          title: 'Expiry policy',
          value: '15 minutes after pairing',
        ),
        const Spacer(),
        FilledButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.verification),
          child: const Text('Verify job settings'),
        ),
      ],
    ),
  );
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _checking = false;
  bool _checked = false;

  Future<void> _runLocalCheck() async {
    setState(() => _checking = true);
    await Future<void>.delayed(const Duration(milliseconds: 850));
    if (mounted) {
      setState(() {
        _checking = false;
        _checked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: printJobDraft,
    builder: (context, child) => WorkflowScaffold(
      title: 'Verification',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              _checked ? Icons.verified_rounded : Icons.verified_user_outlined,
              key: ValueKey(_checked),
              size: 74,
              color: _checked ? AppColors.mint : AppColors.mintDeep,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            _checked ? 'Local settings verified' : 'Verify this demo job',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _checked
                ? 'The displayed copy limit and expiry match your local demo job settings.'
                : 'Check the temporary print settings before pairing with a shop.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          InfoCard(
            child: Column(
              children: [
                _VerificationDetail(
                  label: 'Job reference',
                  value: 'PS-DEMO-4821',
                ),
                const Divider(color: AppColors.line),
                _VerificationDetail(
                  label: 'Print limit',
                  value:
                      '${printJobDraft.copies} ${printJobDraft.copies == 1 ? 'copy' : 'copies'}',
                ),
                const Divider(color: AppColors.line),
                _VerificationDetail(
                  label: 'Temporary expiry',
                  value: '${printJobDraft.expiryMinutes} minutes',
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'MVP note: this is a local UI consistency check, not cryptographic verification or an Ethereum proof.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.slate),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: _checking
                ? null
                : (_checked
                      ? () => Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst)
                      : _runLocalCheck),
            icon: _checking
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.navy,
                    ),
                  )
                : Icon(
                    _checked ? Icons.home_outlined : Icons.verified_outlined,
                  ),
            label: Text(
              _checking
                  ? 'Checking settings...'
                  : (_checked ? 'Back to home' : 'Run local check'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _VerificationDetail extends StatelessWidget {
  const _VerificationDetail({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Text(label, style: const TextStyle(color: AppColors.slate)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class WorkflowScaffold extends StatelessWidget {
  const WorkflowScaffold({
    super.key,
    required this.title,
    required this.child,
    this.step,
  });
  final String title;
  final String? step;
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step != null) ...[
              SectionLabel(step!),
              const SizedBox(height: 14),
            ],
            Expanded(child: child),
          ],
        ),
      ),
    ),
  );
}

class _DocumentPreview extends StatelessWidget {
  const _DocumentPreview();
  @override
  Widget build(BuildContext context) => Container(
    height: 150,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.navy,
      borderRadius: BorderRadius.circular(22),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.picture_as_pdf_outlined, color: AppColors.mint),
        Spacer(),
        Text(
          'income_certificate.pdf',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 4),
        Text(
          '2 pages · Demo document',
          style: TextStyle(color: Color(0xFFB8C6D5)),
        ),
      ],
    ),
  );
}

class _Finding extends StatelessWidget {
  const _Finding({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title, subtitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) => InfoCard(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Icon(icon, color: AppColors.warning),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              Text(subtitle, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const Icon(Icons.check_circle, color: AppColors.mintDeep),
      ],
    ),
  );
}

class _Setting extends StatelessWidget {
  const _Setting({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });
  final IconData icon;
  final String title, value;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: InfoCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.mintDeep),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.slate),
          ],
        ),
      ),
    ),
  );
}

// TODO(security): isolate real encryption, key lifecycle, and revocation in a domain/data layer.
// TODO(ai): integrate consented document analysis; mock findings are not detection.
// TODO(pairing): replace the QR placeholder with authenticated, time-bound print-shop pairing.
// TODO(printing): deliver only an authorized, transient job to the print client.
// TODO(ethereum): add opt-in commitments without placing document content on-chain.
