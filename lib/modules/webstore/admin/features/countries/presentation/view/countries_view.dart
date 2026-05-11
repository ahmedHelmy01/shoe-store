import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/modules/webstore/admin/features/countries/presentation/view_model/countries_view_model.dart';
import 'package:erp/modules/webstore/admin/features/countries/presentation/widgets/countries_table.dart';
import 'package:erp/modules/webstore/admin/features/countries/presentation/widgets/country_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/models/country_row.dart';

class CountriesView extends ConsumerWidget {
  const CountriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(countriesViewModelProvider);
    final vm = ref.read(countriesViewModelProvider.notifier);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: 'Countries',
                primaryActionLabel: 'Add Country',
                onPrimaryAction: () => vm.openAdd(),
                onRefresh: () => vm.fetch(),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildBody(context, state, isDark, vm)),
            ],
          ),
        ),
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: true,
            onClose: () => vm.closePanel(),
            title: state.editingItem == null ? 'Add Country' : 'Edit Country',
            child: CountryForm(
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                final success = await vm.commitSave(
                  data,
                  id: state.editingItem?.id,
                );
                if (success && context.mounted) {
                  AppStatusDialog.showSuccess(
                    context,
                    message: state.editingItem == null
                        ? 'Country created successfully'
                        : 'Country updated successfully',
                  );
                  vm.closePanel();
                } else if (!success && context.mounted) {
                  AppStatusDialog.showError(
                    context,
                    message: 'Failed to save country',
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    AdminCrudState<CountryRow> state,
    bool isDark,
    CountriesViewModel vm,
  ) {
    if (state is AdminCrudLoading &&
        (state as AdminCrudLoading).editingItem == null &&
        !(state as AdminCrudLoading).isAdding) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminCrudError) {
      return AdminStateWidget(
        message: (state as AdminCrudError).message,
        onRetry: () => vm.fetch(),
      );
    }

    final items = state is AdminCrudData<CountryRow>
        ? (state as AdminCrudData<CountryRow>).items
        : <CountryRow>[];

    return AppAnimation.fadeInUp(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1B2D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.05,
            ),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: CountriesTable(
          items: items,
          onEdit: (item) => vm.openEdit(item),
          onDelete: (id) async {
            final success = await vm.commitDelete(id);
            if (context.mounted) {
              if (success) {
                AppStatusDialog.showSuccess(
                  context,
                  message: 'Country deleted successfully',
                );
              } else {
                AppStatusDialog.showError(
                  context,
                  message: 'Failed to delete country',
                );
              }
            }
          },
        ),
      ),
    );
  }
}
