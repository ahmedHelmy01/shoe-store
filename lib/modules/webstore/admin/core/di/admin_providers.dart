import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';

// Feature Repositories
import 'package:erp/modules/webstore/admin/features/auth/data/repositories/auth_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/repositories/products_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/repositories/categories_repository.dart';
import 'package:erp/modules/webstore/admin/features/users/data/repositories/users_repository.dart';
import 'package:erp/modules/webstore/admin/features/ads/data/repositories/ads_repository.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/repositories/boardings_repository.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/repositories/branches_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/repositories/companies_repository.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/repositories/filters_repository.dart';
import 'package:erp/modules/webstore/admin/features/cities/data/repositories/cities_repository.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/repositories/coupons_repository.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/repositories/governorates_repository.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/repositories/orders_repository.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/repositories/pages_repository.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/repositories/payment_methods_repository.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/repositories/payment_statuses_repository.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/repositories/properties_repository.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/repositories/sliders_repository.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/repositories/warehouses_repository.dart';

final webStoreAdminRemoteDataSourceProvider = Provider<WebStoreAdminRemoteDataSource>((ref) {
  return WebStoreAdminRemoteDataSource(ref.read(networkServiceProvider));
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final productsRepositoryProvider = Provider<IProductsRepository>((ref) {
  return ProductsRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final categoriesRepositoryProvider = Provider<ICategoriesRepository>((ref) {
  return CategoriesRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final usersRepositoryProvider = Provider<IUsersRepository>((ref) {
  return UsersRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final adsRepositoryProvider = Provider<IAdsRepository>((ref) {
  return AdsRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final boardingsRepositoryProvider = Provider<IBoardingsRepository>((ref) {
  return BoardingsRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final branchesRepositoryProvider = Provider<IBranchesRepository>((ref) {
  return BranchesRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final companiesRepositoryProvider = Provider<ICompaniesRepository>((ref) {
  return CompaniesRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final filtersRepositoryProvider = Provider<IFiltersRepository>((ref) {
  return FiltersRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final citiesRepositoryProvider = Provider<ICitiesRepository>((ref) {
  return CitiesRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final couponsRepositoryProvider = Provider<ICouponsRepository>((ref) {
  return CouponsRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final governoratesRepositoryProvider = Provider<IGovernoratesRepository>((ref) {
  return GovernoratesRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final ordersRepositoryProvider = Provider<IOrdersRepository>((ref) {
  return OrdersRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final pagesRepositoryProvider = Provider<IPagesRepository>((ref) {
  return PagesRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final paymentMethodsRepositoryProvider = Provider<IPaymentMethodsRepository>((ref) {
  return PaymentMethodsRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final paymentStatusesRepositoryProvider = Provider<IPaymentStatusesRepository>((ref) {
  return PaymentStatusesRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final propertiesRepositoryProvider = Provider<IPropertiesRepository>((ref) {
  return PropertiesRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final slidersRepositoryProvider = Provider<ISlidersRepository>((ref) {
  return SlidersRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});

final warehousesRepositoryProvider = Provider<IWarehousesRepository>((ref) {
  return WarehousesRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});
