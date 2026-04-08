library;

import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/localization/locale_keys.dart';

/// WebStore Mock Data
///
/// Static mock data for categories and products.
/// Used as temporary placeholders until API services are wired up.

// ─── Category Model ──────────────────────────────────

class MockSubCategory {
  final int id;
  final String name;
  final String image;

  const MockSubCategory({
    required this.id,
    required this.name,
    required this.image,
  });
}

class MockCategory {
  final int id;
  final String name;
  final String icon;
  final String? image;
  final String color;
  final List<MockSubCategory> subCategories;

  const MockCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.image,
    required this.color,
    this.subCategories = const [],
  });
}

// ─── Product Model ───────────────────────────────────

class MockProduct {
  final int id;
  final String name;
  final String image;
  final String manufacturer;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewCount;
  final String categoryName;
  final bool isFeatured;

  const MockProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.manufacturer,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.categoryName,
    this.isFeatured = false,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;
  int get discountPercent =>
      hasDiscount ? (((oldPrice! - price) / oldPrice!) * 100).round() : 0;
}

// ─── Banner Model ────────────────────────────────────

class MockBanner {
  final int id;
  final String title;
  final String subtitle;
  final String gradient1;
  final String gradient2;
  final String icon;

  const MockBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.gradient1,
    required this.gradient2,
    required this.icon,
  });
}

// ─── Ad Model ───────────────────────────────────────

class MockAd {
  final int id;
  final String image;
  final String? deepLink;

  const MockAd({required this.id, required this.image, this.deepLink});
}

// ─── Company Model ──────────────────────────────────

class MockCompany {
  final int id;
  final String name;
  final String logo;

  const MockCompany({required this.id, required this.name, required this.logo});
}

// ─── Feature Link Model ────────────────────────────

class MockFeatureLink {
  final int id;
  final String title;
  final String icon;
  final String? iconPath;
  final String route;

  const MockFeatureLink({
    required this.id,
    required this.title,
    required this.icon,
    this.iconPath,
    required this.route,
  });
}

// ═══════════════════════════════════════════════════════
// ─── STATIC DATA ──────────────────────────────────────
// ═══════════════════════════════════════════════════════

class WebStoreMockData {
  // ─── Categories ────────────────────────────────────

  static final List<MockCategory> categories = [
    MockCategory(
      id: 1,
      name: 'أدوية روشتة',
      icon: '💊',
      image: 'https://images.unsplash.com/photo-1584017890885-32aa8104868f?q=80&w=300&auto=format&fit=crop',
      color: '#FF6D00',
      subCategories: [
        MockSubCategory(id: 101, name: 'مضادات حيوية', image: 'https://images.unsplash.com/photo-1550572017-edd951aa8f72?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 102, name: 'مسكنات ألم', image: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 103, name: 'فيتامينات', image: 'https://images.unsplash.com/photo-1628177142898-93e36e4e3a50?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 104, name: 'أدوية ضغط', image: 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 105, name: 'قطرات أذن', image: 'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?q=80&w=300&auto=format&fit=crop'),
      ],
    ),
    MockCategory(
      id: 2,
      name: 'عناية بالبشرة',
      icon: '🧴',
      image: 'https://images.unsplash.com/photo-1556228578-8c7c2f1f1d1f?q=80&w=300&auto=format&fit=crop',
      color: '#2E7D32',
      subCategories: [
        MockSubCategory(id: 201, name: 'مرطبات', image: 'https://images.unsplash.com/photo-1611930022073-b7a4ba5fcccd?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 202, name: 'غسول وجه', image: 'https://images.unsplash.com/photo-1556228578-52d3a9da4333?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 203, name: 'واقي شمس', image: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 204, name: 'سيروم', image: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 205, name: 'أقنعة وجه', image: 'https://plus.unsplash.com/premium_photo-1661645318182-386f68da367c?q=80&w=300&auto=format&fit=crop'),
      ],
    ),
    MockCategory(
      id: 3,
      name: 'فيتامينات',
      icon: '🍎',
      image: 'https://images.unsplash.com/photo-1550573104-4eb82614a45e?q=80&w=300&auto=format&fit=crop',
      color: '#FF9800',
      subCategories: [
        MockSubCategory(id: 301, name: 'مالتي فيتامين', image: 'https://images.unsplash.com/photo-1628177142898-92fed2433065?q=80&w=200&auto=format&fit=crop'),
        MockSubCategory(id: 302, name: 'مكملات غذائية', image: 'https://images.unsplash.com/photo-1559839734-2b71f1e3c770?q=80&w=200&auto=format&fit=crop'),
      ],
    ),
    MockCategory(
      id: 4,
      name: 'أجهزة طبية',
      icon: '🌡️',
      image: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=300&auto=format&fit=crop',
      color: '#1565C0',
      subCategories: [
        MockSubCategory(id: 401, name: 'جهاز ضغط', image: 'https://images.unsplash.com/photo-1615486511484-92e172cc4fe0?q=80&w=200&auto=format&fit=crop'),
        MockSubCategory(id: 402, name: 'جهاز سكر', image: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?q=80&w=200&auto=format&fit=crop'),
      ],
    ),
    MockCategory(
      id: 5,
      name: 'عناية بالطفل',
      icon: '👶',
      image: 'https://images.unsplash.com/photo-1515488420047-5056bcfa0e89?q=80&w=300&auto=format&fit=crop',
      color: '#E91E63',
      subCategories: [
        MockSubCategory(id: 501, name: 'حفاضات', image: 'https://images.unsplash.com/photo-1510017803434-a899398421b3?q=80&w=200&auto=format&fit=crop'),
        MockSubCategory(id: 502, name: 'شامبو أطفال', image: 'https://images.unsplash.com/photo-1512428559087-560ad5ceab42?q=80&w=200&auto=format&fit=crop'),
      ],
    ),
    MockCategory(
      id: 6,
      name: 'عناية بالشعر',
      icon: '💇',
      image: 'https://images.unsplash.com/photo-1522337660859-02fbefca4702?q=80&w=300&auto=format&fit=crop',
      color: '#9C27B0',
      subCategories: [
        MockSubCategory(id: 601, name: 'شامبو', image: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 602, name: 'بلسم', image: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 603, name: 'صبغات', image: 'https://images.unsplash.com/photo-1533219057257-4bb9ed5d2cc6?q=80&w=300&auto=format&fit=crop'),
      ],
    ),
    MockCategory(
      id: 7,
      name: 'أدوات حقن',
      icon: '💉',
      image: 'https://images.unsplash.com/photo-1628177142898-93e36e4e3a50?q=80&w=300&auto=format&fit=crop',
      color: '#F44336',
      subCategories: [
        MockSubCategory(id: 701, name: 'سرنجات', image: 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?q=80&w=300&auto=format&fit=crop'),
        MockSubCategory(id: 702, name: 'كحول معقم', image: 'https://images.unsplash.com/photo-1583324113626-70df0f43aa2b?q=80&w=300&auto=format&fit=crop'),
      ],
    ),
    MockCategory(
      id: 8,
      name: 'المزيد',
      icon: '📦',
      image: 'https://images.unsplash.com/photo-1523206489230-c012c64b2b48?q=80&w=300&auto=format&fit=crop',
      color: '#607D8B',
      subCategories: [
        MockSubCategory(id: 801, name: 'إسعاف بري', image: 'https://plus.unsplash.com/premium_photo-1673327174301-447543881514?q=80&w=300&auto=format&fit=crop'),
      ],
    ),
  ];

  // ─── Banners ───────────────────────────────────────

  static final List<MockBanner> banners = [
    MockBanner(
      id: 1,
      title: 'عروض الأدوية 🔥',
      subtitle: 'خصم حتى 30% على منتجات العناية بالبشرة',
      gradient1: '#FF6D00',
      gradient2: '#F08320',
      icon: '💊',
    ),
    MockBanner(
      id: 2,
      title: 'أجهزة طبية حديثة ✨',
      subtitle: 'أجهزة قياس الضغط والسكر بأفضل الأسعار',
      gradient1: '#1565C0',
      gradient2: '#42A5F5',
      icon: '🌡️',
    ),
    MockBanner(
      id: 3,
      title: 'توصيل مجاني 🚚',
      subtitle: 'خدمة توصيل الطلبات للمنزل خلال 30 دقيقة',
      gradient1: '#2E7D32',
      gradient2: '#4CAF50',
      icon: '🚲',
    ),
  ];

  // ─── Ads ──────────────────────────────────────────

  static final List<MockAd> ads = [
    MockAd(
      id: 1,
      image: 'https://images.unsplash.com/photo-1585435557343-3b092031a831?q=80&w=800&auto=format&fit=crop',
    ),
    MockAd(
      id: 2,
      image: 'https://img.freepik.com/free-vector/great-offer-sale-steel-blue-abstract-background-professional-multipurpose-design-banner_1340-17225.jpg?semt=ais_hybrid&w=740&q=80',
    ),
  ];

  // ─── Companies ────────────────────────────────────

  static const List<MockCompany> companies = [
    MockCompany(
      id: 1,
      name: 'GSK',
      logo: 'https://upload.wikimedia.org/wikipedia/en/thumb/2/22/GSK_logo_2022.svg/220px-GSK_logo_2022.svg.png',
    ),
    MockCompany(
      id: 2,
      name: 'Pfizer',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Pfizer_%282021%29.svg/220px-Pfizer_%282021%29.svg.png',
    ),
    MockCompany(
      id: 3,
      name: 'Novartis',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Novartis-Logo.svg/220px-Novartis-Logo.svg.png',
    ),
    MockCompany(
      id: 4,
      name: 'Sanofi',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Sanofi_logo_%282022%29.svg/220px-Sanofi_logo_%282022%29.svg.png',
    ),
    MockCompany(
      id: 5,
      name: 'Bayer',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Logo_Bayer.svg/220px-Logo_Bayer.svg.png',
    ),
  ];

  // ─── Feature Links ───────────────────────────────

  static final List<MockFeatureLink> featureLinks = [
    MockFeatureLink(
      id: 1,
      title: LocaleKeys.webstore.home.feature_products,
      icon: '💊',
      iconPath: AssetManager.medicine,
      route: '/products',
    ),
    MockFeatureLink(
      id: 2,
      title: LocaleKeys.webstore.home.feature_categories,
      icon: '🛡️',
      iconPath: AssetManager.drugs,
      route: '/categories',
    ),
    MockFeatureLink(
      id: 3,
      title: LocaleKeys.webstore.home.feature_discounts,
      icon: '🔥',
      iconPath: AssetManager.discount,
      route: '/offers',
    ),
    MockFeatureLink(
      id: 4,
      title: LocaleKeys.webstore.home.feature_new_arrivals,
      icon: '✨',
      iconPath: AssetManager.shopping,
      route: '/new-arrivals',
    ),
    MockFeatureLink(
      id: 5,
      title: LocaleKeys.webstore.home.feature_best_sellers,
      icon: '🏆',
      iconPath: AssetManager.bestSeller,
      route: '/best-sellers',
    ),
    MockFeatureLink(
      id: 6,
      title: LocaleKeys.webstore.home.feature_special_picks,
      icon: '🌟',
      iconPath: AssetManager.bestSale,
      route: '/special-picks',
    ),
  ];

  // ─── Products ──────────────────────────────────────

  static final List<MockProduct> featuredProducts = [
    MockProduct(
      id: 1,
      name: 'بندول اكسترا 24 قرص',
      image: 'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'GSK Pharmaceuticals',
      price: 35.0,
      oldPrice: 45.0,
      rating: 4.9,
      reviewCount: 450,
      categoryName: 'أدوية روشتة',
      isFeatured: true,
    ),
    MockProduct(
      id: 2,
      name: 'كريم لاروش بوزيه',
      image: 'https://images.unsplash.com/photo-1611930022073-b7a4ba5fcccd?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'La Roche-Posay',
      price: 450.0,
      rating: 4.8,
      reviewCount: 320,
      categoryName: 'عناية بالبشرة',
      isFeatured: true,
    ),
    MockProduct(
      id: 3,
      name: 'جهاز قياس السكر أكيو تشيك',
      image: 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Roche Diabetes',
      price: 850.0,
      oldPrice: 950.0,
      rating: 4.7,
      reviewCount: 156,
      categoryName: 'أجهزة طبية',
      isFeatured: true,
    ),
    MockProduct(
      id: 4,
      name: 'حليب أطفال نان 1',
      image: 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Nestlé Health Science',
      price: 185.0,
      rating: 4.9,
      reviewCount: 890,
      categoryName: 'عناية بالطفل',
      isFeatured: true,
    ),
  ];

  static final List<MockProduct> latestProducts = [
    MockProduct(
      id: 5,
      name: 'أوجمنتين 1 جم 14 قرص',
      image: 'https://images.unsplash.com/photo-1550572017-edd951aa8f72?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'GSK Pharmaceuticals',
      price: 89.75,
      oldPrice: 95.0,
      rating: 4.8,
      reviewCount: 670,
      categoryName: 'أدوية روشتة',
    ),
    MockProduct(
      id: 6,
      name: 'شامبو فيتشي للقشرة',
      image: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Vichy Laboratories',
      price: 420.0,
      rating: 4.6,
      reviewCount: 215,
      categoryName: 'عناية بالشعر',
    ),
    MockProduct(
      id: 7,
      name: 'فيتامين سي 1000 ملجم',
      image: 'https://images.unsplash.com/photo-1616671276441-2f2c277b8bf6?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Eva Pharma',
      price: 45.0,
      oldPrice: 55.0,
      rating: 4.9,
      reviewCount: 1200,
      categoryName: 'فيتامينات',
    ),
    MockProduct(
      id: 8,
      name: 'سرنجة معقمة 5 سم',
      image: 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Pharco',
      price: 2.5,
      rating: 4.5,
      reviewCount: 5600,
      categoryName: 'أدوات حقن',
    ),
    MockProduct(
      id: 9,
      name: 'كمامة طبية 50 قطعة',
      image: 'https://images.unsplash.com/photo-1584634731339-252c581abfc5?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Medical Tools',
      price: 45.0,
      oldPrice: 60.0,
      rating: 4.4,
      reviewCount: 3450,
      categoryName: 'أجهزة طبية',
    ),
    MockProduct(
      id: 10,
      name: 'نوفالدول 1000 مجم 15 قرص',
      image: 'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Sanofi',
      price: 32.0,
      rating: 4.8,
      reviewCount: 980,
      categoryName: 'أدوية روشتة',
    ),
  ];
}
