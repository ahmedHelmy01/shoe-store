import 'package:flutter/material.dart';

class AdminLocalizations {
  static String translate(BuildContext context, String text) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (!isAr) return text;

    final trimmed = text.trim();
    final lowercase = trimmed.toLowerCase();

    // Sidebar items mapping
    switch (lowercase) {
      case 'dashboard':
        return 'لوحة التحكم';
      case 'catalog':
        return 'الكتالوج';
      case 'products':
        return 'المنتجات';
      case 'categories':
        return 'التصنيفات';
      case 'companies':
        return 'الشركات';
      case 'tags':
        return 'الوسوم';
      case 'operations':
        return 'العمليات';
      case 'branches':
        return 'الفروع';
      case 'warehouses':
        return 'المستودعات';
      case 'governorates':
        return 'المحافظات';
      case 'cities':
        return 'المدن';
      case 'countries':
        return 'الدول';
      case 'sales & marketing':
        return 'المبيعات والتسويق';
      case 'all orders':
        return 'كل الطلبات';
      case 'order statuses':
        return 'حالات الطلب';
      case 'coupons':
        return 'الكوبونات';
      case 'payment methods':
        return 'طرق الدفع';
      case 'payment statuses':
        return 'حالات الدفع';
      case 'storefront':
        return 'الواجهة الأمامية';
      case 'sliders':
        return 'البانرات المتحركة';
      case 'ads':
        return 'الإعلانات';
      case 'boardings':
        return 'شاشات الترحيب';
      case 'pages':
        return 'الصفحات';
      case 'properties':
        return 'الخصائص';
      case 'customers':
        return 'العملاء';
      case 'users':
        return 'المستخدمين';
      case 'customer groups':
        return 'مجموعات العملاء';
      case 'clients reports':
        return 'تقارير العملاء';
      case 'addresses':
        return 'العناوين';
      case 'support':
        return 'الدعم الفني';
      case 'messages':
        return 'الرسائل';
      case 'settings':
        return 'الإعدادات';
      
      // Dashboard Stats mapping
      case 'today revenue':
        return 'إيرادات اليوم';
      case 'today orders':
        return 'طلبات اليوم';
      case 'total revenue':
        return 'إجمالي الإيرادات';
      case 'total orders':
        return 'إجمالي الطلبات';
      case 'total customers':
        return 'إجمالي العملاء';

      // Charts and Dashboard titles mapping
      case 'product performance insights':
        return 'تحليلات أداء المنتجات';
      case 'financial contribution (revenue share)':
        return 'المساهمة المالية (حصة الإيرادات)';
      case 'revenue performance (by product)':
        return 'أداء الإيرادات (حسب المنتج)';
      case 'sales':
        return 'المبيعات';

      default:
        return text;
    }
  }

  static String getGreeting(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final hour = DateTime.now().hour;
    if (isAr) {
      if (hour < 12) return 'صباح الخير، أيها المدير';
      if (hour < 17) return 'طاب يومك، أيها المدير';
      return 'مساء الخير، أيها المدير';
    } else {
      String timeStr;
      if (hour < 12) {
        timeStr = 'Morning';
      } else if (hour < 17) {
        timeStr = 'Afternoon';
      } else {
        timeStr = 'Evening';
      }
      return 'Good $timeStr, Admin';
    }
  }
}
