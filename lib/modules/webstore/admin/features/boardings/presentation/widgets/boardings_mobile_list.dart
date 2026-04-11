import 'package:flutter/material.dart';
import '../../data/models/boarding_row.dart';

class BoardingsMobileList extends StatelessWidget {
  final List<BoardingRow> items;

  const BoardingsMobileList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
      ),
      itemBuilder: (context, i) {
        final b = items[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
            child: const Icon(Icons.phonelink_setup_rounded),
          ),
          title: Text(b.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${b.titleAr ?? '-'} • Order: ${b.sortOrder}'),
        );
      },
    );
  }
}
