import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/support/data/models/contact_request_model.dart';

import 'package:erp/modules/webstore/support/presentation/state/contact_us_state.dart';

class ContactUsVm extends Notifier<ContactUsState> {
  @override
  ContactUsState build() => ContactUsState();

  Future<void> submitContact(ContactRequestModel request) async {
    state = state.copyWith(status: ContactUsStatus.loading);
    
    final result = await ref.read(cmsRepositoryProvider).submitContact(request);
    
    result.when(
      success: (_) {
        state = state.copyWith(status: ContactUsStatus.success);
      },
      failure: (error) {
        state = state.copyWith(status: ContactUsStatus.error, errorMessage: error.message);
      },
    );
  }

  void reset() => state = ContactUsState();
}

final contactUsVmProvider = NotifierProvider<ContactUsVm, ContactUsState>(ContactUsVm.new);
