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
    final r = AddressFormConstants.fieldRadius;

    return AddressFormSection(
      title: 'المحافظة والمدينة',
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
            'خطأ في تحميل المحافظات',
            style: TextStyle(color: Colors.red, fontSize: 12.sp),
          ),
          data: (governorates) => AppDropdown<int>(
            label: 'المحافظة *',
            hint: 'اختر المحافظة',
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
            label: 'المدينة *',
            hint: 'اختر المحافظة أولاً',
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
              'خطأ في تحميل المدن',
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
            data: (cities) => AppDropdown<int>(
              label: 'المدينة *',
              hint: cities.isEmpty
                  ? 'لا توجد مدن لهذه المحافظة'
                  : 'اختر المدينة',
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
