import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/state/print_job_draft.dart';
import '../../../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Row(
            children: [
              const ShieldMark(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PrintShield',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Text('Privacy-first printing'),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _SecurityHero(
            onSecure: () =>
                Navigator.pushNamed(context, AppRoutes.selectDocument),
          ),
          const SizedBox(height: 26),
          const SectionLabel('Your privacy score'),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: printJobDraft,
            builder: (context, child) => InfoCard(
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: .86,
                          strokeWidth: 7,
                          color: AppColors.mintDeep,
                          backgroundColor: AppColors.line,
                        ),
                        Center(
                          child: Text(
                            '${printJobDraft.demoPrivacyScore}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          printJobDraft.scoreStatus,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          printJobDraft.scoreExplanation,
                          style: TextStyle(color: AppColors.ink),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SectionLabel('Recent print jobs'),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.jobStatus),
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const _JobTile(
            name: 'Income Certificate.pdf',
            detail: 'Yesterday · 2 pages',
            status: 'Expired',
            color: AppColors.slate,
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 10),
          const _JobTile(
            name: 'Medical Report.pdf',
            detail: '18 Aug · 4 pages',
            status: 'Completed',
            color: AppColors.mintDeep,
            icon: Icons.health_and_safety_outlined,
          ),
        ],
      ),
    ),
  );
}

class _SecurityHero extends StatelessWidget {
  const _SecurityHero({required this.onSecure});
  final VoidCallback onSecure;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.navy, AppColors.purpleGlow],
      ),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusPill(label: 'MVP DEMO MODE', color: AppColors.mint),
        const SizedBox(height: 22),
        const Text(
          'Print privately.\nStay in control.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Create a temporary print job with clear, user-approved settings.',
          style: TextStyle(color: Color(0xFFC4D3E0), height: 1.4),
        ),
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: onSecure,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.mint,
            foregroundColor: AppColors.navy,
          ),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Secure a document'),
        ),
      ],
    ),
  );
}

class _JobTile extends StatelessWidget {
  const _JobTile({
    required this.name,
    required this.detail,
    required this.status,
    required this.color,
    required this.icon,
  });
  final String name, detail, status;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) => InfoCard(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: AppColors.cloud,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.mintDeep),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: const TextStyle(fontSize: 12, color: AppColors.slate),
              ),
            ],
          ),
        ),
        StatusPill(label: status, color: color),
      ],
    ),
  );
}
