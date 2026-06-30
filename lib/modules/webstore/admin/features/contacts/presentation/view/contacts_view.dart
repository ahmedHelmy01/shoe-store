import 'package:erp/modules/webstore/admin/features/contacts/data/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../view_model/contacts_view_model.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: (isDark ? Colors.white : Colors.black).withOpacity(0.04),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AdminLocalizations.translate(context, 'customer messages'),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AdminLocalizations.translate(context, 'manage inquiries and support requests from your store'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ref.read(adminContactsProvider.notifier).getContacts(),
            icon: isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.refresh_rounded),
            tooltip: AdminLocalizations.translate(context, 'refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildInbox(BuildContext context, WidgetRef ref, AdminContactsState state) {
    final theme = Theme.of(context);
    if (state.contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_read_outlined, size: 64, color: AppColors.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              AdminLocalizations.translate(context, 'no messages found'), 
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.textTheme.titleMedium?.color?.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.contacts.length,
      padding: const EdgeInsets.only(bottom: 24),
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
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppAnimation.fadeInUp(
        child: InkWell(
          onTap: () => _showDetails(context, ref),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: contact.isRead 
                  ? theme.dividerColor.withOpacity(0.05)
                  : AppColors.primary.withOpacity(0.2),
                width: contact.isRead ? 1 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
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
                                color: contact.isRead 
                                    ? theme.textTheme.titleMedium?.color?.withOpacity(0.7) 
                                    : AppColors.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          if (!contact.isRead)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                AdminLocalizations.translate(context, 'new'),
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
                              : AdminLocalizations.translate(context, 'now'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
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
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(contact.isRead ? 0.6 : 1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        contact.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.4),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: AppColors.error.withOpacity(0.5), size: 22),
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
        color: AppColors.primary.withOpacity(0.08),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!contact.isRead) {
      ref.read(adminContactsProvider.notifier).markAsRead(contact.id);
    }
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.dialogBackgroundColor,
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
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          contact.email,
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.6), 
                            fontSize: 13,
                          ),
                        ),
                        if (contact.mobile != null)
                          Text(
                            contact.mobile!,
                            style: TextStyle(
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6), 
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 20, color: theme.iconTheme.color?.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.subject_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        contact.subject,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AdminLocalizations.translate(context, 'message content'),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: theme.textTheme.labelSmall?.color?.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
                ),
                child: Text(
                  contact.message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: theme.dividerColor.withOpacity(0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    AdminLocalizations.translate(context, 'close reader'),
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color, 
                      fontWeight: FontWeight.bold,
                    ),
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
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.dialogBackgroundColor,
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
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: AppColors.error,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AdminLocalizations.translate(context, 'are you sure?'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AdminLocalizations.translate(context, 'this message will be permanently removed. this action cannot be undone.'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
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
                          side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
                        ),
                      ),
                      child: Text(
                        AdminLocalizations.translate(context, 'cancel'),
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7), 
                          fontWeight: FontWeight.bold,
                        ),
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
                      child: Text(
                        AdminLocalizations.translate(context, 'delete now'),
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
