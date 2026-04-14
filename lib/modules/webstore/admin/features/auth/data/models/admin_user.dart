class AdminUser {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String email;
  final String? phone;
  final String? locale;
  final bool isActive;
  final AdminCompany company;
  final List<AdminBranch> branches;
  final List<String> roles;
  final List<String> permissions;
  final String? createdAt;
  final String? updatedAt;
  final String? token;

  const AdminUser({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    required this.email,
    this.phone,
    this.locale,
    required this.isActive,
    required this.company,
    required this.branches,
    required this.roles,
    required this.permissions,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      email: json['email'],
      phone: json['phone'],
      locale: json['locale'],
      isActive: json['is_active'] ?? false,
      company: AdminCompany.fromJson(json['company']),
      branches: (json['branches'] as List? ?? [])
          .map((e) => AdminBranch.fromJson(e))
          .toList(),
      roles: List<String>.from(json['roles'] ?? []),
      permissions: List<String>.from(json['permissions'] ?? []),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  AdminUser copyWith({String? token}) {
    return AdminUser(
      id: id,
      name: name,
      nameEn: nameEn,
      nameAr: nameAr,
      email: email,
      phone: phone,
      locale: locale,
      isActive: isActive,
      company: company,
      branches: branches,
      roles: roles,
      permissions: permissions,
      createdAt: createdAt,
      updatedAt: updatedAt,
      token: token ?? this.token,
    );
  }
}

class AdminCompany {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? shortName;
  final String? prefix;
  final String? email;
  final String? phone;
  final String? fax;
  final String? website;
  final String? address;
  final String? city;
  final String? countryCode;
  final String? postalCode;
  final String? taxNumber;
  final String? commercialRegister;
  final String? currency;
  final String? locale;
  final String? timezone;
  final int? fiscalYearStartMonth;
  final String? logo;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  const AdminCompany({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.shortName,
    this.prefix,
    this.email,
    this.phone,
    this.fax,
    this.website,
    this.address,
    this.city,
    this.countryCode,
    this.postalCode,
    this.taxNumber,
    this.commercialRegister,
    this.currency,
    this.locale,
    this.timezone,
    this.fiscalYearStartMonth,
    this.logo,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminCompany.fromJson(Map<String, dynamic> json) {
    return AdminCompany(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      shortName: json['short_name'],
      prefix: json['prefix'],
      email: json['email'],
      phone: json['phone'],
      fax: json['fax'],
      website: json['website'],
      address: json['address'],
      city: json['city'],
      countryCode: json['country_code'],
      postalCode: json['postal_code'],
      taxNumber: json['tax_number'],
      commercialRegister: json['commercial_register'],
      currency: json['currency'],
      locale: json['locale'],
      timezone: json['timezone'],
      fiscalYearStartMonth: json['fiscal_year_start_month'],
      logo: json['logo'],
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class AdminBranch {
  final int id;
  final int companyId;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? code;
  final String? phone;
  final String? email;
  final String? address;
  final String? city;
  final String? country;
  final bool isActive;
  final bool isMain;
  final String? createdAt;
  final String? updatedAt;

  const AdminBranch({
    required this.id,
    required this.companyId,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.code,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.country,
    required this.isActive,
    required this.isMain,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminBranch.fromJson(Map<String, dynamic> json) {
    return AdminBranch(
      id: json['id'],
      companyId: json['company_id'],
      name: json['name'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      code: json['code'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      isActive: json['is_active'] ?? false,
      isMain: json['is_main'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
