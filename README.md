# Srekar Fan Association - Flutter Lab Experiments (Exp 2 - 10)

A comprehensive, production-grade Flutter application combining real-world fan association management with a complete academic curriculum implementation for Flutter Lab Experiments 2 through 10.

---

## 🧪 Experiments Matrix (Curriculum Alignment)

| Experiment | Title | Implementation Files | Key Concepts Demonstrated |
| :--- | :--- | :--- | :--- |
| **Exp 2** | **Widgets & Layout Structures** | `lib/screens/gallery_screen.dart`<br>`lib/widgets/stat_card.dart`<br>`lib/widgets/event_card.dart` | `Text`, `Image`, `Container`, `Card`, `Row`, `Column`, `Stack` with `Positioned` overlays |
| **Exp 3** | **Responsive UI & Adaptability** | `lib/widgets/responsive_layout.dart`<br>`lib/screens/home_screen.dart` | Breakpoints (`mobileMax: 650`, `tabletMax: 1000`), `LayoutBuilder`, `MediaQuery`, responsive padding |
| **Exp 4** | **Navigation & Named Routes** | `lib/main.dart`<br>`lib/screens/home_screen.dart` | Declarative routes (`/`, `/experiments`, `/api-feed`, `/membership`, `/events`, etc.), `Navigator.pushNamed` |
| **Exp 5** | **State Management & Lifecycles** | `lib/providers/theme_provider.dart`<br>`lib/providers/api_feed_provider.dart` | Stateful vs Stateless separation, `ChangeNotifier`, `MultiProvider`, `Consumer`, reactive updates |
| **Exp 6** | **Custom Widgets & Styling** | `lib/theme/app_theme.dart`<br>`lib/widgets/pulse_heart.dart`<br>`lib/widgets/stat_card.dart` | Light & Dark Material 3 theme modes, custom color schemes, reusable custom cards and buttons |
| **Exp 7** | **Forms, Inputs & Validation** | `lib/screens/membership_screen.dart` | `GlobalKey<FormState>`, Name min-length check, Email regex validation, 10-digit phone regex, `DropdownButtonFormField`, `FilterChip`, `CheckboxListTile` |
| **Exp 8** | **Animations Framework** | `lib/widgets/pulse_heart.dart`<br>`lib/screens/experiments_hub_screen.dart` | `AnimationController`, `CurvedAnimation`, `Tween`, `SlideTransition`, `FadeTransition`, `ScaleTransition` |
| **Exp 9** | **REST API Integration** | `lib/services/api_service.dart`<br>`lib/models/community_post.dart`<br>`lib/screens/api_feed_screen.dart` | `http` GET/POST, JSON parsing, 3 UI states (Loading, Error with Retry, Success Feed), Search & Pull-to-Refresh |
| **Exp 10** | **Unit & Widget Testing** | `test/unit/model_test.dart`<br>`test/unit/provider_test.dart`<br>`test/widget/experiments_test.dart`<br>`test/widget_test.dart` | Model serialization tests, Provider state logic tests, Widget interaction tests (`tester.pump`, `tester.tap`) |

---

## 🚀 Running the Project

### 1. Run Flutter Analyze
To verify 0 warnings and zero compilation issues:
```bash
flutter analyze
```

### 2. Run the Full Test Suite
To execute all unit and widget tests:
```bash
flutter test
```

### 3. Run the App
Launch on Chrome or Windows desktop:
```bash
flutter run -d chrome
# or
flutter run -d windows
```

---

## 📂 Project Architecture

```
Flutter_lab/
├── lib/
│   ├── main.dart                      # MultiProvider root, theme switching & named routes
│   ├── models/                        # CommunityPost, Member, Event, GalleryItem, Poll, Update
│   ├── providers/                     # ThemeProvider, ApiFeedProvider
│   ├── screens/
│   │   ├── experiments_hub_screen.dart# Lab Hub showcasing Exp 2–10 with interactive modals
│   │   ├── api_feed_screen.dart       # REST API live feed (Exp 9)
│   │   ├── home_screen.dart           # Responsive home dashboard (Exp 2, 3, 4, 5, 6)
│   │   ├── membership_screen.dart     # Membership form with validation (Exp 7)
│   │   ├── events_screen.dart         # Events list & registration
│   │   ├── fans_screen.dart           # Interactive fan community & polls
│   │   ├── gallery_screen.dart        # Association media gallery & hero views
│   │   ├── leadership_screen.dart     # Association committee directory
│   │   ├── profile_screen.dart        # Member profile, dark theme switch, admin access
│   │   └── admin/admin_dashboard.dart # Coordinator dashboard
│   ├── services/                      # ApiService, DatabaseService, AuthService, StorageService
│   ├── theme/                         # AppTheme (Light & Dark ThemeData tokens)
│   └── widgets/                       # PulseHeartButton, ResponsiveLayout, StatCard, EventCard, etc.
└── test/
    ├── unit/
    │   ├── model_test.dart            # Serialization and model mutation tests
    │   └── provider_test.dart         # Theme and REST provider state tests
    ├── widget/
    │   └── experiments_test.dart      # Pulse animation, responsive breakpoints, hub screen tests
    └── widget_test.dart               # App smoke test
```