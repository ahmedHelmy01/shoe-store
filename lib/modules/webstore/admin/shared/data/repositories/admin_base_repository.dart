import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';

abstract class AdminBaseRepository extends BaseRepository {
  AdminPagedResponse<T> parsePaged<T>(
    Map<String, dynamic> json,
    int fallbackPage,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    var data = json['data'];

    List<dynamic> list;
    int currentPage = fallbackPage;
    int? lastPage;
    int? total;

    if (data is Map) {
      list = (data['data'] as List? ?? const <dynamic>[]);
      currentPage = (data['current_page'] as int?) ?? fallbackPage;
      lastPage = data['last_page'] as int?;
      total = data['total'] as int?;
    } else if (data is List) {
      list = data;
      final meta = json['meta'];
      if (meta is Map) {
        currentPage = (meta['current_page'] as int?) ?? fallbackPage;
        lastPage = meta['last_page'] as int?;
        total = meta['total'] as int?;
      }
    } else {
      list = const <dynamic>[];
    }

    final items = list
        .whereType<Map>()
        .map((e) => fromJson(e.cast<String, dynamic>()))
        .toList(growable: false);

    return AdminPagedResponse<T>(
      items: items,
      page: currentPage,
      lastPage: lastPage,
      total: total,
    );
  }

  T parseSingle<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return fromJson(data);
  }

  Map<String, String> toMultipartFields(Map<String, dynamic> data) {
    final fields = <String, String>{};

    void flatten(String prefix, dynamic value) {
      if (value == null) {
        fields[prefix] = '';
      } else if (value is bool) {
        fields[prefix] = value ? '1' : '0';
      } else if (value is Map) {
        value.forEach((k, v) {
          final nextPrefix = prefix.isEmpty ? k.toString() : '$prefix[$k]';
          flatten(nextPrefix, v);
        });
      } else if (value is List) {
        for (var i = 0; i < value.length; i++) {
          flatten('$prefix[$i]', value[i]);
        }
      } else {
        fields[prefix] = value.toString();
      }
    }

    data.forEach((key, value) {
      flatten(key, value);
    });

    return fields;
  }
}
