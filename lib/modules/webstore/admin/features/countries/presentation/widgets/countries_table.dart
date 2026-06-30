import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/models/country_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

class CountriesTable extends StatelessWidget {
  final List<CountryRow> items;
  final void Function(CountryRow) onEdit;
  final void Function(int) onDelete;

  const CountriesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CountryRow>(
      rows: items,
      idOf: (item) => item.id.toString(),
      exportBaseName: 'countries',
      searchHint: AdminLocalizations.translate(context, 'search countries...'),
      searchText: (item) => '${item.name} ${item.nameAr ?? ""} ${item.code ?? ""}',
      columns: [
        AdminColumn<CountryRow>(
          title: AdminLocalizations.translate(context, 'country'),
          width: 250,
          cell: (_, item) => Row(
            children: [
              _CountryFlag(code: item.code),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.nameAr ?? item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (item.nameAr != null)
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AdminColumn<CountryRow>(
          title: AdminLocalizations.translate(context, 'code'),
          width: 100,
          cell: (_, item) => Text(item.code ?? '-', style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600)),
        ),
        AdminColumn<CountryRow>(
          title: AdminLocalizations.translate(context, 'phone'),
          width: 120,
          cell: (_, item) => Text(item.phoneCode ?? '-', style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        AdminColumn<CountryRow>(
          title: AdminLocalizations.translate(context, 'status'),
          width: 120,
          cell: (_, item) => AdminStatusBadge(isActive: item.isActive),
        ),
        AdminColumn<CountryRow>(
          title: AdminLocalizations.translate(context, 'actions'),
          width: 120,
          cell: (_, item) => AdminTableActionsCell<CountryRow>(
            row: item,
            onEdit: onEdit,
            onDelete: (it) => onDelete(it.id),
            onView: (it) {
              showDialog(
                context: context,
                builder: (_) => CountryDetailsDialog(country: it),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CountryDetailsDialog extends StatelessWidget {
  final CountryRow country;
  const CountryDetailsDialog({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: AdminLocalizations.translate(context, 'country details'),
      id: country.id.toString(),
      icon: Icons.public_rounded,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CountryFlag(code: country.code, size: 48),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    country.nameAr ?? country.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    country.name,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'phone code'),
                country.phoneCode ?? AdminLocalizations.translate(context, 'n/a'),
                Icons.phone_enabled_rounded,
              ),
            ),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'iso code'),
                country.code ?? AdminLocalizations.translate(context, 'n/a'),
                Icons.code_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AdminDetailsDialog.buildStatusRow(context, country.isActive),
      ],
    );
  }
}

class _CountryFlag extends StatelessWidget {
  final String? code;
  final double size;
  const _CountryFlag({this.code, this.size = 32});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Center(
        child: Text(
          code ?? '?',
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w900,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
