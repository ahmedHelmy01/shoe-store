import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';

/// Owns all [TextEditingController]s for add/edit address (keeps view file short).
final class AddressAddEditControllers {
  final TextEditingController name;
  final TextEditingController area;
  final TextEditingController block;
  final TextEditingController street;
  final TextEditingController building;
  final TextEditingController floor;
  final TextEditingController apartment;
  final TextEditingController phone;
  final TextEditingController notes;

  AddressAddEditControllers(AddressModel? a)
      : name = TextEditingController(text: a?.name ?? ''),
        area = TextEditingController(text: a?.area ?? ''),
        block = TextEditingController(text: a?.block ?? ''),
        street = TextEditingController(text: a?.street ?? ''),
        building = TextEditingController(text: a?.building ?? ''),
        floor = TextEditingController(text: a?.floor ?? ''),
        apartment = TextEditingController(text: a?.apartment ?? ''),
        phone = TextEditingController(text: a?.phone ?? ''),
        notes = TextEditingController(text: a?.notes ?? '');

  void dispose() {
    name.dispose();
    area.dispose();
    block.dispose();
    street.dispose();
    building.dispose();
    floor.dispose();
    apartment.dispose();
    phone.dispose();
    notes.dispose();
  }
}
