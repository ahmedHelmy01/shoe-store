# Modular Multi-Flavor ERP | Vertical Slices Architecture

![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue?style=for-the-badge&logo=flutter)
![Architecture](https://img.shields.io/badge/Architecture-Modular_Vertical_Slices-success?style=for-the-badge)

## Core Idea (In Simple Terms)

The whole project is built on one idea: **one source code → many applications**.

Instead of maintaining a separate copy of the code for every client or market, we build a single Flutter app that can turn into multiple applications (Flavors) with a simple choice at build/runtime. Each app has its own identity (logo, colors, fonts, settings, API) and all of that comes from a **JSON config file** — no code changes needed.

Currently there is one active flavor: **`webstore`** (an e-commerce storefront). The structure is ready to add more flavors (e.g. `sales`, `accounting`, `pos`, ...).

---

## How It Works

```
1. Features (business modules) are written once.
2. For each app (Flavor) you define:
   - A JSON config (name, API base URL, colors, bottom nav, enabled features).
   - Its own assets in assets/[flavor]/ (logos, images, fonts).
3. At build time, build_flavor.dart rewrites pubspec.yaml automatically
   so only the selected flavor's assets are bundled.
4. Output: a fully independent APK / AAB / Web app for each client.
```

---

## Architecture

The project uses **Modular Vertical Slices (Feature-First)**:

Instead of the classic layered structure (models / services / screens), the code is grouped by **business domain**, and each module (feature) is a self-contained unit:

```
lib/modules/webstore/
├── auth/            → sign-in & registration
├── home/            → home screen
├── catalog/         → products & categories
├── cart/            → shopping cart
├── checkout/        → checkout & payment
├── orders/          → order tracking & history
├── wishlist/        → favorites
├── profile/         → user profile
└── ... (every module follows the same layout)
```

Each module has a fixed internal layout:

```
auth/
├── data/                ← data layer
│   ├── datasource/      ← API calls
│   ├── models/          ← models / DTOs
│   └── repositories/    ← repository implementations
├── domain/              ← domain layer (entities & use cases)
└── presentation/        ← presentation layer
    ├── view/            ← screens
    ├── view_model/      ← state management (Riverpod)
    └── widgets/         ← reusable UI components
```

> **Why vertical slices?** When you work on a module, everything related to it lives in one place — no need to wander across the whole codebase.

---

## The Core (Shared Layer)

Everything shared across all modules lives in `lib/core/`:

| Folder | Purpose |
| :--- | :--- |
| `config/` | The app "DNA" — flavor definitions, JSON config loading, theme, Firebase, bottom nav |
| `network/` | Central API engine — automatic token injection, error handling, pagination |
| `router/` | Centralized navigation + route guards (`RouteGenerator` + `_guarded()`) |
| `services/` | Sessions, notifications, location, payment gateways (Tabby / Tamara / InstaPay) |
| `security/` | Data encryption & input sanitization |
| `localization/` | Translations (Arabic / English) |
| `theme/` | Light & dark themes |
| `common_widget/` + `common_model/` | Shared widgets and models |

### Config-Driven Apps

Each flavor has a JSON file in `assets/config/` that defines everything:

```json
{
  "appName": "WebStore ERP",
  "baseURL": "https://example.com",
  "assets": { "appLogo": "assets/common/images/logo.png" },
  "bottomNavItems": [...],
  "enabledScreens": ["auth", "webstore_cart", "..."]
}
```

Changing anything for a client = editing JSON only, **no code required**.

---

## Asset Structure

```
assets/
├── common/            ← shared assets for all apps (icons, images, fonts, translations)
└── [flavor_name]/     ← client-specific assets (logo, images, fonts, data file)
```

At build time the script only bundles the selected flavor's assets, keeping the final binary smaller and preventing one client's identity from leaking into another app.

---

## Run & Build Commands

### Run in Development

```bash
# Example: run the webstore flavor
flutter run --flavor webstore -t lib/main_webstore.dart
```

> For web: `flutter run -d chrome -t lib/main_webstore.dart`

### Build for Production

```bash
# Android APK
dart run tool/build_flavor.dart webstore --apk-only

# Android App Bundle (for store release)
dart run tool/build_flavor.dart webstore --aab-only

# Web App
dart run tool/build_flavor.dart webstore --web-only

# All targets at once (APK + AAB + Web)
dart run tool/build_flavor.dart webstore
```

> `build_flavor.dart` does: backup `pubspec.yaml` → rewrite it for the selected flavor → build → keeps the backup in `pubspec_backup.yaml`.

### Adding a New Flavor

1. Add a new enum value in `lib/core/config/app_flavor.dart` (flavor name, config path, enabled features).
2. Create `assets/config/config_[flavor].json`.
3. Create `assets/[flavor]/` asset folder.
4. Create `lib/main_[flavor].dart` calling `bootstrap(AppFlavor.xxx)`.
5. Set up Firebase options (or configure via JSON).
6. Build: `dart run tool/build_flavor.dart [flavor]`.

---

## Tech Stack

- **Flutter** + Dart (SDK ^3.10.4)
- **Riverpod** for state management (with code generation)
- **easy_localization** for translations (Arabic/English)
- **shared_preferences** for local storage
- **Firebase** (Auth + Notifications) + Google / Facebook / Apple sign-in
- **Payment gateways**: Tabby, Tamara, InstaPay (test mode)
- **Maps**: flutter_map + geolocator
- **Reporting**: Syncfusion (PDF + Charts) + Excel

---

## Roadmap

- [x] Core architecture (Core + Vertical Slices + Flavor system)
- [x] `webstore` flavor — e-commerce storefront (auth, catalog, cart, checkout, orders, profile, wishlist, points, notifications, addresses)
- [ ] Document each module separately

---

## Quick Start for New Developers

1. **Prerequisites**: Flutter + Riverpod + the concept of Flavors.
2. **Start here**: `lib/main_webstore.dart` → `lib/app/erp_app_root.dart` (the bootstrap).
3. **Working on a feature**: open its folder under `lib/modules/webstore/` and go from `data/` up to `view/`.
4. **Adding a new feature**: copy the layout of any existing module.
5. **Changing a client's settings**: edit only their JSON file in `assets/config/`.