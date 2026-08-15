import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/review_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/tag_model.dart';
import 'package:erp/modules/webstore/cart/data/models/cart_model.dart';
import 'package:erp/modules/webstore/cart/data/models/cart_item_model.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_auth_response.dart';
import 'package:erp/modules/webstore/home/data/models/slider_model.dart';
import 'package:erp/modules/webstore/home/data/models/ad_model.dart';
import 'package:erp/modules/webstore/home/data/models/coupon_model.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';
import 'package:erp/modules/webstore/home/data/models/store_settings_model.dart';
import 'package:erp/modules/webstore/checkout/data/models/payment_method_model.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'package:erp/modules/webstore/addresses/data/models/lookup_models.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';
import 'package:erp/modules/webstore/points/data/models/points_model.dart';
import 'package:erp/modules/webstore/onboarding/data/models/boarding_model.dart';
import 'package:erp/modules/webstore/pages/data/models/cms_page_model.dart';

class MockData {
  MockData._();

  static const String _placeholderImage = 'https://via.placeholder.com/400x300?text=Shoe';
  static const String _placeholderBanner = 'https://via.placeholder.com/1200x400?text=Banner';

  static final WebStoreUser mockUser = WebStoreUser(
    id: 1,
    name: 'عميل تجريبي',
    email: 'test@example.com',
    mobile: '01234567890',
    points: 1500,
    verifyPhone: true,
  );

  static final WebStoreAuthResponse mockAuthResponse = WebStoreAuthResponse(
    user: mockUser,
    token: 'mock_token_123456',
    message: 'تم تسجيل الدخول بنجاح',
  );

  static final List<WebStoreCategory> mockCategories = [
    WebStoreCategory(
      id: 1,
      name: 'حذاء رياضي',
      nameEn: 'Sports Shoes',
      nameAr: 'حذاء رياضي',
      image: _placeholderImage,
      productsCount: 45,
      isActive: true,
      children: [],
    ),
    WebStoreCategory(
      id: 2,
      name: 'حذاء كاجوال',
      nameEn: 'Casual Shoes',
      nameAr: 'حذاء كاجوال',
      image: _placeholderImage,
      productsCount: 32,
      isActive: true,
      children: [],
    ),
    WebStoreCategory(
      id: 3,
      name: 'حذاء رسمي',
      nameEn: 'Formal Shoes',
      nameAr: 'حذاء رسمي',
      image: _placeholderImage,
      productsCount: 28,
      isActive: true,
      children: [],
    ),
    WebStoreCategory(
      id: 4,
      name: 'صندل',
      nameEn: 'Sandals',
      nameAr: 'صندل',
      image: _placeholderImage,
      productsCount: 20,
      isActive: true,
      children: [],
    ),
    WebStoreCategory(
      id: 5,
      name: 'بوت',
      nameEn: 'Boots',
      nameAr: 'بوت',
      image: _placeholderImage,
      productsCount: 18,
      isActive: true,
      children: [],
    ),
    WebStoreCategory(
      id: 6,
      name: 'أحذية أطفال',
      nameEn: 'Kids Shoes',
      nameAr: 'أحذية أطفال',
      image: _placeholderImage,
      productsCount: 35,
      isActive: true,
      children: [],
    ),
  ];

  static final List<ManufacturerModel> mockManufacturers = [
    ManufacturerModel(
      id: 1,
      name: 'نايك',
      nameEn: 'Nike',
      nameAr: 'نايك',
      logo: _placeholderImage,
      isActive: true,
    ),
    ManufacturerModel(
      id: 2,
      name: 'أديداس',
      nameEn: 'Adidas',
      nameAr: 'أديداس',
      logo: _placeholderImage,
      isActive: true,
    ),
    ManufacturerModel(
      id: 3,
      name: 'بوما',
      nameEn: 'Puma',
      nameAr: 'بوما',
      logo: _placeholderImage,
      isActive: true,
    ),
    ManufacturerModel(
      id: 4,
      name: 'ريلون',
      nameEn: 'Reebok',
      nameAr: 'ريلون',
      logo: _placeholderImage,
      isActive: true,
    ),
    ManufacturerModel(
      id: 5,
      name: 'نيوبالانس',
      nameEn: 'New Balance',
      nameAr: 'نيوبالانس',
      logo: _placeholderImage,
      isActive: true,
    ),
  ];

  static final List<WebStoreProduct> mockProducts = [
    WebStoreProduct(
      id: 1,
      name: 'حذاء نايك اير ماكس',
      price: 1500,
      oldPrice: 2000,
      stock: 25,
      image: _placeholderImage,
      category: mockCategories[0],
      brand: 'نايك',
      rating: 4.5,
      reviewsCount: 120,
      isFeatured: true,
      isNew: true,
      description: 'حذاء رياضي مريح من نايك مع تقنية الهواء المisco compression',
    ),
    WebStoreProduct(
      id: 2,
      name: 'حذاء أديداس الترا بوست',
      price: 1800,
      oldPrice: 2200,
      stock: 15,
      image: _placeholderImage,
      category: mockCategories[0],
      brand: 'أديداس',
      rating: 4.7,
      reviewsCount: 85,
      isFeatured: true,
      isNew: false,
      description: 'حذاء رياضي بتقنية الترا بوست للمرونة والراحة',
    ),
    WebStoreProduct(
      id: 3,
      name: 'حذاء كاجوال كلاسيك',
      price: 800,
      oldPrice: 1000,
      stock: 40,
      image: _placeholderImage,
      category: mockCategories[1],
      brand: 'بوما',
      rating: 4.2,
      reviewsCount: 65,
      isFeatured: true,
      isNew: true,
      description: 'حذاء كاجوال كلاسيكي مناسب لكل المناسبات',
    ),
    WebStoreProduct(
      id: 4,
      name: 'حذاء رسمي جلد',
      price: 2500,
      oldPrice: 3000,
      stock: 10,
      image: _placeholderImage,
      category: mockCategories[2],
      brand: 'ريلون',
      rating: 4.8,
      reviewsCount: 45,
      isFeatured: false,
      isNew: false,
      description: 'حذاء رسمي من الجلد الطبيعي للمناسبات الخاصة',
    ),
    WebStoreProduct(
      id: 5,
      name: 'صندل صيفي',
      price: 400,
      oldPrice: 500,
      stock: 60,
      image: _placeholderImage,
      category: mockCategories[3],
      brand: 'نيوبالانس',
      rating: 4.0,
      reviewsCount: 30,
      isFeatured: false,
      isNew: true,
      description: 'صندل صيفي مريح ومناسب للشواطئ',
    ),
    WebStoreProduct(
      id: 6,
      name: 'بوت شتوي',
      price: 1200,
      oldPrice: 1500,
      stock: 20,
      image: _placeholderImage,
      category: mockCategories[4],
      brand: 'نايك',
      rating: 4.3,
      reviewsCount: 55,
      isFeatured: true,
      isNew: false,
      description: 'بوت شتوي دافئ ومقاوم للماء',
    ),
    WebStoreProduct(
      id: 7,
      name: 'حذاء أطفال نايك',
      price: 600,
      oldPrice: 750,
      stock: 35,
      image: _placeholderImage,
      category: mockCategories[5],
      brand: 'نايك',
      rating: 4.6,
      reviewsCount: 90,
      isFeatured: true,
      isNew: true,
      description: 'حذاء أطفال مريح وآمن لللعب',
    ),
    WebStoreProduct(
      id: 8,
      name: 'حذاء أديداس سوبر ستار',
      price: 1100,
      oldPrice: 1300,
      stock: 30,
      image: _placeholderImage,
      category: mockCategories[1],
      brand: 'أديداس',
      rating: 4.4,
      reviewsCount: 75,
      isFeatured: false,
      isNew: false,
      description: 'حذاء كاجوال كلاسيكي من أديداس',
    ),
    WebStoreProduct(
      id: 9,
      name: 'حذاء رياضي بوما',
      price: 950,
      oldPrice: 1200,
      stock: 22,
      image: _placeholderImage,
      category: mockCategories[0],
      brand: 'بوما',
      rating: 4.1,
      reviewsCount: 40,
      isFeatured: false,
      isNew: true,
      description: 'حذاء رياضي خفيف ومناسب للجري',
    ),
    WebStoreProduct(
      id: 10,
      name: 'حذاء رسمي أنيق',
      price: 1800,
      oldPrice: 2100,
      stock: 12,
      image: _placeholderImage,
      category: mockCategories[2],
      brand: 'ريلون',
      rating: 4.9,
      reviewsCount: 25,
      isFeatured: true,
      isNew: false,
      description: 'حذاء رسمي أنيق مناسب للأعمال والمناسبات',
    ),
    WebStoreProduct(
      id: 11,
      name: 'نيوبالانس 574',
      price: 1350,
      oldPrice: 1600,
      stock: 18,
      image: _placeholderImage,
      category: mockCategories[1],
      brand: 'نيوبالانس',
      rating: 4.5,
      reviewsCount: 110,
      isFeatured: true,
      isNew: true,
      description: 'حذاء كاجوال كلاسيكي من نيوبالانس',
    ),
    WebStoreProduct(
      id: 12,
      name: 'بوت ريلي',
      price: 1600,
      oldPrice: 1900,
      stock: 8,
      image: _placeholderImage,
      category: mockCategories[4],
      brand: 'بوما',
      rating: 4.7,
      reviewsCount: 35,
      isFeatured: false,
      isNew: false,
      description: 'بوت ريلي أنيق وعالي الجودة',
    ),
  ];

  static final List<TagModel> mockTags = [
    TagModel(id: 1, name: 'جديد', nameEn: 'New', nameAr: 'جديد'),
    TagModel(id: 2, name: 'تخفيضات', nameEn: 'Sale', nameAr: 'تخفيضات'),
    TagModel(id: 3, name: 'رياضة', nameEn: 'Sports', nameAr: 'رياضة'),
    TagModel(id: 4, name: 'كاجوال', nameEn: 'Casual', nameAr: 'كاجوال'),
    TagModel(id: 5, name: 'رسمي', nameEn: 'Formal', nameAr: 'رسمي'),
  ];

  static final List<ReviewModel> mockReviews = [
    ReviewModel(
      id: 1,
      rating: 5,
      review: 'حذاء ممتاز جداً وريح جداً',
      isApproved: true,
      customer: ReviewCustomer(id: 1, name: 'أحمد'),
    ),
    ReviewModel(
      id: 2,
      rating: 4,
      review: 'تصميم جميل وسعر مناسب',
      isApproved: true,
      customer: ReviewCustomer(id: 2, name: 'محمد'),
    ),
    ReviewModel(
      id: 3,
      rating: 5,
      review: 'توصيل سريع والتغليف ممتاز',
      isApproved: true,
      customer: ReviewCustomer(id: 3, name: 'علي'),
    ),
  ];

  static final CartModel mockCart = CartModel(
    id: 1,
    items: [
      CartItemModel(
        id: 1,
        product: mockProducts[0],
        quantity: 1,
        unitPrice: 1500,
        lineTotal: 1500,
      ),
      CartItemModel(
        id: 2,
        product: mockProducts[2],
        quantity: 2,
        unitPrice: 800,
        lineTotal: 1600,
      ),
    ],
    subtotal: 3100,
    itemCount: 3,
  );

  static final List<SliderModel> mockSliders = [
    SliderModel(
      id: 1,
      title: 'تخفيضات الصيف',
      titleAr: 'تخفيضات الصيف',
      image: _placeholderBanner,
    ),
    SliderModel(
      id: 2,
      title: 'مجموعة الجديدة',
      titleAr: 'مجموعة الجديدة',
      image: _placeholderBanner,
    ),
    SliderModel(
      id: 3,
      title: 'عروض خاصة',
      titleAr: 'عروض خاصة',
      image: _placeholderBanner,
    ),
  ];

  static final List<AdModel> mockAds = [
    AdModel(
      id: 1,
      title: 'عرض 20% خصم',
      titleAr: 'عرض 20% خصم',
      image: _placeholderBanner,
      position: 1,
    ),
    AdModel(
      id: 2,
      title: 'توصيل مجاني',
      titleAr: 'توصيل مجاني',
      image: _placeholderBanner,
      position: 2,
    ),
  ];

  static final List<StoreCouponModel> mockCoupons = [
    StoreCouponModel(
      id: 1,
      code: 'SUMMER20',
      discountType: 'percentage',
      discountTypeLabel: 'نسبة مئوية',
      discountValue: 20,
      minimumOrderValue: 500,
      isActive: true,
      startDate: DateTime(2026, 6, 1),
      endDate: DateTime(2026, 8, 31),
    ),
    StoreCouponModel(
      id: 2,
      code: 'FLAT100',
      discountType: 'fixed',
      discountTypeLabel: 'قيمة ثابتة',
      discountValue: 100,
      minimumOrderValue: 1000,
      isActive: true,
      startDate: DateTime(2026, 6, 1),
      endDate: DateTime(2026, 12, 31),
    ),
  ];

  static final List<StoreOfferModel> mockOffers = [
    StoreOfferModel(
      id: 1,
      name: 'عرض الأحذية الرياضية',
      nameAr: 'عرض الأحذية الرياضية',
      description: 'خصم 25% على جميع الأحذية الرياضية',
      descriptionAr: 'خصم 25% على جميع الأحذية الرياضية',
      discountType: 1,
      discountTypeLabel: 'نسبة مئوية',
      discountValue: 25,
      isActive: true,
      startDate: DateTime(2026, 6, 1),
      endDate: DateTime(2026, 8, 31),
      products: [
        StoreOfferProductModel(
          id: 1,
          name: 'حذاء نايك اير ماكس',
          salePrice: 1500,
        ),
        StoreOfferProductModel(
          id: 2,
          name: 'حذاء أديداس الترا بوست',
          salePrice: 1800,
        ),
      ],
    ),
    StoreOfferModel(
      id: 2,
      name: 'عرض الكاجوال',
      nameAr: 'عرض الكاجوال',
      description: 'خصم 15% على الأحذية الكاجوال',
      descriptionAr: 'خصم 15% على الأحذية الكاجوال',
      discountType: 1,
      discountTypeLabel: 'نسبة مئوية',
      discountValue: 15,
      isActive: true,
      startDate: DateTime(2026, 6, 1),
      endDate: DateTime(2026, 9, 30),
      products: [
        StoreOfferProductModel(
          id: 3,
          name: 'حذاء كاجوال كلاسيك',
          salePrice: 800,
        ),
        StoreOfferProductModel(
          id: 8,
          name: 'حذاء أديداس سوبر ستار',
          salePrice: 1100,
        ),
      ],
    ),
  ];

  static final StoreSettingsModel mockSettings = StoreSettingsModel(
    logo: _placeholderImage,
    shippingValue: '50',
    address: '123 شارع التجزئة، القاهرة',
    addressAr: '123 شارع التجزئة، القاهرة',
    mobile: '01234567890',
    email: 'info@shoestore.com',
    facebook: 'https://facebook.com/shoestore',
    instagram: 'https://instagram.com/shoestore',
  );

  static final List<PaymentMethodModel> mockPaymentMethods = [
    PaymentMethodModel(
      id: 1,
      name: 'الدفع عند الاستلام',
      code: 'cod',
      isActive: true,
    ),
    PaymentMethodModel(
      id: 2,
      name: 'فودافون كاش',
      code: 'vodafone_cash',
      isActive: true,
    ),
    PaymentMethodModel(
      id: 3,
      name: 'فوري',
      code: 'fawry',
      isActive: true,
    ),
    PaymentMethodModel(
      id: 4,
      name: 'بطاقة ائتمان',
      code: 'credit_card',
      isActive: true,
    ),
  ];

  static final List<AddressModel> mockAddresses = [
    AddressModel(
      id: 1,
      name: 'المنزل',
      governorateId: 1,
      cityId: 1,
      governorateName: 'القاهرة',
      cityName: 'المعادي',
      street: 'شارع 9',
      building: '15',
      floor: '3',
      apartment: '2',
      phone: '01234567890',
      isDefault: true,
    ),
    AddressModel(
      id: 2,
      name: 'العمل',
      governorateId: 2,
      cityId: 3,
      governorateName: 'الإسكندرية',
      cityName: 'سيدي جابر',
      street: 'شارع فوزي معاذ',
      building: '20',
      floor: '1',
      apartment: '5',
      phone: '01098765432',
      isDefault: false,
    ),
  ];

  static final List<GovernorateModel> mockGovernorates = [
    GovernorateModel(id: 1, name: 'القاهرة', nameAr: 'القاهرة'),
    GovernorateModel(id: 2, name: 'الإسكندرية', nameAr: 'الإسكندرية'),
    GovernorateModel(id: 3, name: 'الجيزة', nameAr: 'الجيزة'),
    GovernorateModel(id: 4, name: 'القليوبية', nameAr: 'القليوبية'),
    GovernorateModel(id: 5, name: 'المنوفية', nameAr: 'المنوفية'),
  ];

  static final List<CityModel> mockCities = [
    CityModel(id: 1, governorateId: 1, name: 'المعادي', nameAr: 'المعادي'),
    CityModel(id: 2, governorateId: 1, name: 'مدينة نصر', nameAr: 'مدينة نصر'),
    CityModel(id: 3, governorateId: 2, name: 'سيدي جابر', nameAr: 'سيدي جابر'),
    CityModel(id: 4, governorateId: 3, name: 'الدقي', nameAr: 'الدقي'),
    CityModel(id: 5, governorateId: 4, name: 'بنها', nameAr: 'بنها'),
  ];

  static final List<BranchModel> mockBranches = [
    BranchModel(
      id: 1,
      companyId: 1,
      name: 'فرع التجمع',
      nameAr: 'فرع التجمع',
      phone: '0228123456',
      address: 'التجمع الخامس',
      addressAr: 'التجمع الخامس',
      city: 'القاهرة',
      isActive: true,
      isMain: true,
      latitude: 30.0267,
      longitude: 31.4722,
    ),
    BranchModel(
      id: 2,
      companyId: 1,
      name: 'فرع الإسكندرية',
      nameAr: 'فرع الإسكندرية',
      phone: '0334567890',
      address: 'سان ستيفانو',
      addressAr: 'سان ستيفانو',
      city: 'الإسكندرية',
      isActive: true,
      isMain: false,
      latitude: 31.2001,
      longitude: 29.9187,
    ),
    BranchModel(
      id: 3,
      companyId: 1,
      name: 'فرع الدقي',
      nameAr: 'فرع الدقي',
      phone: '0237654321',
      address: 'شارع التحرير',
      addressAr: 'شارع التحرير',
      city: 'الجيزة',
      isActive: true,
      isMain: false,
      latitude: 29.9872,
      longitude: 31.2119,
    ),
  ];

  static final PointsModel mockPoints = PointsModel(
    balance: 1500,
    totalEarned: 3000,
    totalUsed: 1500,
    totalExpired: 0,
    monetaryValue: 150,
    transactions: [
      PointTransaction(
        id: 1,
        title: 'شراء حذاء نايك',
        date: '2026-07-15',
        points: 150,
        isEarned: true,
      ),
      PointTransaction(
        id: 2,
        title: 'استبدال نقاط',
        date: '2026-07-20',
        points: 100,
        isEarned: false,
      ),
      PointTransaction(
        id: 3,
        title: 'شراء حذاء أديداس',
        date: '2026-08-01',
        points: 180,
        isEarned: true,
      ),
    ],
  );

  static final List<BoardingModel> mockBoardings = [
    BoardingModel(
      id: 1,
      title: 'مرحباً بك',
      titleAr: 'مرحباً بك',
      content: 'اكتشف أحدث صيحات الأحذية',
      contentAr: 'اكتشف أحدث صيحات الأحذية',
      image: _placeholderBanner,
      position: 1,
    ),
    BoardingModel(
      id: 2,
      title: 'تسوق بسهولة',
      titleAr: 'تسوق بسهولة',
      content: 'تصفح واطلب من أي مكان',
      contentAr: 'تصفح واطلب من أي مكان',
      image: _placeholderBanner,
      position: 2,
    ),
    BoardingModel(
      id: 3,
      title: 'توصيل سريع',
      titleAr: 'توصيل سريع',
      content: 'نوصلك لحد بابك',
      contentAr: 'نوصلك لحد بابك',
      image: _placeholderBanner,
      position: 3,
    ),
  ];

  static final List<CmsPageModel> mockPages = [
    CmsPageModel(
      id: 1,
      title: 'من نحن',
      titleAr: 'من نحن',
      slug: 'about-us',
      content: 'نحن متجر أحذية رائد في مصر',
      contentAr: 'نحن متجر أحذية رائد في مصر',
    ),
    CmsPageModel(
      id: 2,
      title: 'سياسة الخصوصية',
      titleAr: 'سياسة الخصوصية',
      slug: 'privacy-policy',
      content: 'سياسة الخصوصية الخاصة بنا',
      contentAr: 'سياسة الخصوصية الخاصة بنا',
    ),
    CmsPageModel(
      id: 3,
      title: 'الشروط والأحكام',
      titleAr: 'الشروط والأحكام',
      slug: 'terms',
      content: 'الشروط والأحكام الخاصة بالمتجر',
      contentAr: 'الشروط والأحكام الخاصة بالمتجر',
    ),
  ];

  static final List<Map<String, dynamic>> mockOrders = [
    {
      'id': 1001,
      'status': 'delivered',
      'status_label': 'تم التوصيل',
      'total': 2300,
      'items_count': 2,
      'created_at': '2026-07-15',
      'items': [
        {
          'product_name': 'حذاء نايك اير ماكس',
          'quantity': 1,
          'price': 1500,
          'image': _placeholderImage,
        },
        {
          'product_name': 'حذاء كاجوال كلاسيك',
          'quantity': 1,
          'price': 800,
          'image': _placeholderImage,
        },
      ],
    },
    {
      'id': 1002,
      'status': 'shipped',
      'status_label': 'قيد الشحن',
      'total': 1800,
      'items_count': 1,
      'created_at': '2026-08-01',
      'items': [
        {
          'product_name': 'حذاء أديداس الترا بوست',
          'quantity': 1,
          'price': 1800,
          'image': _placeholderImage,
        },
      ],
    },
    {
      'id': 1003,
      'status': 'pending',
      'status_label': 'في الانتظار',
      'total': 1200,
      'items_count': 1,
      'created_at': '2026-08-10',
      'items': [
        {
          'product_name': 'بوت شتوي',
          'quantity': 1,
          'price': 1200,
          'image': _placeholderImage,
        },
      ],
    },
  ];

  static final Map<String, dynamic> mockOrderDetail = {
    'id': 1001,
    'status': 'delivered',
    'status_label': 'تم التوصيل',
    'subtotal': 2300,
    'shipping': 50,
    'discount': 0,
    'total': 2350,
    'payment_method': 'الدفع عند الاستلام',
    'address': {
      'name': 'المنزل',
      'governorate': 'القاهرة',
      'city': 'المعادي',
      'street': 'شارع 9',
      'building': '15',
    },
    'items': [
      {
        'id': 1,
        'product_name': 'حذاء نايك اير ماكس',
        'quantity': 1,
        'unit_price': 1500,
        'line_total': 1500,
        'image': _placeholderImage,
      },
      {
        'id': 2,
        'product_name': 'حذاء كاجوال كلاسيك',
        'quantity': 1,
        'unit_price': 800,
        'line_total': 800,
        'image': _placeholderImage,
      },
    ],
    'timeline': [
      {'status': 'تم التوصيل', 'date': '2026-07-18 14:30'},
      {'status': 'قيد الشحن', 'date': '2026-07-17 10:00'},
      {'status': 'تم التأكيد', 'date': '2026-07-15 16:20'},
      {'status': 'تم الطلب', 'date': '2026-07-15 16:00'},
    ],
  };
}
