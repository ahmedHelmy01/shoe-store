import 'package:flutter/material.dart';
import '../../data/models/ad_row.dart';

class AdsMobileList extends StatelessWidget {
  final List<AdRow> items;

  const AdsMobileList({super.key, required this.items});

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
        final a = items[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
            child: const Icon(Icons.campaign_rounded),
          ),
          title: Text(a.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${a.location ?? '-'} • ${a.titleAr ?? '-'}'),
          trailing: Text(a.isActive ? 'Active' : 'Disabled'),
        );
      },
    );
  }
}
