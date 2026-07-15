import 'package:erp/modules/webstore/admin/features/contacts/data/models/contact_model.dart';
import 'package:erp/modules/webstore/admin/features/contacts/data/repositories/contacts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AdminContactsState {
  final List<ContactModel> contacts;
  final bool isLoading;
  final String? error;

  AdminContactsState({
    this.contacts = const [],
    this.isLoading = false,
    this.error,
  });

  AdminContactsState copyWith({
    List<ContactModel>? contacts,
    bool? isLoading,
    String? error,
  }) {
    return AdminContactsState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AdminContactsNotifier extends Notifier<AdminContactsState> {
  @override
  AdminContactsState build() {
    Future.microtask(() => getContacts());
    return AdminContactsState(isLoading: true);
  }

  Future<void> getContacts() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(adminContactsRepositoryProvider);
      final list = await repo.getContacts();
      state = state.copyWith(contacts: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        contacts: [], 
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteContact(int id) async {
    try {
      final repo = ref.read(adminContactsRepositoryProvider);
      await repo.deleteContact(id);
      state = state.copyWith(
        contacts: state.contacts.where((c) => c.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete message');
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final repo = ref.read(adminContactsRepositoryProvider);
      await repo.markAsRead(id);
      state = state.copyWith(
        contacts: state.contacts.map((c) {
          if (c.id == id) {
            return ContactModel(
              id: c.id,
              name: c.name,
              email: c.email,
              subject: c.subject,
              message: c.message,
              isRead: true,
              createdAt: c.createdAt,
            );
          }
          return c;
        }).toList(),
      );
    } catch (_) {}
  }
}

final adminContactsProvider = NotifierProvider.autoDispose<AdminContactsNotifier, AdminContactsState>(
  AdminContactsNotifier.new,
);
