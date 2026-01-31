import 'package:flutter/material.dart';

@immutable
class ChildSummary {
  const ChildSummary({
    required this.id,
    required this.prenom,
    required this.age,
    required this.niveau,
    required this.progressionGlobale,
  });

  final String id;
  final String prenom;
  final int age;
  final String niveau;
  final double progressionGlobale; // 0..1
}

@immutable
class SubjectProgress {
  const SubjectProgress({
    required this.nom,
    required this.progression,
    required this.objectifsAtteints,
    required this.objectifsTotal,
  });

  final String nom;
  final double progression; // 0..1
  final int objectifsAtteints;
  final int objectifsTotal;
}

@immutable
class WeekPlanItem {
  const WeekPlanItem({
    required this.jour,
    required this.titre,
    required this.details,
    required this.dureeMinutes,
  });

  final String jour; // ex: "Lun"
  final String titre;
  final String details;
  final int dureeMinutes;
}

