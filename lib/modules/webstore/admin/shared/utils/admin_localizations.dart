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
      case 'prescriptions':
        return 'طلبات الروشتات';
      case 'sales & marketing':
        return 'المبيعات والتسويق';
      case 'all orders':
        return 'كل الطلبات';
      case 'order statuses':
        return 'حالات الطلب';
      case 'coupons':
        return 'الكوبونات';
      case 'offers':
        return 'العروض';
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
      case 'add group':
        return 'إضافة مجموعة';
      case 'create group':
        return 'إنشاء مجموعة';
      case 'edit group':
        return 'تعديل المجموعة';
      case 'group created':
        return 'تم إنشاء المجموعة';
      case 'group updated':
        return 'تم تحديث المجموعة';
      case 'the customer group has been saved successfully.':
        return 'تم حفظ مجموعة العملاء بنجاح.';
      case 'save failed':
        return 'فشل الحفظ';
      case 'could not save the group. please try again.':
        return 'تعذر حفظ المجموعة. حاول مرة أخرى.';
      case 'delete group':
        return 'حذف المجموعة';
      case 'are you sure you want to delete':
        return 'هل أنت متأكد من حذف';
      case 'deleted':
        return 'تم الحذف';
      case 'group deleted successfully.':
        return 'تم حذف المجموعة بنجاح.';
      case 'delete failed':
        return 'فشل الحذف';
      case 'could not delete group.':
        return 'تعذر حذف المجموعة.';
      case 'group details':
        return 'تفاصيل المجموعة';
      case 'title (en)':
        return 'العنوان (إنجليزي)';
      case 'title (ar)':
        return 'العنوان (عربي)';
      case 'parent id':
        return 'رقم المجموعة الأم';
      case 'company id':
        return 'رقم الشركة';
      case 'search groups…':
        return 'البحث عن مجموعات…';
      case 'new customers will be assigned to this group by default':
        return 'سيتم تعيين العملاء الجدد لهذه المجموعة افتراضيًا';
      case 'clients reports':
        return 'تقارير العملاء';
      case 'client report':
        return 'تقرير العميل';
      case 'save':
        return 'حفظ';
      case 'date from':
        return 'من تاريخ';
      case 'date to':
        return 'إلى تاريخ';
      case 'select a client...':
        return 'اختر عميلاً...';
      case 'loading clients...':
        return 'جاري تحميل العملاء...';
      case 'client':
        return 'العميل';
      case 'report for':
        return 'تقرير عن';
      case 'total orders':
        return 'إجمالي الطلبات';
      case 'total spent':
        return 'إجمالي الإنفاق';
      case 'period orders':
        return 'طلبات الفترة';
      case 'period spent':
        return 'إنفاق الفترة';
      case 'addresses':
        return 'العناوين';
      case 'support':
        return 'الدعم الفني';
      case 'messages':
        return 'الرسائل';
      case 'loyalty':
        return 'نقاطي';
      case 'loyalty settings':
        return 'إعدادات نقاطي';
      case 'loyalty reports':
        return 'تقارير نقاطي';
      case 'loyalty program':
        return 'نقاطي';
      case 'manage loyalty points and rewards settings.':
        return 'إدارة إعدادات نقاطي.';
      case 'general settings':
        return 'الإعدادات العامة';
      case 'enable loyalty program':
        return 'تفعيل نقاطي';
      case 'allow customers to earn and redeem points.':
        return 'السماح للعملاء بكسب واستبدال النقاط.';
      case 'earn rate':
        return 'معدل الكسب';
      case 'points per currency unit':
        return 'نقاط لكل وحدة عملة';
      case 'point value':
        return 'قيمة النقطة';
      case 'monetary value per point':
        return 'القيمة المالية للنقطة';
      case 'usage rules':
        return 'قواعد الاستخدام';
      case 'max usage type':
        return 'نوع الحد الأقصى للاستخدام';
      case 'max usage value':
        return 'قيمة الحد الأقصى للاستخدام';
      case 'min invoice amount':
        return 'الحد الأدنى لقيمة الفاتورة';
      case 'min points to use':
        return 'الحد الأدنى لاستخدام النقاط';
      case 'expiry settings':
        return 'إعدادات الصلاحية';
      case 'expiry type':
        return 'نوع الصلاحية';
      case 'expiry value':
        return 'قيمة الصلاحية';
      case 'restrictions':
        return 'القيود';
      case 'customer types':
        return 'أنواع العملاء';
      case 'excluded product ids':
        return 'معرفات المنتجات المستثناة';
      case 'excluded category ids':
        return 'معرفات التصنيفات المستثناة';
      case 'comma-separated ids':
        return 'معرفات مفصولة بفواصل';
      case 'view loyalty program reports and analytics':
        return 'عرض تقارير وتحليلات نقاطي';
      case 'balances':
        return 'الأرصدة';
      case 'movement':
        return 'الحركة';
      case 'redemptions':
        return 'الاستخدام';
      case 'earned':
        return 'المكتسبة';
      case 'expired':
        return 'المنتهية';
      case 'top customers':
        return 'أفضل العملاء';
      case 'cost':
        return 'التكلفة';
      case 'settings':
        return 'الإعدادات';
      case 'configure storefront behavior, delivery, payments, and branding.':
      case 'configure storefront behavior, delivery, payments, and branding':
        return 'تهيئة سلوك المتجر والتوصيل والمدفوعات والهوية التجارية.';
      
      // Common table headers & labels
      case 'id':
        return 'المعرف';
      case 'name':
        return 'الاسم';
      case 'discount':
        return 'الخصم';
      case 'status':
        return 'الحالة';
      case 'description':
        return 'الوصف';
      case 'actions':
        return 'الإجراءات';
      case 'active':
        return 'نشط';
      case 'inactive':
        return 'غير نشط';

      // Products & Catalog Fields
      case 'products catalog':
        return 'كتالوج المنتجات';
      case 'add product':
        return 'إضافة منتج';
      case 'edit product':
        return 'تعديل المنتج';
      case 'delete product':
        return 'حذف المنتج';
      case 'product':
        return 'المنتج';
      case 'sku':
        return 'رمز SKU';
      case 'sale price':
        return 'سعر البيع';
      case 'search by name or code…':
        return 'البحث بالاسم أو الكود...';
      case 'search categories by name or code…':
        return 'البحث في التصنيفات بالاسم أو الكود...';
      case 'search by name or code':
        return 'البحث بالاسم أو الكود...';

      // Table Toolbar Controls & Exports
      case 'export csv':
        return 'تصدير CSV';
      case 'export pdf':
        return 'تصدير PDF';
      case 'export excel':
        return 'تصدير Excel';
      case 'export selected':
        return 'تصدير المحدد';
      case 'selected':
        return 'محدد';
      case 'rows':
        return 'الصفوف';
      case 'rows per page':
        return 'عدد الصفوف في الصفحة';
      case 'showing':
        return 'عرض';
      case 'of':
        return 'من';
      case 'page':
        return 'صفحة';
      case 'prev':
        return 'السابق';
      case 'next':
        return 'التالي';
      case 'no rows':
        return 'لا توجد صفوف';
      case 'clear':
        return 'مسح';
      case 'search':
        return 'بحث';
      case 'no data found':
        return 'لم يتم العثور على بيانات';
      case 'there are no records to display yet.':
        return 'لا توجد سجلات لعرضها بعد.';

      // Offer Fields and Labels
      case 'add offer':
        return 'إضافة عرض';
      case 'create offer':
        return 'إنشاء عرض';
      case 'edit offer':
        return 'تعديل العرض';
      case 'delete offer':
        return 'حذف العرض';
      case 'offer details':
        return 'تفاصيل العرض';
      case 'name (en)':
        return 'الاسم (EN)';
      case 'name (ar)':
        return 'الاسم (AR)';
      case 'description (en)':
        return 'الوصف (EN)';
      case 'description (ar)':
        return 'الوصف (AR)';
      case 'discount type':
        return 'نوع الخصم';
      case 'discount value':
        return 'قيمة الخصم';
      case 'start date':
        return 'تاريخ البدء';
      case 'end date':
        return 'تاريخ الانتهاء';
      case 'cancel':
        return 'إلغاء';
      case 'save':
        return 'حفظ';
      case 'add new':
        return 'إضافة جديد';
      case 'search offers by name…':
        return 'البحث عن العروض بالاسم...';
      case 'save changes':
        return 'حفظ التغييرات';
      case 'offer created':
        return 'تم إنشاء العرض';
      case 'offer updated':
        return 'تم تحديث العرض';
      case 'the offer has been saved successfully.':
        return 'تم حفظ العرض بنجاح.';
      case 'save failed':
        return 'فشل الحفظ';
      case 'could not save the offer. please try again.':
        return 'تعذر حفظ العرض. حاول مرة أخرى.';
      case 'are you sure you want to delete offer':
        return 'هل أنت متأكد من حذف العرض';
      case 'deleted':
        return 'تم الحذف';
      case 'offer deleted successfully.':
        return 'تم حذف العرض بنجاح.';
      case 'delete failed':
        return 'فشل الحذف';
      case 'could not delete offer. please try again.':
        return 'تعذر حذف العرض. حاول مرة أخرى.';
      case 'offer image':
        return 'صورة العرض';
      case 'delete':
        return 'حذف';
      case 'is active':
        return 'نشط';
      case 'change':
        return 'تغيير';
      case 'select products':
        return 'اختيار منتجات';
      case 'failed to load products':
        return 'فشل تحميل المنتجات';
      case 'search products...':
        return 'البحث عن المنتجات...';
      case 'no products assigned':
        return 'لا توجد منتجات مخصصة';
      case 'failed to load details':
        return 'فشل تحميل التفاصيل';
      case 'percentage':
        return 'نسبة مئوية';
      case 'fixed':
        return 'قيمة ثابتة';
      case 'fixed amount':
        return 'قيمة ثابتة';
      case 'offer name in english':
        return 'اسم العرض بالإنجليزية';
      case 'offer description in english':
        return 'وصف العرض بالإنجليزية';
      case 'off':
        return 'خصم';
      case 'add':
        return 'إضافة';
      case 'percentage %':
        return 'نسبة مئوية %';
      case 'add group':
        return 'إضافة مجموعة';
      case 'create group':
        return 'إنشاء مجموعة';
      case 'edit group':
        return 'تعديل المجموعة';
      case 'delete group':
        return 'حذف المجموعة';
      case 'group details':
        return 'تفاصيل المجموعة';
      case 'title (en)':
        return 'العنوان (EN)';
      case 'title (ar)':
        return 'العنوان (AR)';
      case 'parent group':
        return 'المجموعة الأم';
      case 'default group':
        return 'المجموعة الافتراضية';
      case 'new customers will be assigned to this group by default':
        return 'سيتم تعيين العملاء الجدد لهذه المجموعة بشكل افتراضي';
      case 'e.g. vip customers':
        return 'مثال: عملاء VIP';
      case 'required':
        return 'مطلوب';
      case 'none':
        return 'لا يوجد';
      case 'group created':
        return 'تم إنشاء المجموعة';
      case 'group updated':
        return 'تم تحديث المجموعة';
      case 'the customer group has been saved successfully.':
        return 'تم حفظ مجموعة العملاء بنجاح.';
      case 'group deleted successfully.':
        return 'تم حذف المجموعة بنجاح.';
      case 'could not delete group.':
        return 'تعذر حذف المجموعة.';
      case 'are you sure you want to delete':
        return 'هل أنت متأكد من حذف';
      case 'failed to load groups':
        return 'فشل تحميل المجموعات';
      case 'search groups...':
        return 'البحث عن المجموعات...';
      case 'parent id':
        return 'المجموعة الأم';
      case 'company id':
        return 'معرف الشركة';
      case 'default':
        return 'افتراضي';
      case 'created at':
        return 'تاريخ الإنشاء';
      case 'yes':
        return 'نعم';
      case 'no':
        return 'لا';
      case 'total clients':
        return 'إجمالي العملاء';
      case 'active clients':
        return 'العملاء النشطون';
      case 'new this month':
        return 'جدد هذا الشهر';
      case 'avg. revenue/client':
        return 'متوسط الإيرادات/العميل';
      case 'customer growth (last 6 months)':
        return 'نمو العملاء (آخر 6 أشهر)';
      case 'customer segments':
        return 'شرائح العملاء';
      case 'clients':
        return 'العملاء';
      case 'report':
        return 'تقرير';
      case 'no data':
        return 'لا توجد بيانات';
      case 'search clients...':
        return 'البحث عن العملاء...';
      case 'top clients by orders':
        return 'أفضل العملاء حسب الطلبات';
      case 'top clients by spending':
        return 'أفضل العملاء حسب الإنفاق';
      case 'vip':
        return 'VIP';
      case 'loyal':
        return 'مخلصون';
      case 'regular':
        return 'عاديون';
      case 'new':
        return 'جدد';
      case 'top spenders':
        return 'أكبر المنفقين';
      case 'client name':
        return 'اسم العميل';
      case 'total orders':
        return 'إجمالي الطلبات';
      case 'total spent':
        return 'إجمالي الإنفاق';
      case 'last order':
        return 'آخر طلب';
      case 'mobile number':
        return 'رقم الجوال';
      case 'address details':
        return 'تفاصيل العنوان';
      case 'code':
        return 'الكود';
      case 'notes':
        return 'ملاحظات';
      case 'governorate':
        return 'المحافظة';
      case 'select governorate':
        return 'اختر المحافظة';
      case 'city':
        return 'المدينة';
      case 'select city':
        return 'اختر المدينة';
      case 'latitude':
        return 'خط العرض';
      case 'longitude':
        return 'خط الطول';
      case 'set as default':
        return 'تعيين كافتراضي';
      case 'add address':
        return 'إضافة عنوان';
      case 'edit address':
        return 'تعديل العنوان';
      case 'manage addresses':
        return 'إدارة العناوين';
      case 'please select a customer to view and manage addresses.':
        return 'يرجى اختيار عميل لعرض وإدارة العناوين.';
      case 'select a customer':
        return 'اختر عميلاً';
      case 'no mobile':
        return 'لا يوجد جوال';
      case 'no addresses found for this customer.':
        return 'لا توجد عناوين لهذا العميل.';
      case 'address saved successfully':
        return 'تم حفظ العنوان بنجاح';
      case 'address deleted successfully':
        return 'تم حذف العنوان بنجاح';
      case 'success':
        return 'نجاح';
      case 'new address':
        return 'عنوان جديد';
      case 'details':
        return 'التفاصيل';
      case 'failed':
        return 'فشل';
      case 'created successfully':
        return 'تم الإنشاء بنجاح';
      case 'location':
        return 'الموقع';
      case 'mobile':
        return 'الجوال';
      case 'e.g. home, office':
        return 'مثال: المنزل، المكتب';
      case '966500000000':
        return '966500000000';
      case 'block 1, street 2...':
        return 'القطعة 1، الشارع 2...';
      case 'e.g. hom-01':
        return 'مثال: HOM-01';
      case 'any additional notes...':
        return 'أي ملاحظات إضافية...';
      case 'client reports':
        return 'تقارير العملاء';
      // Dashboard Stats mapping
      case 'today revenue':
        return 'إيرادات اليوم';
      case 'today orders':
        return 'طلبات اليوم';
      case 'total revenue':
        return 'إجمالي الإيرادات';
      case 'total customers':
        return 'إجمالي العملاء';


      // Charts and Dashboard titles mapping
      // === Cities ===
      case 'cities & regions':
        return 'المدن والمناطق';
      case 'add city':
        return 'إضافة مدينة';
      case 'create city':
        return 'إنشاء مدينة';
      case 'edit city':
        return 'تعديل المدينة';
      case 'city created successfully':
        return 'تم إنشاء المدينة بنجاح';
      case 'city updated successfully':
        return 'تم تحديث المدينة بنجاح';
      case 'failed to save city':
        return 'فشل حفظ المدينة';
      case 'city deleted successfully':
        return 'تم حذف المدينة بنجاح';
      case 'failed to delete city':
        return 'فشل حذف المدينة';
      case 'delete city':
        return 'حذف المدينة';
      case 'are you sure you want to delete this city?':
        return 'هل أنت متأكد من حذف هذه المدينة؟';
      case 'unknown governorate':
        return 'محافظة غير معروفة';
      case 'delivery fee':
        return 'رسوم التوصيل';
      case 'delivery fee:':
        return 'رسوم التوصيل:';
      case 'search cities…':
        return 'البحث عن المدن...';
      case 'fee':
        return 'الرسوم';
      case 'city details':
        return 'تفاصيل المدينة';
      case 'city name (en)':
        return 'اسم المدينة (EN)';
      case 'city name (ar)':
        return 'اسم المدينة (AR)';
      case 'e.g. hawalli':
        return 'مثال: حولي';
      case 'e.g. cai':
        return 'مثال: CAI';
      case 'please select a governorate':
        return 'يرجى اختيار محافظة';
      case 'n/a':
        return 'غير متوفر';

      // === Sliders ===
      case 'homepage sliders':
        return 'البانرات الرئيسية';
      case 'add slider':
        return 'إضافة بانر';
      case 'create slider':
        return 'إنشاء بانر';
      case 'edit slider':
        return 'تعديل البانر';
      case 'slider created':
        return 'تم إنشاء البانر';
      case 'slider updated':
        return 'تم تحديث البانر';
      case 'the slider has been saved successfully.':
        return 'تم حفظ البانر بنجاح.';
      case 'could not save the slider. please try again.':
        return 'تعذر حفظ البانر. حاول مرة أخرى.';
      case 'delete slider':
        return 'حذف البانر';
      case 'slider deleted successfully.':
        return 'تم حذف البانر بنجاح.';
      case 'could not delete slider.':
        return 'تعذر حذف البانر.';
      case 'no arabic title':
        return 'لا يوجد عنوان عربي';
      case 'disabled':
        return 'معطل';
      case 'search sliders…':
        return 'البحث عن البانرات...';
      case 'image':
        return 'الصورة';
      case 'pos':
        return 'الترتيب';
      case 'slider details':
        return 'تفاصيل البانر';
      case 'position':
        return 'الترتيب';
      case 'content (en)':
        return 'المحتوى (EN)';
      case 'content (ar)':
        return 'المحتوى (AR)';
      case 'image saved on server':
        return 'الصورة محفوظة على الخادم';
      case 'e.g. summer sale':
        return 'مثال: تخفيضات الصيف';
      case 'slider image':
        return 'صورة البانر';
      case 'display this slider on the screen':
        return 'عرض هذا البانر على الشاشة';

      // === Pages ===
      case 'content pages':
        return 'صفحات المحتوى';
      case 'add page':
        return 'إضافة صفحة';
      case 'create page':
        return 'إنشاء صفحة';
      case 'edit page':
        return 'تعديل الصفحة';
      case 'page created':
        return 'تم إنشاء الصفحة';
      case 'page updated':
        return 'تم تحديث الصفحة';
      case 'the page has been saved successfully.':
        return 'تم حفظ الصفحة بنجاح.';
      case 'could not save the page. please try again.':
        return 'تعذر حفظ الصفحة. حاول مرة أخرى.';
      case 'delete page':
        return 'حذف الصفحة';
      case 'page deleted successfully.':
        return 'تم حذف الصفحة بنجاح.';
      case 'could not delete page.':
        return 'تعذر حذف الصفحة.';
      case 'search pages…':
        return 'البحث عن الصفحات...';
      case 'slug':
        return 'الرابط المختصر';
      case 'page details':
        return 'تفاصيل الصفحة';
      case 'published':
        return 'منشور';
      case 'draft':
        return 'مسودة';
      case 'page title (en)':
        return 'عنوان الصفحة (EN)';
      case 'page title (ar)':
        return 'عنوان الصفحة (AR)';
      case 'slug (url)':
        return 'الرابط المختصر (URL)';
      case 'e.g. terms & conditions':
        return 'مثال: الشروط والأحكام';
      case 'e.g. terms-and-conditions':
        return 'مثال: terms-and-conditions';
      case 'page content (en)':
        return 'محتوى الصفحة (EN)';
      case 'page content (ar)':
        return 'محتوى الصفحة (AR)';
      case 'enter page content in english...':
        return 'أدخل محتوى الصفحة بالإنجليزية...';
      case 'featured image':
        return 'الصورة المميزة';
      case 'make this page visible to customers':
        return 'اجعل هذه الصفحة مرئية للعملاء';

      // === Warehouses ===
      case 'inventory warehouses':
        return 'المستودعات';
      case 'add warehouse':
        return 'إضافة مستودع';
      case 'create warehouse':
        return 'إنشاء مستودع';
      case 'edit warehouse':
        return 'تعديل المستودع';
      case 'warehouse created':
        return 'تم إنشاء المستودع';
      case 'warehouse updated':
        return 'تم تحديث المستودع';
      case 'the warehouse has been saved successfully.':
        return 'تم حفظ المستودع بنجاح.';
      case 'could not save the warehouse. please try again.':
        return 'تعذر حفظ المستودع. حاول مرة أخرى.';
      case 'delete warehouse':
        return 'حذف المستودع';
      case 'warehouse deleted successfully.':
        return 'تم حذف المستودع بنجاح.';
      case 'warehouse details':
        return 'تفاصيل المستودع';
      case 'warehouse name':
        return 'اسم المستودع';
      case 'warehouse name (arabic)':
        return 'اسم المستودع (عربي)';
      case 'name is required':
        return 'الاسم مطلوب';
      case 'e.g. main warehouse':
        return 'مثال: المستودع الرئيسي';
      case 'e.g. wh-001':
        return 'مثال: WH-001';
      case 'branch':
        return 'الفرع';
      case 'loading branches...':
        return 'جاري تحميل الفروع...';
      case 'select branch':
        return 'اختر الفرع';
      case 'address':
        return 'العنوان';
      case 'warehouse address':
        return 'عنوان المستودع';
      case 'phone':
        return 'الهاتف';
      case 'e.g. 01000000000':
        return 'مثال: 01000000000';
      case 'parent warehouse':
        return 'المستودع الأم';
      case 'none (لا يوجد)':
        return 'لا يوجد';
      case 'update active status for this warehouse':
        return 'تحديث حالة التفعيل لهذا المستودع';
      case 'set initial active status':
        return 'تعيين حالة التفعيل الأولية';
      case 'warehouse notes':
        return 'ملاحظات المستودع';
      case 'search warehouses…':
        return 'البحث عن المستودعات...';

      // === Contacts ===
      case 'customer messages':
        return 'رسائل العملاء';
      case 'manage inquiries and support requests from your store':
        return 'إدارة الاستفسارات وطلبات الدعم من متجرك';
      case 'refresh':
        return 'تحديث';
      case 'no messages found':
        return 'لا توجد رسائل';
      case 'now':
        return 'الآن';
      case 'message content':
        return 'محتوى الرسالة';
      case 'close reader':
        return 'إغلاق القارئ';
      case 'are you sure?':
        return 'هل أنت متأكد؟';
      case 'this message will be permanently removed. this action cannot be undone.':
        return 'سيتم حذف هذه الرسالة بشكل دائم. لا يمكن التراجع عن هذا الإجراء.';
      case 'delete now':
        return 'حذف الآن';

      // === Users ===
      case 'user':
        return 'المستخدم';
      case 'search users...':
        return 'البحث عن المستخدمين...';
      case 'orders':
        return 'الطلبات';
      case 'joined':
        return 'تاريخ الانضمام';
      case 'user details':
        return 'تفاصيل المستخدم';
      case 'full name':
        return 'الاسم الكامل';
      case 'email address':
        return 'البريد الإلكتروني';
      case 'no email provided':
        return 'لا يوجد بريد إلكتروني';
      case 'joined on':
        return 'انضم في';
      case 'enter user name':
        return 'أدخل اسم المستخدم';
      case 'add user':
        return 'إضافة مستخدم';

      // === Ads ===
      case 'advertisements':
        return 'الإعلانات';
      case 'add ad':
        return 'إضافة إعلان';
      case 'create new ad':
        return 'إنشاء إعلان جديد';
      case 'edit ad':
        return 'تعديل الإعلان';
      case 'ad created':
        return 'تم إنشاء الإعلان';
      case 'ad updated':
        return 'تم تحديث الإعلان';
      case 'the advertisement has been saved successfully.':
        return 'تم حفظ الإعلان بنجاح.';
      case 'could not save the advertisement. please try again.':
        return 'تعذر حفظ الإعلان. حاول مرة أخرى.';
      case 'delete advertisement':
        return 'حذف الإعلان';
      case 'advertisement deleted successfully.':
        return 'تم حذف الإعلان بنجاح.';
      case 'could not delete advertisement.':
        return 'تعذر حذف الإعلان.';
      case 'location:':
        return 'الموقع:';
      case 'global':
        return 'عالمي';
      case 'search advertisements…':
        return 'البحث عن الإعلانات...';
      case 'advertisement details':
        return 'تفاصيل الإعلان';
      case 'target url':
        return 'رابط الهدف';
      case 'category link id':
        return 'معرف رابط التصنيف';
      case 'link url':
        return 'رابط URL';
      case 'ad image':
        return 'صورة الإعلان';
      case 'hide or show this ad on the storefront':
        return 'إخفاء أو عرض هذا الإعلان في المتجر';
      case 'create ad':
        return 'إنشاء إعلان';
      case 'e.g. special offer':
        return 'مثال: عرض خاص';
      case 'category link':
        return 'رابط التصنيف';
      case 'select category (optional)':
        return 'اختر التصنيف (اختياري)';
      case 'error loading categories':
        return 'خطأ في تحميل التصنيفات';

      // === Boardings ===
      case 'onboarding screens':
        return 'شاشات الترحيب';
      case 'new screen':
        return 'شاشة جديدة';
      case 'create boarding':
        return 'إنشاء شاشة ترحيب';
      case 'edit boarding':
        return 'تعديل شاشة الترحيب';
      case 'boarding created':
        return 'تم إنشاء الشاشة';
      case 'boarding updated':
        return 'تم تحديث الشاشة';
      case 'the onboarding screen has been saved successfully.':
        return 'تم حفظ شاشة الترحيب بنجاح.';
      case 'could not save the onboarding screen. please try again.':
        return 'تعذر حفظ شاشة الترحيب. حاول مرة أخرى.';
      case 'delete onboarding screen':
        return 'حذف شاشة الترحيب';
      case 'onboarding screen deleted successfully.':
        return 'تم حذف شاشة الترحيب بنجاح.';
      case 'could not delete onboarding screen.':
        return 'تعذر حذف شاشة الترحيب.';
      case 'search boardings…':
        return 'البحث عن شاشات الترحيب...';
      case 'onboarding screen details':
        return 'تفاصيل شاشة الترحيب';
      case 'onboarding image':
        return 'صورة الترحيب';
      case 'e.g. welcome':
        return 'مثال: مرحبا';

      // === Properties ===
      case 'product properties':
        return 'خصائص المنتج';
      case 'add property':
        return 'إضافة خاصية';
      case 'create property':
        return 'إنشاء خاصية';
      case 'edit property':
        return 'تعديل الخاصية';
      case 'property created':
        return 'تم إنشاء الخاصية';
      case 'property updated':
        return 'تم تحديث الخاصية';
      case 'the property has been saved successfully.':
        return 'تم حفظ الخاصية بنجاح.';
      case 'could not save the property. please try again.':
        return 'تعذر حفظ الخاصية. حاول مرة أخرى.';
      case 'delete property':
        return 'حذف الخاصية';
      case 'property deleted successfully.':
        return 'تم حذف الخاصية بنجاح.';
      case 'could not delete property.':
        return 'تعذر حذف الخاصية.';
      case 'search properties…':
        return 'البحث عن الخصائص...';
      case 'default:':
        return 'افتراضي:';
      case 'property details':
        return 'تفاصيل الخاصية';
      case 'property url':
        return 'رابط الخاصية';
      case 'parent property':
        return 'الخاصية الأم';
      case 'default property':
        return 'خاصية افتراضية';
      case 'mark this as a default property for new products':
        return 'وضع هذه الخاصية كافتراضية للمنتجات الجديدة';
      case 'e.g. color':
        return 'مثال: اللون';
      case 'property url (optional)':
        return 'رابط الخاصية (اختياري)';
      case 'e.g. colors-selector':
        return 'مثال: colors-selector';
      case 'failed to load properties':
        return 'فشل تحميل الخصائص';

      // === Order Statuses ===
      case 'add status':
        return 'إضافة حالة';
      case 'create status':
        return 'إنشاء حالة';
      case 'edit status':
        return 'تعديل الحالة';
      case 'status created':
        return 'تم إنشاء الحالة';
      case 'status updated':
        return 'تم تحديث الحالة';
      case 'the order status has been saved successfully.':
        return 'تم حفظ حالة الطلب بنجاح.';
      case 'could not save the order status. please try again.':
        return 'تعذر حفظ حالة الطلب. حاول مرة أخرى.';
      case 'delete status':
        return 'حذف الحالة';
      case 'status deleted successfully.':
        return 'تم حذف الحالة بنجاح.';
      case 'could not delete status.':
        return 'تعذر حذف الحالة.';
      case 'search statuses…':
        return 'البحث عن الحالات...';
      case 'color':
        return 'اللون';
      case 'color indicator':
        return 'مؤشر اللون';
      case 'sort order':
        return 'ترتيب الفرز';
      case 'order':
        return 'ترتيب';
      case 'order #':
        return 'طلب رقم';
      case 'default status':
        return 'حالة افتراضية';
      case 'new orders will start with this status':
        return 'الطلبات الجديدة ستبدأ بهذه الحالة';
      case 'status details':
        return 'تفاصيل الحالة';
      case 'status name (en)':
        return 'اسم الحالة (EN)';
      case 'status name (ar)':
        return 'اسم الحالة (AR)';
      case 'e.g. processing':
        return 'مثال: قيد التجهيز';
      case 'color (hex)':
        return 'اللون (Hex)';

      // === Payment Methods ===
      case 'payment gateways':
        return 'بوابات الدفع';
      case 'add method':
        return 'إضافة طريقة';
      case 'create method':
        return 'إنشاء طريقة';
      case 'edit method':
        return 'تعديل الطريقة';
      case 'method created':
        return 'تم إنشاء الطريقة';
      case 'method updated':
        return 'تم تحديث الطريقة';
      case 'the payment method has been saved successfully.':
        return 'تم حفظ طريقة الدفع بنجاح.';
      case 'could not save the payment method. please try again.':
        return 'تعذر حفظ طريقة الدفع. حاول مرة أخرى.';
      case 'delete payment method':
        return 'حذف طريقة الدفع';
      case 'payment method deleted successfully.':
        return 'تم حذف طريقة الدفع بنجاح.';
      case 'could not delete payment method.':
        return 'تعذر حذف طريقة الدفع.';
      case 'search payment methods…':
        return 'البحث عن طرق الدفع...';
      case 'icon':
        return 'الأيقونة';
      case 'arabic name':
        return 'الاسم العربي';
      case 'name (english)':
        return 'الاسم (إنجليزي)';
      case 'name (arabic)':
        return 'الاسم (عربي)';
      case 'note (english)':
        return 'ملاحظة (إنجليزي)';
      case 'note (arabic)':
        return 'ملاحظة (عربي)';
      case 'e.g. credit card':
        return 'مثال: بطاقة ائتمان';
      case 'e.g. additional fees apply':
        return 'مثال: تطبق رسوم إضافية';
      case 'type':
        return 'النوع';
      case 'select type':
        return 'اختر النوع';
      case 'error loading types':
        return 'خطأ في تحميل الأنواع';
      case 'method icon':
        return 'أيقونة الطريقة';
      case 'payment method details':
        return 'تفاصيل طريقة الدفع';
      case 'note (en)':
        return 'ملاحظة (EN)';
      case 'note (ar)':
        return 'ملاحظة (AR)';
      case 'no notes':
        return 'لا توجد ملاحظات';

      // === Coupons ===
      case 'discount coupons':
        return 'كوبونات الخصم';
      case 'add coupon':
        return 'إضافة كوبون';
      case 'create coupon':
        return 'إنشاء كوبون';
      case 'edit coupon':
        return 'تعديل الكوبون';
      case 'coupon created':
        return 'تم إنشاء الكوبون';
      case 'coupon updated':
        return 'تم تحديث الكوبون';
      case 'the coupon has been saved successfully.':
        return 'تم حفظ الكوبون بنجاح.';
      case 'could not save the coupon. please try again.':
        return 'تعذر حفظ الكوبون. حاول مرة أخرى.';
      case 'delete coupon':
        return 'حذف الكوبون';
      case 'are you sure you want to delete coupon':
        return 'هل أنت متأكد من حذف الكوبون';
      case 'coupon deleted successfully.':
        return 'تم حذف الكوبون بنجاح.';
      case 'could not delete coupon. please try again.':
        return 'تعذر حذف الكوبون. حاول مرة أخرى.';
      case 'search coupons by code…':
        return 'البحث عن الكوبونات بالرمز...';
      case 'coupon details':
        return 'تفاصيل الكوبون';
      case 'coupon code':
        return 'رمز الكوبون';

      case 'minimum order value':
        return 'الحد الأدنى للطلب';
      case 'max uses':
        return 'الحد الأقصى للاستخدام';
      case 'max uses per customer':
        return 'الحد الأقصى لكل عميل';
      case 'starts at':
        return 'يبدأ في';
      case 'expires at':
        return 'ينتهي في';
      case 'coupon image':
        return 'صورة الكوبون';
      case 'e.g. save20':
        return 'مثال: SAVE20';
      case 'per customer':
        return 'لكل عميل';
      case 'min order':
        return 'الحد الأدنى للطلب';

      // === Countries ===
      case 'add country':
        return 'إضافة دولة';
      case 'create country':
        return 'إنشاء دولة';
      case 'edit country':
        return 'تعديل الدولة';
      case 'country created successfully':
        return 'تم إنشاء الدولة بنجاح';
      case 'country updated successfully':
        return 'تم تحديث الدولة بنجاح';
      case 'failed to save country':
        return 'فشل حفظ الدولة';
      case 'country deleted successfully':
        return 'تم حذف الدولة بنجاح';
      case 'failed to delete country':
        return 'فشل حذف الدولة';
      case 'search countries...':
        return 'البحث عن الدول...';
      case 'country details':
        return 'تفاصيل الدولة';

      case 'country code':
        return 'رمز الدولة';
      case 'phone code':
        return 'رمز الهاتف';
      case 'e.g. egypt':
        return 'مثال: مصر';
      case 'e.g. eg':
        return 'مثال: EG';
      case 'e.g. +20':
        return 'مثال: 20+';
      case 'iso code':
        return 'رمز ISO';

      // === Governorates ===
      case 'add gov':
        return 'إضافة محافظة';
      case 'create governorate':
        return 'إنشاء محافظة';
      case 'edit governorate':
        return 'تعديل المحافظة';
      case 'governorate created successfully':
        return 'تم إنشاء المحافظة بنجاح';
      case 'governorate updated successfully':
        return 'تم تحديث المحافظة بنجاح';
      case 'failed to save governorate':
        return 'فشل حفظ المحافظة';
      case 'delete governorate':
        return 'حذف المحافظة';
      case 'are you sure you want to delete this governorate?':
        return 'هل أنت متأكد من حذف هذه المحافظة؟';
      case 'governorate deleted successfully':
        return 'تم حذف المحافظة بنجاح';
      case 'failed to delete governorate':
        return 'فشل حذف المحافظة';
      case 'search governorates…':
        return 'البحث عن المحافظات...';
      case 'governorate details':
        return 'تفاصيل المحافظة';
      case 'governorate name (en)':
        return 'اسم المحافظة (الإنجليزية)';
      case 'governorate name (ar)':
        return 'اسم المحافظة (العربية)';
      case 'e.g. cairo':
        return 'مثال: القاهرة';
      case 'no arabic name':
        return 'لا يوجد اسم عربي';
      case 'select country':
        return 'اختر الدولة';
      case 'please select a country':
        return 'يرجى اختيار دولة';

      // === Branches ===
      case 'business branches':
        return 'فروع الشركة';
      case 'add branch':
        return 'إضافة فرع';
      case 'create branch':
        return 'إنشاء فرع';
      case 'edit branch':
        return 'تعديل الفرع';
      case 'branch created':
        return 'تم إنشاء الفرع';
      case 'branch updated':
        return 'تم تحديث الفرع';
      case 'the branch has been saved successfully.':
        return 'تم حفظ الفرع بنجاح.';
      case 'an error occurred while saving the branch.':
        return 'حدث خطأ أثناء حفظ الفرع.';
      case 'delete branch':
        return 'حذف الفرع';
      case 'are you sure you want to delete branch':
        return 'هل أنت متأكد من حذف الفرع';
      case 'branch deleted successfully.':
        return 'تم حذف الفرع بنجاح.';
      case 'could not delete the branch. please try again.':
        return 'تعذر حذف الفرع. حاول مرة أخرى.';
      case 'search branches…':
        return 'البحث عن الفروع...';
      case 'branch details':
        return 'تفاصيل الفرع';
      case 'branch name':
        return 'اسم الفرع';
      case 'branch name (arabic)':
        return 'اسم الفرع (العربية)';
      case 'e.g. main branch':
        return 'مثال: الفرع الرئيسي';
      case 'e.g. br-01':
        return 'مثال: BR-01';
      case 'email':
        return 'البريد الإلكتروني';
      case 'e.g. branch@example.com':
        return 'مثال: branch@example.com';
      case 'enter a valid email':
        return 'أدخل بريداً إلكترونياً صحيحاً';
      case 'address (english)':
        return 'العنوان (الإنجليزية)';
      case 'address (arabic)':
        return 'العنوان (العربية)';
      case 'e.g. kuwait city':
        return 'مثال: مدينة الكويت';
      case 'description (arabic)':
        return 'الوصف (العربية)';
      case 'visible to users':
        return 'مرئي للمستخدمين';
      case 'primary location':
        return 'الموقع الرئيسي';
      case 'main branch':
        return 'الفرع الرئيسي';
      case 'standard branch':
        return 'فرع عادي';
      case 'open':
        return 'مفتوح';
      case 'closed':
        return 'مغلق';

      // === Payment Statuses ===
      case 'transaction statuses':
        return 'حالات المعاملات';
      case 'create payment status':
        return 'إنشاء حالة دفع';
      case 'edit payment status':
        return 'تعديل حالة الدفع';
      case 'payment status created':
        return 'تم إنشاء حالة الدفع';
      case 'payment status updated':
        return 'تم تحديث حالة الدفع';
      case 'the payment status has been saved successfully.':
        return 'تم حفظ حالة الدفع بنجاح.';
      case 'could not save the payment status. please try again.':
        return 'تعذر حفظ حالة الدفع. حاول مرة أخرى.';
      case 'delete payment status':
        return 'حذف حالة الدفع';
      case 'payment status deleted successfully.':
        return 'تم حذف حالة الدفع بنجاح.';
      case 'could not delete payment status.':
        return 'تعذر حذف حالة الدفع.';
      case 'payment status details':
        return 'تفاصيل حالة الدفع';

      case 'e.g. paid, pending':
        return 'مثال: مدفوع، معلق';
      case 'enable or disable this payment status':
        return 'تفعيل أو تعطيل حالة الدفع هذه';

      // === Settings ===
      case 'saving...':
        return 'جاري الحفظ...';
      case 'brand identity':
        return 'هوية العلامة التجارية';
      case 'contact info':
        return 'معلومات الاتصال';
      case 'social media':
        return 'وسائل التواصل الاجتماعي';
      case 'logo':
        return 'الشعار';
      case 'logo (dark)':
        return 'الشعار (داكن)';
      case 'url or path':
        return 'رابط أو مسار';
      case 'store address in arabic':
        return 'عنوان المتجر بالعربية';
      case 'store address in english':
        return 'عنوان المتجر بالإنجليزية';
      case 'e.g. 96512345678':
        return 'مثال: 96512345678';
      case 'e.g. info@store.com':
        return 'مثال: info@store.com';
      case 'shipping value':
        return 'قيمة الشحن';
      case 'e.g. 2.500':
        return 'مثال: 2.500';
      case 'points egp rate':
        return 'سعر نقاط الجنيه';
      case 'e.g. 1.0':
        return 'مثال: 1.0';
      case 'url or username':
        return 'رابط أو اسم مستخدم';
      case 'these settings will affect the storefront checkout process and contact information immediately after saving.':
        return 'ستؤثر هذه الإعدادات على عملية الدفع في المتجر ومعلومات الاتصال فور الحفظ.';
      case 'changes saved!':
        return 'تم حفظ التغييرات!';
      case 'your store settings have been updated successfully.':
        return 'تم تحديث إعدادات متجرك بنجاح.';
      case 'update failed':
        return 'فشل التحديث';
      case 'try again':
        return 'حاول مرة أخرى';
      case 'done':
        return 'تم';

      case 'product performance insights':
        return 'تحليلات أداء المنتجات';
      case 'financial contribution (revenue share)':
        return 'المساهمة المالية (حصة الإيرادات)';
      case 'revenue performance (by product)':
        return 'أداء الإيرادات (حسب المنتج)';
      case 'sales':
        return 'المبيعات';
      case 'egp':
        return 'ج.م';
      case 'error:':
        return 'خطأ:';
      case 'months':
        return 'شهور';
      case 'weeks':
        return 'أسابيع';
      case 'inventory movement (last 6 months)':
        return 'حركة المخزون (آخر 6 أشهر)';
      case 'inventory movement (last 6 weeks)':
        return 'حركة المخزون (آخر 6 أسابيع)';

      // === Categories ===
      case 'add category':
        return 'إضافة تصنيف';
      case 'edit category':
        return 'تعديل التصنيف';
      case 'delete category':
        return 'حذف التصنيف';
      case 'category added':
        return 'تمت إضافة التصنيف';
      case 'category updated':
        return 'تم تحديث التصنيف';
      case 'the category was saved successfully.':
        return 'تم حفظ التصنيف بنجاح.';
      case 'an error occurred while saving the category.':
        return 'حدث خطأ أثناء حفظ التصنيف.';
      case 'category deleted successfully.':
        return 'تم حذف التصنيف بنجاح.';
      case 'could not delete the category. please try again.':
        return 'تعذر حذف التصنيف. حاول مرة أخرى.';

      // === Products ===
      case 'product added':
        return 'تمت إضافة المنتج';
      case 'product updated':
        return 'تم تحديث المنتج';
      case 'the product has been saved successfully.':
        return 'تم حفظ المنتج بنجاح.';
      case 'an error occurred while saving the product.':
        return 'حدث خطأ أثناء حفظ المنتج.';
      case 'product deleted successfully.':
        return 'تم حذف المنتج بنجاح.';
      case 'could not delete the product. please try again.':
        return 'تعذر حذف المنتج. حاول مرة أخرى.';

      // === Companies ===
      case 'brands & companies':
        return 'العلامات التجارية والشركات';
      case 'add company':
        return 'إضافة شركة';
      case 'edit company':
        return 'تعديل الشركة';
      case 'company added':
        return 'تمت إضافة الشركة';
      case 'company updated':
        return 'تم تحديث الشركة';
      case 'the company has been saved successfully.':
        return 'تم حفظ الشركة بنجاح.';
      case 'failed to save company. please try again.':
        return 'فشل حفظ الشركة. حاول مرة أخرى.';
      case 'company details':
        return 'تفاصيل الشركة';
      case 'company deleted successfully.':
        return 'تم حذف الشركة بنجاح.';
      case 'could not delete company. please try again.':
        return 'تعذر حذف الشركة. حاول مرة أخرى.';
      case 'description (english)':
        return 'الوصف (الإنجليزية)';

      // === Filters / Tags ===
      case 'add tag':
        return 'إضافة علامة';
      case 'edit tag':
        return 'تعديل العلامة';
      case 'tag added':
        return 'تمت إضافة العلامة';
      case 'tag updated':
        return 'تم تحديث العلامة';
      case 'the tag has been saved successfully.':
        return 'تم حفظ العلامة بنجاح.';
      case 'failed to save tag. please try again.':
        return 'فشل حفظ العلامة. حاول مرة أخرى.';
      case 'tag details':
        return 'تفاصيل العلامة';
      case 'parent tag':
        return 'العلامة الأم';
      case 'delete tag':
        return 'حذف العلامة';
      case 'tag deleted successfully.':
        return 'تم حذف العلامة بنجاح.';
      case 'could not delete tag. please try again.':
        return 'تعذر حذف العلامة. حاول مرة أخرى.';

      // === Orders ===
      case 'customer orders':
        return 'طلبات العملاء';
      case 'filter by customer (optional)':
        return 'تصفية حسب العميل (اختياري)';
      case 'all customers':
        return 'جميع العملاء';
      case 'no orders found for this selection.':
        return 'لا توجد طلبات لهذا الاختيار.';
      case 'manage order':
        return 'إدارة الطلب';
      case 'new order':
        return 'طلب جديد';
      case 'please complete order information (customer, address, payment)':
        return 'يرجى إكمال معلومات الطلب (العميل، العنوان، الدفع)';
      case 'your cart is empty':
        return 'عربة التسوق فارغة';

      // === Prescriptions ===
      case 'prescription requests':
        return 'طلبات الروشتات';
      case 'review prescription':
        return 'مراجعة الروشتة';
      case 'review confirmed':
        return 'تم تأكيد المراجعة';
      case 'prescription has been updated.':
        return 'تم تحديث الروشتة.';
      case 'admin note':
        return 'ملاحظة المشرف';
      case 'confirm review':
        return 'تأكيد المراجعة';
      case 'add instructions or reason for rejection...':
        return 'أضف تعليمات أو سبب الرفض...';

      // === Shared ===
      case 'view details':
        return 'عرض التفاصيل';
      case 'view':
        return 'عرض';

      // === Table Columns ===
      case 'english name':
        return 'الاسم (الإنجليزية)';
      case 'search companies':
        return 'البحث عن الشركات...';
      case 'search tags':
        return 'البحث عن العلامات...';
      case 'search orders':
        return 'البحث عن الطلبات...';
      case 'product details':
        return 'تفاصيل المنتج';
      case 'category details':
        return 'تفاصيل التصنيف';
      case 'no image':
        return 'لا توجد صورة';

      // === Orders ===
      case 'customer':
        return 'العميل';
      case 'total':
        return 'الإجمالي';
      case 'coupon':
        return 'كوبون';
      case 'subtotal':
        return 'المجموع الفرعي';
      case 'shipping':
        return 'الشحن';
      case 'tax':
        return 'الضريبة';
      case 'order number':
        return 'رقم الطلب';
      case 'order timeline':
        return 'الجدول الزمني للطلب';
      case 'pricing':
        return 'التسعير';
      case 'qty':
        return 'الكمية';
      case 'select status':
        return 'اختر الحالة';
      case 'order is being prepared':
        return 'الطلب قيد التحضير';
      case 'order information':
        return 'معلومات الطلب';
      case 'select customer':
        return 'اختر العميل';
      case 'delivery address':
        return 'عنوان التوصيل';
      case 'select address':
        return 'اختر العنوان';
      case 'payment method':
        return 'طريقة الدفع';
      case 'select payment method':
        return 'اختر طريقة الدفع';
      case 'confirm order creation':
        return 'تأكيد إنشاء الطلب';
      case 'payment':
        return 'الدفع';
      case 'items':
        return 'العناصر';
      case 'created':
        return 'تاريخ الإنشاء';
      case 'block':
        return 'مجمع';
      case 'building':
        return 'مبنى';
      case 'floor':
        return 'طابق';
      case 'apartment':
        return 'شقة';
      case 'street':
        return 'شارع';
      case 'area':
        return 'منطقة';
      case 'order status':
        return 'حالة الطلب';
      case 'process order':
        return 'معالجة الطلب';
      case 'update status':
        return 'تحديث الحالة';
      case 'manage':
        return 'إدارة';
      case 'total:':
        return 'الإجمالي:';
      case 'all':
        return 'الكل';

      // === Prescriptions ===
      case 'unknown':
        return 'غير معروف';
      case 'reviewer':
        return 'المراجع';
      case 'date':
        return 'التاريخ';
      case 'prescription details':
        return 'تفاصيل الروشتة';
      case 'guest':
        return 'زائر';
      case 'customer mobile':
        return 'جوال العميل';
      case 'note / description':
        return 'ملاحظة / وصف';
      case 'no note provided':
        return 'لا توجد ملاحظة';
      case 'not reviewed':
        return 'لم تتم المراجعة';
      case 'submission date':
        return 'تاريخ التقديم';

      // === Form Fields ===
      case 'category name (english)':
        return 'اسم التصنيف (الإنجليزية)';
      case 'category name (arabic)':
        return 'اسم التصنيف (العربية)';
      case 'arabic name is required':
        return 'الاسم بالعربية مطلوب';
      case 'parent category':
        return 'التصنيف الأب';
      case 'category image':
        return 'صورة التصنيف';
      case 'has children':
        return 'لديه فروع';
      case 'allow subcategories under this category':
        return 'السماح بتصنيفات فرعية تحت هذا التصنيف';
      case 'company name (english)':
        return 'اسم الشركة (الإنجليزية)';
      case 'company name (arabic)':
        return 'اسم الشركة (العربية)';
      case 'company / manufacturer':
        return 'الشركة / المصنع';
      case 'select company':
        return 'اختر الشركة';
      case 'company logo':
        return 'شعار الشركة';
      case 'select category':
        return 'اختر التصنيف';
      case 'sku / barcode':
        return 'رمز SKU / الباركود';
      case 'purchase price':
        return 'سعر الشراء';
      case 'gallery images':
        return 'صور المعرض';
      case 'select tags':
        return 'اختر العلامات';
      case 'select properties':
        return 'اختر الخصائص';
      case 'error loading companies':
        return 'خطأ في تحميل الشركات';
      case 'error loading tags':
        return 'خطأ في تحميل العلامات';
      case 'error loading properties':
        return 'خطأ في تحميل الخصائص';
      case 'product image':
        return 'صورة المنتج';
      case 'category':
        return 'التصنيف';
      case 'company':
        return 'الشركة';
      case 'code:':
        return 'رمز:';
      case 'sku:':
        return 'رمز SKU:';

      case 'edit':
        return 'تعديل';
      case 'search groups…':
        return 'البحث عن المجموعات...';
      case 'title':
        return 'العنوان';
      case 'approved':
        return 'مقبول';
      case 'pending':
        return 'معلق';
      case 'rejected':
        return 'مرفوض';
      case 'country':
        return 'الدولة';
      case 'delete company':
        return 'حذف الشركة';
      case 'welcome to our store':
        return 'مرحباً بك في متجرنا';
      case 'could not save the group. please try again.':
        return 'تعذر حفظ المجموعة. يرجى المحاولة مرة أخرى.';
      case 'enter description in english':
        return 'أدخل الوصف بالإنجليزية';
      case 'enter description in arabic':
        return 'أدخل الوصف بالعربية';
      case 'e.g. pfizer':
        return 'مثال: فايزر';
      case 'e.g. pfizer (arabic)':
        return 'مثال: فايزر';
      case 'e.g. elec':
        return 'مثال: elec';
      case 'e.g. electronics':
        return 'مثال: الإلكترونيات';
      case 'e.g. featured':
        return 'مثال: مميز';
      case 'e.g. featured (arabic)':
        return 'مثال: مميز';
      case 'e.g. items related to consumer electronics':
        return 'مثال: الأجهزة والمعدات الإلكترونية الاستهلاكية';
      case 'e.g. consumer electronics (arabic)':
        return 'مثال: الأجهزة والمعدات الإلكترونية الاستهلاكية';
      case 'e.g. sku-12345':
        return 'مثال: sku-12345';
      case 'product name in arabic':
        return 'اسم المنتج بالعربي';
      case 'product name in english':
        return 'اسم المنتج بالإنجليزية';
      case 'product description in arabic...':
        return 'وصف المنتج بالعربي...';
      case 'product description in english...':
        return 'وصف المنتج بالإنجليزية...';
      case 'jan':
        return 'يناير';
      case 'feb':
        return 'فبراير';
      case 'mar':
        return 'مارس';
      case 'apr':
        return 'أبريل';
      case 'may':
        return 'مايو';
      case 'jun':
        return 'يونيو';

      default:
        return text;
    }
  }

  static String translateStatus(BuildContext context, String statusName) {
    const statuses = <String, String>{
      'pending': 'قيد الانتظار',
      'قيد الانتظار': 'pending',
      'processing': 'قيد المعالجة',
      'قيد المعالجة': 'processing',
      'shipped': 'تم الشحن',
      'تم الشحن': 'shipped',
      'delivered': 'تم التوصيل',
      'تم التوصيل': 'delivered',
      'completed': 'مكتمل',
      'مكتمل': 'completed',
      'cancelled': 'ملغي',
      'ملغي': 'cancelled',
      'refunded': 'تم الاسترجاع',
      'تم الاسترجاع': 'refunded',
      'on hold': 'معلق',
      'معلق': 'on hold',
    };
    final trimmed = statusName.trim().toLowerCase();
    return statuses[trimmed] ?? statusName;
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
