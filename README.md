# Wassalny — Ride-Hailing Customer App (Flutter UI)

A production-ready Flutter implementation of the **Wassalny** ride-hailing
customer app, built pixel-faithfully from the provided UI design and organised
with **Clean Architecture**.

> UI-only by design: screens use dummy/in-memory data. No real backend, maps SDK
> or business logic beyond what the design shows.

## Screens (19)

Welcome · Onboarding · Location permission · Login · Sign up · OTP · Forgot
password · Home (map) · Search · Driver select · Confirm ride · Finding driver ·
Driver assigned · Live tracking · Trip completed · Wallet · Ride history ·
Notifications · Profile.

The stylised Cairo **map** (city blocks, roads, the Nile, bridges, animated
taxis, the pulsing user dot, the trip route and the moving driver car) is drawn
entirely with `CustomPainter` — no external map dependency.

## Architecture

Clean Architecture with a clear separation between layers, organised by feature.

```
lib/
├── core/                         # cross-cutting, design-system layer
│   ├── constants/                # colors, dimensions, strings
│   ├── theme/                    # ThemeData + text styles
│   ├── utils/                    # gap, shadows
│   ├── router/                   # route names + onGenerateRoute
│   ├── di/                       # composition root (repositories + cubits)
│   └── widgets/                  # global reusable widgets
│       ├── map/                  #   stylised MapView (painter + overlays)
│       └── painters/             #   car glyph / side-car illustrations
│
├── features/
│   ├── onboarding/   presentation
│   ├── auth/         presentation
│   ├── home/         presentation
│   ├── booking/      data · domain · presentation   (the ride flow)
│   ├── wallet/       data · domain · presentation
│   ├── rides/        data · domain · presentation
│   ├── notifications/data · domain · presentation
│   ├── profile/      presentation
│   └── shell/        presentation                   (bottom-nav scaffold)
│
└── main.dart
```

Each data-backed feature follows:

- **domain** — pure entities (`Driver`, `WalletData`, …) + repository
  abstractions. No Flutter imports; colours are stored as ARGB ints and mapped
  to `Color`/`Gradient` in the presentation layer.
- **data** — models, in-memory data sources and repository implementations.
- **presentation** — `Cubit`/state (`flutter_bloc`), pages and widgets.

### State management

`flutter_bloc` (Cubits). The booking flow shares a single `BookingCubit` so the
selected driver / payment / tip / rating persist across the multi-screen flow.

### Design system

- **Colours** — `core/constants/app_colors.dart`
- **Typography** — `core/theme/app_text_styles.dart` (Plus Jakarta Sans, bundled
  in `assets/fonts/`)
- **Spacing & radii** — `core/constants/app_dimens.dart`
- **Copy** — `core/constants/app_strings.dart`

Repeated UI is extracted into reusable widgets under `core/widgets/`
(`PrimaryButton`, `AppTextField`, `AppCard`, `RoundIconButton`, `RouteTimeline`,
`StatusTag`, `SelectableChip`, `RatingPill`, `StarRating`, `GradientAvatar`,
`MapView`, …).

## Getting started

```bash
flutter pub get
flutter run
```

Requires Flutter 3.24+ (Dart 3.5+).

## Tests

```bash
flutter analyze   # 0 issues
flutter test      # smoke + navigation-flow tests
```

`test/navigation_flow_test.dart` walks onboarding → auth → shell tabs and the
booking flow to verify every screen builds and renders (including the animated
map) without exceptions or layout overflows at phone size.
