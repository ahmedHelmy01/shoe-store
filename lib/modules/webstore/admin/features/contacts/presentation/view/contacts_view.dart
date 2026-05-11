import 'package:erp/modules/webstore/admin/features/contacts/data/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:intl/intl.dart';
import '../view_model/contacts_view_model.dart';
import '../../../dashboard/presentation/widgets/glass_panel.dart';

class ContactsView extends ConsumerWidget {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminContactsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref, state.isLoading),
            const SizedBox(height: 24),
            Expanded(
              child: state.isLoading && state.contacts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _buildInbox(context, ref, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isLoading) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Messages',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                'Manage inquiries and support requests from your store',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => ref.read(adminContactsProvider.notifier).getContacts(),
          icon: isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.refresh_rounded),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildInbox(BuildContext context, WidgetRef ref, AdminContactsState state) {
    if (state.contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_read_outlined, size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No messages found', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.contacts.length,
      itemBuilder: (context, index) {
        final contact = state.contacts[index];
        return AppAnimation.fadeInUp(
          delay: Duration(milliseconds: index * 50),
          child: _ContactListItem(contact: contact),
        );
      },
    );
  }
}

class _ContactListItem extends ConsumerWidget {
  final ContactModel contact;
  const _ContactListItem({required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fg = theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppAnimation.fadeInUp(
        child: InkWell(
          onTap: () => _showDetails(context, ref),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: contact.isRead 
                  ? fg.withValues(alpha: 0.05)
                  : AppColors.primary.withValues(alpha: 0.2),
                width: contact.isRead ? 1 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey).withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildAvatar(contact),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: contact.isRead ? fg.withValues(alpha: 0.8) : AppColors.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          if (!contact.isRead)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Text(
                            contact.createdAt != null 
                              ? DateFormat('hh:mm a').format(contact.createdAt!)
                              : 'Now',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: fg.withValues(alpha: 0.4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: contact.isRead ? FontWeight.w600 : FontWeight.w800,
                          color: fg.withValues(alpha: contact.isRead ? 0.6 : 0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        contact.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: fg.withValues(alpha: 0.4),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.delete_sweep_outlined, color: AppColors.error.withValues(alpha: 0.5), size: 22),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ContactModel contact) {
    final initials = contact.name.isNotEmpty ? contact.name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase() : '?';
    
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: AppColors.primary, 
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, WidgetRef ref) {
    if (!contact.isRead) {
      ref.read(adminContactsProvider.notifier).markAsRead(contact.id);
    }
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatar(contact),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          contact.email,
                          style: TextStyle(color: Colors.black.withValues(alpha: 0.5), fontSize: 13),
                        ),
                        if (contact.mobile != null)
                          Text(
                            contact.mobile!,
                            style: TextStyle(color: Colors.black.withValues(alpha: 0.5), fontSize: 13),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  contact.subject,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'MESSAGE CONTENT',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                contact.message,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black.withValues(alpha: 0.03),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Close Reader',
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.error,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Are you sure?',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This message will be permanently removed. This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.5),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(adminContactsProvider.notifier).deleteContact(contact.id);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Delete Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
