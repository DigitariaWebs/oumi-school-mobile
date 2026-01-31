import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock_data.dart';
import 'mock_models.dart';

final childrenProvider = Provider<List<ChildSummary>>((ref) {
  return MockData.children;
});

final weekPlanProvider = Provider<List<WeekPlanItem>>((ref) {
  return MockData.weeklyPlan;
});

final curriculumProvider = Provider.family<List<SubjectProgress>, String>((ref, childId) {
  if (childId == 'c1') return MockData.curriculumForAya;
  return MockData.curriculumForNassim;
});

