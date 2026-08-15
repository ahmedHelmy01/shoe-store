# Remove Medical & Prescription Features

The application has been successfully transitioned from a pharmacy focus to a shoe retail focus. All references to medical services, prescriptions, and related assets have been removed.

## Changes Made

### 1. Module Deletion
- Deleted `lib/modules/webstore/prescriptions` directory.
- Deleted `lib/modules/webstore/medical_services` directory.
- Deleted `test/medication_reminder_model_test.dart`.

### 2. Navigation & Routing
- Removed all prescription and medical route names from `AppRouteNames`.
- Cleaned up `RouteGenerator` by removing imports and route cases for the deleted modules.

### 3. Home Screen Cleanup
- Updated `FeatureType` and `FeatureItemData` to remove `prescription` and `medicalServices`.
- Updated `FeatureLinksWidget` to remove navigation handling for these features.
- Replaced the medical service icon in `OfferProductsBottomSheet` with a shopping bag icon.

### 4. Localization & Config
- Removed all medical and prescription related keys from `LocaleKeys`.
- Cleaned up `ar.json` and `en.json` by removing over 50 translation entries.
- Moved `pinch_to_zoom` translation to a common location to maintain functionality in the product gallery.
- Removed `showPrescriptionTab` from `CustomSettings`.

### 5. Assets & UI
- Removed medical-related asset paths from `AssetManager`.
- Removed specialized medical shimmers from `AppShimmer`.

### 6. Onboarding Update
- Updated onboarding content in `OnboardingVm` to reflect the new shoe retail focus (e.g., "Welcome to Tarshooby Shoes").

## Verification Results

### Code Integrity
- All broken references caused by module deletion have been resolved (e.g., `pinch_to_zoom` and icons).
- The project structure is now focused solely on retail.

### UI Changes
- The home screen grid now only shows relevant retail features.
- Onboarding slides now promote shoes instead of medicine.

> [!NOTE]
> Physical asset files (PNGs) were not deleted from the `assets/` directory to avoid breaking potential shared resources, but their paths are no longer referenced in the code.
