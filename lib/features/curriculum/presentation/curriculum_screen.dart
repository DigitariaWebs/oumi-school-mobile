import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/ui/animations/animated_entrance.dart';
import '../../../shared/mock/mock_models.dart';
import '../../../shared/mock/mock_providers.dart';
import '../../../shared/widgets/app_scaffold.dart';

class CurriculumScreen extends ConsumerWidget {
  const CurriculumScreen({super.key, required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(curriculumProvider(childId));
    final plan = ref.watch(weekPlanProvider);

    return DefaultTabController(
      length: 3,
      child: AppScaffold(
        title: AppStrings.curriculum,
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Matières'),
            Tab(text: AppStrings.semaine),
            Tab(text: AppStrings.suivi),
          ],
        ),
        body: TabBarView(
          children: [
            _SubjectsTab(subjects: subjects),
            _WeekTab(plan: plan),
            _TrackingTab(subjects: subjects),
          ],
        ),
      ),
    );
  }
}

class _SubjectsTab extends StatelessWidget {
  const _SubjectsTab({required this.subjects});

  final List<SubjectProgress> subjects;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: subjects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final s = subjects[i];
        return AnimatedEntrance(
          delay: Duration(milliseconds: i * 60),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(s.nom, style: theme.textTheme.titleMedium)),
                      Text(
                        '${(s.progression * 100).round()} %',
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: s.progression,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.35),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${s.objectifsAtteints}/${s.objectifsTotal} objectifs atteints',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WeekTab extends StatelessWidget {
  const _WeekTab({required this.plan});

  final List plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      children: [
        AnimatedEntrance(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Planification hebdomadaire', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Exemple (UI): vous pourrez bientôt ajuster par enfant, matière et durée.',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < plan.length; i++) ...[
          AnimatedEntrance(
            delay: Duration(milliseconds: i * 60),
            child: Card(
              child: ListTile(
                title: Text('${plan[i].jour} — ${plan[i].titre}'),
                subtitle: Text(plan[i].details),
                trailing: Text('${plan[i].dureeMinutes} min'),
              ),
            ),
          ),
          if (i != plan.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TrackingTab extends StatelessWidget {
  const _TrackingTab({required this.subjects});

  final List<SubjectProgress> subjects;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overall = subjects.isEmpty
        ? 0.0
        : subjects.map((s) => s.progression).reduce((a, b) => a + b) / subjects.length;

    return ListView(
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
                        Text('Progression globale', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(
                          'Synthèse simple (UI).',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${(overall * 100).round()} %', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 80),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recommandations pédagogiques (UI)', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _Reco(text: 'Consolider 1 notion clé en maths (15 min) avant de passer aux exercices.'),
                  const SizedBox(height: 8),
                  _Reco(text: 'Alterner lecture silencieuse et lecture à voix haute (5–10 min).'),
                  const SizedBox(height: 8),
                  _Reco(text: 'Privilégier la régularité plutôt que la quantité.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Reco extends StatelessWidget {
  const _Reco({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline_rounded, size: 18, color: cs.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

