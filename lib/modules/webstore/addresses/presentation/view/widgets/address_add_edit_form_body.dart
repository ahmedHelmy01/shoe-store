import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/modules/webstore/addresses/data/models/lookup_models.dart';
import 'address_add_edit_contact_section.dart';
import 'address_add_edit_governorate_city_section.dart';
import 'address_add_edit_location_section.dart';
import 'address_add_edit_name_section.dart';
import 'address_add_edit_footer.dart';

/// Scrollable body for add/edit address (keeps parent view file small).
class AddressAddEditFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController areaCtrl;
  final TextEditingController blockCtrl;
  final TextEditingController streetCtrl;
  final TextEditingController buildingCtrl;
  final TextEditingController floorCtrl;
  final TextEditingController apartmentCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController notesCtrl;
  final AsyncValue<List<GovernorateModel>> governoratesAsync;
  final AsyncValue<List<CityModel>>? citiesAsync;
  final int? selectedGovernorateId;
  final int? selectedCityId;
  final bool isDefault;
  final bool isSaving;
  final bool isEditMode;
  final ValueChanged<int?> onGovernorateChanged;
  final ValueChanged<int?> onCityChanged;
  final ValueChanged<bool> onDefaultChanged;
  final VoidCallback onSubmit;

  const AddressAddEditFormBody({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.areaCtrl,
    required this.blockCtrl,
    required this.streetCtrl,
    required this.buildingCtrl,
    required this.floorCtrl,
    required this.apartmentCtrl,
    required this.phoneCtrl,
    required this.notesCtrl,
    required this.governoratesAsync,
    required this.citiesAsync,
    required this.selectedGovernorateId,
    required this.selectedCityId,
    required this.isDefault,
    required this.isSaving,
    required this.isEditMode,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onDefaultChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 40.h),
        children: [
          AddressAddEditNameSection(nameController: nameCtrl),
          16.verticalSpace,
          AddressAddEditGovernorateCitySection(
            governoratesAsync: governoratesAsync,
            citiesAsync: citiesAsync,
            selectedGovernorateId: selectedGovernorateId,
            selectedCityId: selectedCityId,
            onGovernorateChanged: onGovernorateChanged,
            onCityChanged: onCityChanged,
          ),
          16.verticalSpace,
          AddressAddEditLocationSection(
            areaCtrl: areaCtrl,
            blockCtrl: blockCtrl,
            streetCtrl: streetCtrl,
            buildingCtrl: buildingCtrl,
            floorCtrl: floorCtrl,
            apartmentCtrl: apartmentCtrl,
          ),
          16.verticalSpace,
          AddressAddEditContactSection(
            phoneCtrl: phoneCtrl,
            notesCtrl: notesCtrl,
          ),
          16.verticalSpace,
          AddressAddEditFooter(
            isDefault: isDefault,
            onDefaultChanged: onDefaultChanged,
            onSubmit: onSubmit,
            isSaving: isSaving,
            isEditMode: isEditMode,
          ),
        ],
      ),
    );
  }
}
