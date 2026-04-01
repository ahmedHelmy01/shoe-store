# Moon-ERP | Modular Multi-Flavor Ecosystem

![Production Version](https://img.shields.io/badge/Version-11.0-e11d48?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue?style=for-the-badge&logo=flutter)
![Architecture](https://img.shields.io/badge/Architecture-Modular_Vertical_Slices-success?style=for-the-badge)

Moon-ERP is a cutting-edge Enterprise Resource Planning system built on a **Modular Vertical Slices** architecture. It is designed to generate **16 independent applications** from a single codebase, ensuring maximum code reuse while maintaining complete resource isolation for each client.

---

## 🚀 Key Architectural Pillars

### 1. Modular Vertical Slices (Feature-First)
Unlike traditional layered architectures, Moon-ERP groups code by **Business Domain**. Each module (Sales, Accounting, Inventory, etc.) is a self-contained unit with its own:
- **Data Layer**: Repositories, DTOs, and Data Sources.
- **Domain Layer**: Entities and Use Cases.
- **Presentation Layer**: UI Widgets, State Management (Riverpod), and Logic.

### 2. Assets Genome System
We've implemented a proprietary asset isolation strategy:
- **`assets/common/`**: Shared icons, base fonts, and global translations.
- **`assets/[flavor_name]/`**: Client-specific resources (Logos, branding, local data JSON).
- **Dynamic Bundling**: The build engine injects only the relevant flavor assets into the final binary, reducing app size and ensuring identity privacy.

### 3. Automated Build Engine
The `tool/build_flavor.dart` script is the heart of our automation. It dynamically modifies `pubspec.yaml` during the build process to:
- Inject client-specific fonts and font-families.
- Map the asset registry to the selected flavor.
- Verify resource integrity before compilation.

---

## 🛠️ Command Master Center

### Running the App
To run a specific module in debug mode, use the following pattern:
```bash
# Example: Running the WebStore module
flutter run --flavor webstore -t lib/main_webstore.dart
```

### Building for Production
Our automated build script simplifies complex flavor configurations into single commands:

| Target | Command Pattern |
| :--- | :--- |
| **Android APK** | `dart run tool/build_flavor.dart [flavor] --apk-only` |
| **Android Bundle** | `dart run tool/build_flavor.dart [flavor] --aab-only` |
| **Web App** | `dart run tool/build_flavor.dart [flavor] --web-only` |

*Replace `[flavor]` with any of the 16 supported modules (e.g., `sales`, `accounting`, `pos`).*

---

## 📂 Core Structure Anatomy

- **`lib/core/config/`**: The "DNA" of the app. Handles flavor definitions, theme injection, and environment mapping.
- **`lib/core/network/`**: Centralized API engine with automated token injection and error handling.
- **`lib/core/storage/`**: Secure local data management and session persistence.
- **`lib/core/router/`**: Type-safe navigation engine with route protection (Guards).
- **`lib/features/`**: The modular heart of the system, where business logic resides.

---

## ⚖️ License & Copyright
© 2026 **GT4 GROUP** | Mobile Development Team.
*Building digital systems that dare to define the future.*
