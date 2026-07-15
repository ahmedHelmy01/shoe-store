import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/addresses/data/models/lookup_models.dart';
import 'address_form_constants.dart';
import 'address_form_section.dart';

class AddressAddEditGovernorateCitySection extends StatelessWidget {
  final AsyncValue<List<GovernorateModel>> governoratesAsync;
  final AsyncValue<List<CityModel>>? citiesAsync;
  final int? selectedGovernorateId;
  final int? selectedCityId;
  final ValueChanged<int?> onGovernorateChanged;
  final ValueChanged<int?> onCityChanged;

  const AddressAddEditGovernorateCitySection({
    super.key,
    required this.governoratesAsync,
    required this.citiesAsync,
    required this.selectedGovernorateId,
    required this.selectedCityId,
    required this.onGovernorateChanged,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final keys = LocaleKeys.webstore.addresses;
    final r = AddressFormConstants.fieldRadius;

    return AddressFormSection(
      title: keys.governorate_city.tr(context: context),
      icon: Icons.map_outlined,
      children: [
        governoratesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          error: (_, _) => Text(
            keys.governorates_load_error.tr(context: context),
            style: TextStyle(color: Colors.red, fontSize: 12.sp),
          ),
          data: (governorates) => AppDropdown<int>(
            label: keys.governorate_label.tr(context: context),
            hint: keys.select_governorate.tr(context: context),
            value: selectedGovernorateId,
            borderRadius: r,
            items: governorates
                .map(
                  (gov) => DropdownMenuItem<int>(
                    value: gov.id,
                    child: Text(gov.name),
                  ),
                )
                .toList(),
            onChanged: onGovernorateChanged,
          ),
        ),
        14.verticalSpace,
        if (selectedGovernorateId == null)
          AppDropdown<int>(
            label: keys.city_label.tr(context: context),
            hint: keys.select_governorate_first.tr(context: context),
            value: null,
            enabled: false,
            borderRadius: r,
            items: const [],
            onChanged: null,
          )
        else
          citiesAsync!.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            error: (_, _) => Text(
              keys.cities_load_error.tr(context: context),
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
            data: (cities) => AppDropdown<int>(
              label: keys.city_label.tr(context: context),
              hint: cities.isEmpty
                  ? keys.no_cities_for_governorate.tr(context: context)
                  : keys.select_city.tr(context: context),
              value: selectedCityId,
              enabled: cities.isNotEmpty,
              borderRadius: r,
              items: cities
                  .map(
                    (city) => DropdownMenuItem<int>(
                      value: city.id,
                      child: Text(city.name),
                    ),
                  )
                  .toList(),
              onChanged: onCityChanged,
            ),
          ),
      ],
    );
  }
}
