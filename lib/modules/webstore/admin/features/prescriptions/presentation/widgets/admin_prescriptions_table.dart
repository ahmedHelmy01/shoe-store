import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import '../../data/models/admin_prescription_row.dart';

class AdminPrescriptionsTable extends StatelessWidget {
  final AdminCrudData<AdminPrescriptionRow> state;
  final Function(AdminPrescriptionRow p) onView;
  final Function(AdminPrescriptionRow p) onReview;
  final VoidCallback? onNextPage;
  final VoidCallback? onPrevPage;
  final ValueChanged<int>? onServerPageSize;

  const AdminPrescriptionsTable({
    super.key,
    required this.state,
    required this.onView,
    required this.onReview,
    this.onNextPage,
    this.onPrevPage,
    this.onServerPageSize,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<AdminPrescriptionRow>(
      isServerSide: true,
      serverPage: state.page,
      serverLastPage: state.lastPage ?? 1,
      serverTotal: state.total ?? 0,
      onNextPage: state.canNext ? onNextPage : null,
      onPrevPage: state.canPrev ? onPrevPage : null,
      onServerPageSize: onServerPageSize,
      initialPageSize: state.perPage,
      rows: state.items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'prescriptions',
      columns: [
        AdminColumn<AdminPrescriptionRow>(
          title: 'ID',
          cell: (_, p) => Text('#${p.id}'),
          width: 80,
        ),
        AdminColumn<AdminPrescriptionRow>(
          title: 'Customer',
          cell: (_, p) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                p.customer?.name ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (p.customer?.mobile != null)
                Text(
                  p.customer!.mobile!,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
            ],
          ),
          width: 200,
        ),
        AdminColumn<AdminPrescriptionRow>(
          title: 'Status',
          cell: (_, p) => AdminStatusBadge(
            isActive: true,
            label: p.status.toUpperCase(),
            activeColor: _getStatusColor(p.status),
          ),
          width: 120,
        ),
        AdminColumn<AdminPrescriptionRow>(
          title: 'Reviewer',
          cell: (_, p) => Text(p.reviewer?.name ?? '-'),
          width: 150,
        ),
        AdminColumn<AdminPrescriptionRow>(
          title: 'Date',
          cell: (_, p) =>
              Text(DateFormat('yyyy-MM-dd HH:mm').format(p.createdAt)),
          width: 180,
        ),
        AdminColumn<AdminPrescriptionRow>(
          title: 'Actions',
          cell: (context, p) => AdminTableActionsCell<AdminPrescriptionRow>(
            row: p,
            onView: onView,
            onEdit: p.status == 'pending' ? onReview : null,
          ),
          width: 100,
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    return switch (status.toLowerCase()) {
      'approved' => Colors.green,
      'rejected' => Colors.red,
      'pending' => Colors.orange,
      _ => Colors.grey,
    };
  }
}
