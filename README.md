# Oumi’School (Flutter)

Application mobile (Android & iOS) centrée sur l’accompagnement parental et l’IEF (Instruction En Famille).

## Objectifs (MVP)

- Authentification parent (UI)
- Création / gestion de profils enfants (UI)
- Tableau de bord parent (UI)
- Espace enfant + curriculum + suivi de progression (UI)
- Assistant pédagogique (UI uniquement)
- Ressources (UI)
- Tutorat (optionnel, UI uniquement)

## Stack

- Flutter (stable)
- Material 3
- Clean Architecture (Presentation / Application / Domain / Data)
- Riverpod
- GoRouter
- Freezed + JSON Serializable (modèles prêts)
- Dio (client API – non utilisé dans le MVP UI)
- intl (i18n ready)
- Google Fonts (Inter)

## Lancer le projet

1. Installer Flutter (stable) + SDK Android/iOS.
2. À la racine du repo :

```bash
flutter pub get
flutter run
```

> Ce repo contient uniquement des écrans UI + mock data, sans backend.

