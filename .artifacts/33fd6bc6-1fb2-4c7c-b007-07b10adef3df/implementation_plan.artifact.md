# Remove Prescription and Medical Features

The app is transitioning from a medical/pharmacy focus to a shoe selling program. As requested, the "Prescription" (الروشته) feature and all its related components (including Medical Services) will be removed.

## User Review Required

> [!IMPORTANT]
> This will permanently delete the source code for the Prescription and Medical Services modules. Ensure that no data from these features needs to be migrated or preserved.

## Proposed Changes

### Core Routing & Navigation

#### [MODIFY] [app_navigator.dart](file:///C:/Users/helme/StudioProjects/erp/lib/core/router/app_navigator.dart)
- Remove `webstorePrescriptions`, `webstoreUploadPrescription`, `webstorePrescriptionDetails` constants.
- Remove `medicalServicesMain`, `medicalReminders` constants.

#### [MODIFY] [route_generator.dart](file:///C:/Users/helme/StudioProjects/erp/lib/core/router/route_generator.dart)
- Remove imports for Prescription and Medical Services views and models.
- Remove `switch` cases for prescription and medical routes.

### Modules & Features

#### [DELETE] `lib/modules/webstore/prescriptions`
#### [DELETE] `lib/modules/webstore/medical_services`

#### [MODIFY] [feature_item_data.dart](file:///C:/Users/helme/StudioProjects/erp/lib/modules/webstore/home/presentation/view/widgets/feature_item_data.dart)
- Remove `prescription` and `medicalServices` from `FeatureType` enum.
- Remove their entries from `FeatureItemData.all`.
- Update `title()` method to remove removed types.

#### [MODIFY] [feature_links_widget.dart](file:///C:/Users/helme/StudioProjects/erp/lib/modules/webstore/home/presentation/view/widgets/feature_links_widget.dart)
- Remove `switch` cases for `prescription` and `medicalServices` in `_handleFeatureTap`.

### Localization & Config

#### [MODIFY] [locale_keys.dart](file:///C:/Users/helme/StudioProjects/erp/lib/core/localization/locale_keys.dart)
- Remove `_WebStorePrescriptions` class and `prescriptions` property.
- Remove `medical_services` and `feature_medical_services` keys.

#### [MODIFY] [ar.json](file:///C:/Users/helme/StudioProjects/erp/assets/common/translations/ar.json)
- Remove all prescription and medical related translations.

#### [MODIFY] [en.json](file:///C:/Users/helme/StudioProjects/erp/assets/common/translations/en.json)
- Remove all prescription and medical related translations.

#### [MODIFY] [webstore_endpoints.dart](file:///C:/Users/helme/StudioProjects/erp/lib/core/network/endpoints/webstore_endpoints.dart)
- Remove `_WebStorePrescriptions` class and `prescriptions` property.

#### [MODIFY] [custom_settings.dart](file:///C:/Users/helme/StudioProjects/erp/lib/core/config/custom_settings.dart)
- Remove `showPrescriptionTab` field.

### Miscellaneous Cleanup

#### [MODIFY] [asset_manager.dart](file:///C:/Users/helme/StudioProjects/erp/lib/core/utils/asset_manager.dart)
- Remove `medicalServices` and `medicine` assets.

#### [MODIFY] [app_shimmer.dart](file:///C:/Users/helme/StudioProjects/erp/lib/core/common_widget/app_shimmer/app_shimmer.dart)
- Remove medical services specialized shimmer.

#### [MODIFY] [onboarding_view_model.dart](file:///C:/Users/helme/StudioProjects/erp/lib/modules/webstore/onboarding/presentation/view_model/onboarding_view_model.dart)
- Update onboarding text to remove reference to medicines and medical equipment.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no broken references remain.
- Build the app to verify it still compiles.

### Manual Verification
- Verify the home screen no longer shows Prescription or Medical Services links.
- Verify that attempting to navigate to these routes (if possible) results in an error or is blocked.
