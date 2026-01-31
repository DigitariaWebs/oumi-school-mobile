import 'mock_models.dart';

class MockData {
  MockData._();

  static const children = <ChildSummary>[
    ChildSummary(
      id: 'c1',
      prenom: 'Aya',
      age: 8,
      niveau: 'Cycle 2',
      progressionGlobale: 0.62,
    ),
    ChildSummary(
      id: 'c2',
      prenom: 'Nassim',
      age: 11,
      niveau: 'Cycle 3',
      progressionGlobale: 0.44,
    ),
  ];

  static const weeklyPlan = <WeekPlanItem>[
    WeekPlanItem(
      jour: 'Lun',
      titre: 'Lecture',
      details: 'Compréhension + résumé (20 min)',
      dureeMinutes: 35,
    ),
    WeekPlanItem(
      jour: 'Mar',
      titre: 'Mathématiques',
      details: 'Fractions — exercices guidés',
      dureeMinutes: 40,
    ),
    WeekPlanItem(
      jour: 'Mer',
      titre: 'Sciences',
      details: 'Expérience: états de l’eau',
      dureeMinutes: 30,
    ),
    WeekPlanItem(
      jour: 'Jeu',
      titre: 'Écriture',
      details: 'Orthographe + dictée courte',
      dureeMinutes: 30,
    ),
    WeekPlanItem(
      jour: 'Ven',
      titre: 'Histoire-Géo',
      details: 'Repères chronologiques + carte',
      dureeMinutes: 35,
    ),
  ];

  static const curriculumForAya = <SubjectProgress>[
    SubjectProgress(nom: 'Français', progression: 0.68, objectifsAtteints: 17, objectifsTotal: 25),
    SubjectProgress(nom: 'Mathématiques', progression: 0.55, objectifsAtteints: 11, objectifsTotal: 20),
    SubjectProgress(nom: 'Sciences', progression: 0.42, objectifsAtteints: 5, objectifsTotal: 12),
    SubjectProgress(nom: 'Histoire-Géo', progression: 0.61, objectifsAtteints: 8, objectifsTotal: 13),
  ];

  static const curriculumForNassim = <SubjectProgress>[
    SubjectProgress(nom: 'Français', progression: 0.49, objectifsAtteints: 12, objectifsTotal: 24),
    SubjectProgress(nom: 'Mathématiques', progression: 0.38, objectifsAtteints: 7, objectifsTotal: 18),
    SubjectProgress(nom: 'Sciences', progression: 0.46, objectifsAtteints: 6, objectifsTotal: 13),
    SubjectProgress(nom: 'Anglais', progression: 0.58, objectifsAtteints: 10, objectifsTotal: 17),
  ];
}

