import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../../data/models/admin_prescription_row.dart';

class AdminPrescriptionDetailsDialog extends StatelessWidget {
  final AdminPrescriptionRow prescription;

  const AdminPrescriptionDetailsDialog({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: AdminLocalizations.translate(context, 'prescription details'),
      id: prescription.id.toString(),
      icon: Icons.medication_rounded,
      children: [
        if (prescription.imageUrl.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AppImage(
              imagePath: prescription.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
        ],
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'customer'),
                prescription.customer?.name ?? AdminLocalizations.translate(context, 'guest'),
                Icons.person_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'status'),
                prescription.status.toUpperCase(),
                Icons.flag_rounded,
              ),
            ),
          ],
        ),
        AdminDetailsDialog.buildDetailRow(
          context,
          AdminLocalizations.translate(context, 'customer mobile'),
          prescription.customer?.mobile ?? AdminLocalizations.translate(context, 'n/a'),
          Icons.phone_rounded,
        ),
        AdminDetailsDialog.buildDetailRow(
          context,
          AdminLocalizations.translate(context, 'note / description'),
          prescription.note ?? AdminLocalizations.translate(context, 'no note provided'),
          Icons.description_rounded,
        ),
        const Divider(height: 32),
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'reviewer'),
                prescription.reviewer?.name ?? AdminLocalizations.translate(context, 'not reviewed'),
                Icons.admin_panel_settings_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'submission date'),
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
