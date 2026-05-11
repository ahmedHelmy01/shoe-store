import 'package:erp/modules/webstore/admin/features/cities/data/models/city_row.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/models/address_row.dart';
import 'package:erp/modules/webstore/admin/features/governorates/presentation/view_model/governorates_view_model.dart';
import 'package:erp/modules/webstore/admin/features/cities/presentation/view_model/cities_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';

class AddressesTable extends ConsumerWidget {
  final List<AddressRow> items;
  final Function(AddressRow address) onEdit;
  final Function(int id) onDelete;

  const AddressesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final governoratesState = ref.watch(governoratesVmProvider);
    final citiesState = ref.watch(citiesVmProvider);

    return AdminDataTable<AddressRow>(
      rows: items,
      idOf: (s) => '${s.id}',
      exportBaseName: 'addresses',
      columns: [
        AdminColumn<AddressRow>(
          title: 'Name',
          cell: (_, s) => Row(
            children: [
              Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (s.isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'DEFAULT',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          width: 150,
        ),
        AdminColumn<AddressRow>(
          title: 'Details',
          cell: (_, s) => Text(
            s.addressDetails ?? 'N/A',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          width: 300,
        ),
        AdminColumn<AddressRow>(
          title: 'Location',
          cell: (_, s) {
            String govName = '-';
            String cityName = '-';

            final govState = governoratesState;
            if (govState is AdminCrudData<GovernorateRow>) {
              govName =
                  govState.items
                      .where((g) => g.id == s.governorateId)
                      .map((g) => g.name)
                      .firstOrNull ??
                  '${s.governorateId ?? "-"}';
            }

            final cityState = citiesState;
            if (cityState is AdminCrudData<CityRow>) {
              cityName =
                  cityState.items
                      .where((c) => c.id == s.cityId)
                      .map((c) => c.name)
                      .firstOrNull ??
                  '${s.cityId ?? "-"}';
            }

            return Text('$govName / $cityName');
          },
          width: 250,
        ),
        AdminColumn<AddressRow>(
          title: 'Mobile',
          cell: (_, s) => Text(s.mobile ?? 'N/A'),
          width: 150,
        ),
        AdminColumn<AddressRow>(
          title: 'Actions',
          cell: (_, s) => AdminTableActionsCell<AddressRow>(
            row: s,
            showView: false,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
          ),
          width: 100,
        ),
      ],
    );
  }
}
