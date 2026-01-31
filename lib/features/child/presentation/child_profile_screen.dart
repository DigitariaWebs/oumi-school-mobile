import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/ui/animations/animated_entrance.dart';
import '../../../shared/mock/mock_models.dart';
import '../../../shared/mock/mock_providers.dart';
import '../../../shared/widgets/app_section.dart';
import '../../../shared/widgets/progress_pill.dart';

class ChildProfileScreen extends ConsumerWidget {
  const ChildProfileScreen({super.key, required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childrenProvider);
    final child = children.firstWhere((c) => c.id == childId);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profilEnfant)),
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
                      CircleAvatar(
                        radius: 26,
                        child: Text(child.prenom.characters.first.toUpperCase()),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(child.prenom, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 2),
                            Text(
                              '${child.age} ans • ${child.niveau}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      ProgressPill(value: child.progressionGlobale),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppSection(
              title: AppStrings.espaceEnfant,
              child: Column(
                children: [
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 60),
                    child: _ActionCard(
                      icon: Icons.menu_book_rounded,
                      title: AppStrings.curriculum,
                      subtitle: 'Matières, objectifs, planification',
                      onTap: () => context.go('/child/$childId/curriculum'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 120),
                    child: _ActionCard(
                      icon: Icons.checklist_rounded,
                      title: AppStrings.activites,
                      subtitle: 'Séances, ateliers, routines',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('UI uniquement: activités à venir.')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 180),
                    child: _ActionCard(
                      icon: Icons.edit_note_rounded,
                      title: AppStrings.exercices,
                      subtitle: 'Exercices imprimables, entraînement',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('UI uniquement: exercices à venir.')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppSection(
              title: AppStrings.progression,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final subjects = ref.watch(curriculumProvider(childId));
                      return Column(
                        children: [
                          for (var i = 0; i < subjects.length; i++) ...[
                            _SubjectRow(subject: subjects[i]),
                            if (i != subjects.length - 1) const Divider(height: 16),
                          ],
                        ],
                      );
                    },
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

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.subject});

  final SubjectProgress subject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(subject.nom, style: theme.textTheme.titleSmall)),
            Text(
              '${subject.objectifsAtteints}/${subject.objectifsTotal}',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: subject.progression,
            minHeight: 8,
            backgroundColor: cs.outline.withValues(alpha: 0.35),
          ),
        ),
      ],
    );
  }
}

