import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Session mock (MVP UI uniquement).
///
/// - `isAuthenticated`: faux par défaut.
/// - Remplacera plus tard une vraie auth + persistance.
class SessionState {
  const SessionState({required this.isAuthenticated, required this.hasOnboarded});

  final bool isAuthenticated;
  final bool hasOnboarded;

  SessionState copyWith({bool? isAuthenticated, bool? hasOnboarded}) {
    return SessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasOnboarded: hasOnboarded ?? this.hasOnboarded,
    );
  }
}

class SessionController extends StateNotifier<SessionState> {
  SessionController()
      : super(const SessionState(isAuthenticated: false, hasOnboarded: false));

  void completeOnboarding() {
    state = state.copyWith(hasOnboarded: true);
  }

  void loginMock() {
    state = state.copyWith(isAuthenticated: true);
  }

  void logoutMock() {
    state = state.copyWith(isAuthenticated: false);
  }
}

final sessionProvider =
    StateNotifierProvider<SessionController, SessionState>((ref) {
  return SessionController();
});

