import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/ui/animations/animated_entrance.dart';
import '../../../shared/state/session_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    ref.read(sessionProvider.notifier).completeOnboarding();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final pages = const [
      _OnboardingPage(
        icon: Icons.calendar_month_rounded,
        title: AppStrings.onboardingTitre1,
        body: AppStrings.onboardingTexte1,
      ),
      _OnboardingPage(
        icon: Icons.account_tree_rounded,
        title: AppStrings.onboardingTitre2,
        body: AppStrings.onboardingTexte2,
      ),
      _OnboardingPage(
        icon: Icons.psychology_alt_rounded,
        title: AppStrings.onboardingTitre3,
        body: AppStrings.onboardingTexte3,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _finish,
            child: const Text(AppStrings.passer),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (v) => setState(() => _index = v),
                  children: pages,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _Dots(count: pages.length, index: _index),
                  const Spacer(),
                  if (_index > 0)
                    SizedBox(
                      height: 48,
                      width: 120,
                      child: OutlinedButton(
                        onPressed: () => _controller.previousPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut,
                        ),
                        child: const Text(AppStrings.retour),
                      ),
                    ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    width: 150,
                    child: FilledButton(
                      onPressed: () {
                        if (_index == pages.length - 1) {
                          _finish();
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      },
                      child: Text(_index == pages.length - 1 ? AppStrings.commencer : AppStrings.continuer),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Pensé pour un usage parental: clair, calme, structuré.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AnimatedEntrance(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
            ),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.2),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          _MiniCard(
            title: 'Conseil',
            body: 'Commencez par 3 objectifs / semaine, puis ajustez selon l’énergie et la disponibilité.',
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(count, (i) {
        final selected = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(right: 6),
          width: selected ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: selected ? cs.primary : cs.outline.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

