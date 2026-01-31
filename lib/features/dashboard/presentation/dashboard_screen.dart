import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/ui/animations/animated_entrance.dart';
import '../../../shared/mock/mock_models.dart';
import '../../../shared/mock/mock_providers.dart';
import '../../../shared/state/session_provider.dart';
import '../../../shared/widgets/app_section.dart';
import '../../../shared/widgets/progress_pill.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childrenProvider);
    final plan = ref.watch(weekPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.tableauDeBord),
        actions: [
          IconButton(
            tooltip: 'Déconnexion (mock)',
            onPressed: () {
              ref.read(sessionProvider.notifier).logoutMock();
              context.go(AppRoutes.login);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            AnimatedEntrance(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vue d’ensemble', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 6),
                            Text(
                              'Suivi rapide des enfants, progression et plan de la semaine.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.dashboard_customize_rounded),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppSection(
              title: AppStrings.enfants,
              trailing: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('UI uniquement: ajout d’enfant à venir.')),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text(AppStrings.ajouterUnEnfant),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    AnimatedEntrance(
                      delay: Duration(milliseconds: 60 * i),
                      child: _ChildOpenCard(child: children[i]),
                    ),
                    if (i != children.length - 1) const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppSection(
              title: AppStrings.planSemaine,
              trailing: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('UI uniquement: édition du plan à venir.')),
                  );
                },
                child: const Text(AppStrings.voirPlus),
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (var i = 0; i < plan.length; i++) ...[
                        _WeekPlanRow(item: plan[i]),
                        if (i != plan.length - 1) const Divider(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildOpenCard extends StatelessWidget {
  const _ChildOpenCard({required this.child});

  final ChildSummary child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      openColor: theme.scaffoldBackgroundColor,
      closedColor: theme.cardTheme.color ?? Colors.white,
      closedShape: theme.cardTheme.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      openShape: theme.cardTheme.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      transitionType: ContainerTransitionType.fadeThrough,
      closedBuilder: (context, open) {
        return InkWell(
          onTap: open,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: cs.primary.withValues(alpha: 0.10),
                  child: Text(
                    child.prenom.characters.first.toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(color: cs.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(child.prenom, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        '${child.age} ans • ${child.niveau}',
                        style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ProgressPill(value: child.progressionGlobale),
                const SizedBox(width: 10),
                Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        );
      },
      openBuilder: (context, _) {
        // On utilise le routeur pour garder une navigation cohérente.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/child/${child.id}');
        });
        return const SizedBox.shrink();
      },
    );
  }
}

class _WeekPlanRow extends StatelessWidget {
  const _WeekPlanRow({required this.item});

  final WeekPlanItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.primary.withValues(alpha: 0.14)),
          ),
          child: Center(
            child: Text(
              item.jour,
              style: theme.textTheme.labelLarge?.copyWith(color: cs.primary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.titre, style: theme.textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(item.details, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text('${item.dureeMinutes} min', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
      ],
    );
  }
}

