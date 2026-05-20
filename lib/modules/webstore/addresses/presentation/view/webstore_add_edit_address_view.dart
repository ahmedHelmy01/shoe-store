import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'package:erp/modules/webstore/addresses/presentation/view_model/address_providers.dart';
import 'package:erp/modules/webstore/addresses/presentation/view/widgets/address_add_edit_controllers.dart';
import 'package:erp/modules/webstore/addresses/presentation/view/widgets/address_add_edit_form_body.dart';

class WebStoreAddEditAddressView extends ConsumerStatefulWidget {
  final AddressModel? addressToEdit;

  const WebStoreAddEditAddressView({super.key, this.addressToEdit});

  @override
  ConsumerState<WebStoreAddEditAddressView> createState() =>
      _WebStoreAddEditAddressViewState();
}

class _WebStoreAddEditAddressViewState
    extends ConsumerState<WebStoreAddEditAddressView> {
  final _formKey = GlobalKey<FormState>();
  late final AddressAddEditControllers _c;
  int? _govId;
  int? _cityId;
  bool _isDefault = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.addressToEdit;
    _c = AddressAddEditControllers(a);
    _govId = a?.governorateId;
    _cityId = a?.cityId;
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_govId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار المحافظة')),
      );
      return;
    }
    if (_cityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار المدينة')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final data = AddressModel(
      id: widget.addressToEdit?.id,
      name: _c.name.text.trim(),
      governorateId: _govId,
      cityId: _cityId,
      area: _c.area.text.trim(),
      block: _c.block.text.trim(),
      street: _c.street.text.trim(),
      building: _c.building.text.trim(),
      floor: _c.floor.text.trim(),
      apartment: _c.apartment.text.trim(),
      phone: _c.phone.text.trim(),
      notes: _c.notes.text.trim(),
      isDefault: _isDefault,
    );
    final err = widget.addressToEdit == null
        ? await ref.read(addressesProvider.notifier).createAddress(data)
        : await ref
            .read(addressesProvider.notifier)
            .updateAddress(widget.addressToEdit!.id!, data);
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (err != null) {
      await AppStatusDialog.showError(
        context,
        title: 'تعذّر حفظ العنوان',
        message: err,
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.addressToEdit == null
              ? 'تمت إضافة العنوان بنجاح'
              : 'تم تعديل العنوان بنجاح',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gov = ref.watch(governoratesProvider);
    final cities = _govId != null ? ref.watch(citiesProvider(_govId!)) : null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        titleText: widget.addressToEdit == null
            ? 'إضافة عنوان جديد'
            : 'تعديل العنوان',
      ),
      body: SafeArea(
        child: AddressAddEditFormBody(
          formKey: _formKey,
          nameCtrl: _c.name,
          areaCtrl: _c.area,
          blockCtrl: _c.block,
          streetCtrl: _c.street,
          buildingCtrl: _c.building,
          floorCtrl: _c.floor,
          apartmentCtrl: _c.apartment,
          phoneCtrl: _c.phone,
          notesCtrl: _c.notes,
          governoratesAsync: gov,
          citiesAsync: cities,
          selectedGovernorateId: _govId,
          selectedCityId: _cityId,
          isDefault: _isDefault,
          isSaving: _isSaving,
          isEditMode: widget.addressToEdit != null,
          onGovernorateChanged: (v) => setState(() {
            _govId = v;
            _cityId = null;
          }),
          onCityChanged: (v) => setState(() => _cityId = v),
          onDefaultChanged: (v) => setState(() => _isDefault = v),
          onSubmit: _save,
        ),
      ),
    );
  }
}
