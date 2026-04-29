import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact_model.dart';

class AdminContactsRepository {
  final NetworkService _network;
  AdminContactsRepository(this._network);

  Future<List<ContactModel>> getContacts({int page = 1}) async {
    final response = await _network.get(
      '/api/store/admin/contacts',
      query: {'page': page, 'per_page': 50},
    );
    
    final List data = (response is Map ? response['data'] : null) ?? [];
    return data.map((e) => ContactModel.fromJson(e)).toList();
  }

  Future<void> deleteContact(int id) async {
    await _network.delete('/api/store/admin/contacts/$id');
  }

  Future<void> markAsRead(int id) async {
    // Usually it's PUT/PATCH /api/store/admin/contacts/{id}
    await _network.put('/api/store/admin/contacts/$id', body: {'is_read': true});
  }
}

final adminContactsRepositoryProvider = Provider<AdminContactsRepository>((ref) {
  return AdminContactsRepository(ref.watch(networkServiceProvider));
});
