library;

import 'package:erp/core/utils/asset_manager.dart';

/// WebStore Mock Data
///
/// Static mock data for categories and products.
/// Used as temporary placeholders until API services are wired up.

// ─── Category Model ──────────────────────────────────

class MockCategory {
  final int id;
  final String name;
  final String icon;
  final String? image;
  final String color;

  const MockCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.image,
    required this.color,
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
      image: 'https://images.unsplash.com/photo-1576091160550-217359f42f8c?q=80&w=300&auto=format&fit=crop',
      color: '#FF6D00',
    ),
    MockCategory(
      id: 2,
      name: 'عناية بالبشرة',
      icon: '🧴',
      image: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=300&auto=format&fit=crop',
      color: '#2E7D32',
    ),
    MockCategory(
      id: 3,
      name: 'فيتامينات',
      icon: '🍎',
      image: 'https://images.unsplash.com/photo-1550573104-4eb82614a45e?q=80&w=300&auto=format&fit=crop',
      color: '#FF9800',
    ),
    MockCategory(
      id: 4,
      name: 'أجهزة طبية',
      icon: '🌡️',
      image: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=300&auto=format&fit=crop',
      color: '#1565C0',
    ),
    MockCategory(
      id: 5,
      name: 'عناية بالطفل',
      icon: '👶',
      image: 'https://images.unsplash.com/photo-1515488420047-5056bcfa0e89?q=80&w=300&auto=format&fit=crop',
      color: '#E91E63',
    ),
    MockCategory(
      id: 6,
      name: 'عناية بالشعر',
      icon: '💇',
      image: 'https://images.unsplash.com/photo-1522337660859-02fbefca4702?q=80&w=300&auto=format&fit=crop',
      color: '#9C27B0',
    ),
    MockCategory(
      id: 7,
      name: 'أدوات حقن',
      icon: '💉',
      image: 'https://images.unsplash.com/photo-1628177142898-93e36e4e3a50?q=80&w=300&auto=format&fit=crop',
      color: '#F44336',
    ),
    MockCategory(
      id: 8,
      name: 'المزيد',
      icon: '📦',
      image: 'https://images.unsplash.com/photo-1523206489230-c012c64b2b48?q=80&w=300&auto=format&fit=crop',
      color: '#607D8B',
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
      image: 'https://images.unsplash.com/photo-1579165466541-71ae2247f7d5?q=80&w=800&auto=format&fit=crop',
    ),
  ];

  // ─── Companies ────────────────────────────────────

  static const List<MockCompany> companies = [
    MockCompany(
      id: 1,
      name: 'GSK',
      logo: 'https://logo.clearbit.com/gsk.com',
    ),
    MockCompany(
      id: 2,
      name: 'Pfizer',
      logo: 'https://logo.clearbit.com/pfizer.com',
    ),
    MockCompany(
      id: 3,
      name: 'Novartis',
      logo: 'https://logo.clearbit.com/novartis.com',
    ),
    MockCompany(
      id: 4,
      name: 'Eva Pharma',
      logo: 'https://media.licdn.com/dms/image/v2/C4E0BAQHkSj_6n_UIdw/company-logo_200_200/company-logo_200_200/0/1630650974345/eva_pharma_logo?e=2147483647&v=beta&t=7bA0wzUjx0n-vG9W1XoN6fR0eS0SjYw5F0SjYw5F0SjY',
    ),
    MockCompany(
      id: 5,
      name: 'Amoun',
      logo: 'https://media.licdn.com/dms/image/v2/C4E0BAQH_RjwC8mIdJQ/company-logo_200_200/company-logo_200_200/0/1631317584634?e=2147483647&v=beta&t=7bA0wzUjx0n-vG9W1XoN6fR0eS0SjYw5F0SjYw5F0SjY',
    ),
  ];

  // ─── Feature Links ───────────────────────────────

  static final List<MockFeatureLink> featureLinks = [
    MockFeatureLink(
      id: 1,
      title: 'المنتجات',
      icon: '💊',
      iconPath: AssetManager.medicine,
      route: '/products',
    ),
    MockFeatureLink(
      id: 2,
      title: 'الأقسام',
      icon: '🛡️',
      iconPath: AssetManager.drugs,
      route: '/categories',
    ),
    MockFeatureLink(
      id: 3,
      title: 'الخصومات',
      icon: '🔥',
      iconPath: AssetManager.discount,
      route: '/offers',
    ),
    MockFeatureLink(
      id: 4,
      title: 'وصل حديثاً',
      icon: '✨',
      iconPath: AssetManager.shopping,
      route: '/new-arrivals',
    ),
    MockFeatureLink(
      id: 5,
      title: 'الأكثر مبيعاً',
      icon: '🏆',
      iconPath: AssetManager.bestSeller,
      route: '/best-sellers',
    ),
    MockFeatureLink(
      id: 6,
      title: 'اختيارات مميزة',
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
      image: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=600&auto=format&fit=crop',
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
      image: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=600&auto=format&fit=crop',
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
      image: 'https://images.unsplash.com/photo-1615461066870-40c144002701?q=80&w=600&auto=format&fit=crop',
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
      image: 'https://images.unsplash.com/photo-1522338242992-e1a54906a8da?q=80&w=600&auto=format&fit=crop',
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
      image: 'https://images.unsplash.com/photo-1471864190281-ad5fe93b0a70?q=80&w=600&auto=format&fit=crop',
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
      image: 'https://images.unsplash.com/photo-1535585209827-a151cbafcfef?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Vichy Laboratories',
      price: 420.0,
      rating: 4.6,
      reviewCount: 215,
      categoryName: 'عناية بالشعر',
    ),
    MockProduct(
      id: 7,
      name: 'فيتامين سي 1000 ملجم',
      image: 'https://images.unsplash.com/photo-1616670876402-945763027788?q=80&w=600&auto=format&fit=crop',
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
      image: 'https://images.unsplash.com/photo-1628177142898-93e36e4e3a50?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Pharco',
      price: 2.5,
      rating: 4.5,
      reviewCount: 5600,
      categoryName: 'أدوات حقن',
    ),
    MockProduct(
      id: 9,
      name: 'كمامة طبية 50 قطعة',
      image: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=600&auto=format&fit=crop',
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
      image: 'https://images.unsplash.com/photo-1502740479093-6c84c6c039c3?q=80&w=600&auto=format&fit=crop',
      manufacturer: 'Sanofi',
      price: 32.0,
      rating: 4.8,
      reviewCount: 980,
      categoryName: 'أدوية روشتة',
    ),
  ];
}
