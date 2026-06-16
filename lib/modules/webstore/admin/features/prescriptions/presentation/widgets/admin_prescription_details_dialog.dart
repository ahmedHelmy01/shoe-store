import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import '../../data/models/admin_prescription_row.dart';

class AdminPrescriptionDetailsDialog extends StatelessWidget {
  final AdminPrescriptionRow prescription;

  const AdminPrescriptionDetailsDialog({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'Prescription Details',
      id: prescription.id.toString(),
      icon: Icons.medication_rounded,
      children: [
        if (prescription.imageUrl.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              prescription.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Customer',
                prescription.customer?.name ?? 'Guest',
                Icons.person_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Status',
                prescription.status.toUpperCase(),
                Icons.flag_rounded,
              ),
            ),
          ],
        ),
        AdminDetailsDialog.buildDetailRow(
          context,
          'Customer Mobile',
          prescription.customer?.mobile ?? 'N/A',
          Icons.phone_rounded,
        ),
        AdminDetailsDialog.buildDetailRow(
          context,
          'Note / Description',
          prescription.note ?? 'No note provided',
          Icons.description_rounded,
        ),
        const Divider(height: 32),
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Reviewer',
                prescription.reviewer?.name ?? 'Not reviewed',
                Icons.admin_panel_settings_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Submission Date',
                DateFormat('yyyy-MM-dd HH:mm').format(prescription.createdAt),
                Icons.calendar_today_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
