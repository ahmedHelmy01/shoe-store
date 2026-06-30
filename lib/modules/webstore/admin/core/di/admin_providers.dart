import 'package:erp/modules/webstore/admin/features/prescriptions/data/datasource/admin_prescriptions_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/prescriptions/data/repositories/admin_prescriptions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';

// Feature DataSources
import 'package:erp/modules/webstore/admin/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/datasource/products_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/datasource/categories_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/users/data/datasource/users_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/ads/data/datasource/ads_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/datasource/boardings_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/datasource/branches_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/datasource/companies_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/datasource/filters_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/cities/data/datasource/cities_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/datasource/coupons_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/offers/data/datasource/offers_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/datasource/governorates_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/datasource/orders_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/datasource/pages_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/datasource/payment_methods_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/datasource/payment_statuses_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/datasource/properties_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/datasource/sliders_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/datasource/order_statuses_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/customers/customer_groups/data/datasource/customer_groups_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/datasource/warehouses_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/datasource/countries_remote_datasource.dart';

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
import 'package:erp/modules/webstore/admin/features/offers/data/repositories/offers_repository.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/repositories/governorates_repository.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/repositories/orders_repository.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/repositories/pages_repository.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/repositories/payment_methods_repository.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/repositories/payment_statuses_repository.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/repositories/properties_repository.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/repositories/sliders_repository.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/repositories/order_statuses_repository.dart';
import 'package:erp/modules/webstore/admin/features/customers/customer_groups/data/repositories/customer_groups_repository.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/repositories/countries_repository.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/repositories/warehouses_repository.dart';
import 'package:erp/modules/webstore/admin/features/offers/data/models/offer_row.dart';

// --- DataSources ---

final authDataSourceProvider = Provider((ref) => AuthRemoteDataSource(ref.read(networkServiceProvider)));
final productsDataSourceProvider = Provider((ref) => ProductsRemoteDataSource(ref.read(networkServiceProvider)));
final categoriesDataSourceProvider = Provider((ref) => CategoriesRemoteDataSource(ref.read(networkServiceProvider)));
final usersDataSourceProvider = Provider((ref) => UsersRemoteDataSource(ref.read(networkServiceProvider)));
final adsDataSourceProvider = Provider((ref) => AdsRemoteDataSource(ref.read(networkServiceProvider)));
final boardingsDataSourceProvider = Provider((ref) => BoardingsRemoteDataSource(ref.read(networkServiceProvider)));
final branchesDataSourceProvider = Provider((ref) => BranchesRemoteDataSource(ref.read(networkServiceProvider)));
final companiesDataSourceProvider = Provider((ref) => CompaniesRemoteDataSource(ref.read(networkServiceProvider)));
final filtersDataSourceProvider = Provider((ref) => FiltersRemoteDataSource(ref.read(networkServiceProvider)));
final citiesDataSourceProvider = Provider((ref) => CitiesRemoteDataSource(ref.read(networkServiceProvider)));
final couponsDataSourceProvider = Provider((ref) => CouponsRemoteDataSource(ref.read(networkServiceProvider)));
final offersDataSourceProvider = Provider((ref) => OffersRemoteDataSource(ref.read(networkServiceProvider)));
final governoratesDataSourceProvider = Provider((ref) => GovernoratesRemoteDataSource(ref.read(networkServiceProvider)));
final ordersDataSourceProvider = Provider((ref) => OrdersRemoteDataSource(ref.read(networkServiceProvider)));
final pagesDataSourceProvider = Provider((ref) => PagesRemoteDataSource(ref.read(networkServiceProvider)));
final paymentMethodsDataSourceProvider = Provider((ref) => PaymentMethodsRemoteDataSource(ref.read(networkServiceProvider)));
final paymentStatusesDataSourceProvider = Provider((ref) => PaymentStatusesRemoteDataSource(ref.read(networkServiceProvider)));
final propertiesDataSourceProvider = Provider((ref) => PropertiesRemoteDataSource(ref.read(networkServiceProvider)));
final slidersDataSourceProvider = Provider((ref) => SlidersRemoteDataSource(ref.read(networkServiceProvider)));
final warehousesDataSourceProvider = Provider((ref) => WarehousesRemoteDataSource(ref.read(networkServiceProvider)));
final orderStatusesDataSourceProvider = Provider((ref) => OrderStatusesRemoteDataSource(ref.read(networkServiceProvider)));
final adminPrescriptionsDataSourceProvider = Provider((ref) => AdminPrescriptionsRemoteDataSource(ref.read(networkServiceProvider)));
final customerGroupsDataSourceProvider = Provider((ref) => CustomerGroupsRemoteDataSource(ref.read(networkServiceProvider)));
final countriesDataSourceProvider = Provider((ref) => CountriesRemoteDataSource(ref.read(networkServiceProvider)));

// --- Repositories ---

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(ref.read(authDataSourceProvider));
});

final productsRepositoryProvider = Provider<IProductsRepository>((ref) {
  return ProductsRepository(
    ref.read(productsDataSourceProvider),
    ref.read(uploadServiceProvider),
  );
});

final categoriesRepositoryProvider = Provider<ICategoriesRepository>((ref) {
  return CategoriesRepository(
    ref.read(categoriesDataSourceProvider),
    ref.read(uploadServiceProvider),
  );
});

final usersRepositoryProvider = Provider<IUsersRepository>((ref) {
  return UsersRepository(ref.read(usersDataSourceProvider));
});

final adsRepositoryProvider = Provider<IAdsRepository>((ref) {
  return AdsRepository(ref.read(adsDataSourceProvider));
});

final boardingsRepositoryProvider = Provider<IBoardingsRepository>((ref) {
  return BoardingsRepository(ref.read(boardingsDataSourceProvider));
});

final branchesRepositoryProvider = Provider<IBranchesRepository>((ref) {
  return BranchesRepository(ref.read(branchesDataSourceProvider));
});

final companiesRepositoryProvider = Provider<ICompaniesRepository>((ref) {
  return CompaniesRepository(ref.read(companiesDataSourceProvider));
});

final filtersRepositoryProvider = Provider<IFiltersRepository>((ref) {
  return FiltersRepository(ref.read(filtersDataSourceProvider));
});

final citiesRepositoryProvider = Provider<ICitiesRepository>((ref) {
  return CitiesRepository(ref.read(citiesDataSourceProvider));
});

final couponsRepositoryProvider = Provider<ICouponsRepository>((ref) {
  return CouponsRepository(ref.read(couponsDataSourceProvider));
});

final offersRepositoryProvider = Provider<IOffersRepository>((ref) {
  return OffersRepository(ref.read(offersDataSourceProvider));
});

final governoratesRepositoryProvider = Provider<IGovernoratesRepository>((ref) {
  return GovernoratesRepository(ref.read(governoratesDataSourceProvider));
});

final ordersRepositoryProvider = Provider<IOrdersRepository>((ref) {
  return OrdersRepository(ref.read(ordersDataSourceProvider));
});

final pagesRepositoryProvider = Provider<IPagesRepository>((ref) {
  return PagesRepository(ref.read(pagesDataSourceProvider));
});

final paymentMethodsRepositoryProvider = Provider<IPaymentMethodsRepository>((ref) {
  return PaymentMethodsRepository(ref.read(paymentMethodsDataSourceProvider));
});

final paymentStatusesRepositoryProvider = Provider<IPaymentStatusesRepository>((ref) {
  return PaymentStatusesRepository(ref.read(paymentStatusesDataSourceProvider));
});

final propertiesRepositoryProvider = Provider<IPropertiesRepository>((ref) {
  return PropertiesRepository(ref.read(propertiesDataSourceProvider));
});

final slidersRepositoryProvider = Provider<ISlidersRepository>((ref) {
  return SlidersRepository(ref.read(slidersDataSourceProvider));
});

final warehousesRepositoryProvider = Provider<IWarehousesRepository>((ref) {
  return WarehousesRepository(ref.read(warehousesDataSourceProvider));
});

final orderStatusesRepositoryProvider = Provider<IOrderStatusesRepository>((ref) {
  return OrderStatusesRepository(ref.read(orderStatusesDataSourceProvider));
});

final adminPrescriptionsRepositoryProvider = Provider<IAdminPrescriptionsRepository>((ref) {
  return AdminPrescriptionsRepository(ref.read(adminPrescriptionsDataSourceProvider));
});

final customerGroupsRepositoryProvider = Provider<ICustomerGroupsRepository>((ref) {
  return CustomerGroupsRepository(ref.read(customerGroupsDataSourceProvider));
});

final countriesRepositoryProvider = Provider<ICountriesRepository>((ref) {
  return CountriesRepository(ref.read(countriesDataSourceProvider));
});


// --- Dropdown Data Providers ---

/// Fetches category tree from `/api/store/categories/tree` for hierarchical dropdown.
final categoryTreeProvider = FutureProvider<List<dynamic>>((ref) async {
  final network = ref.read(networkServiceProvider);
  final response = await network.get('/api/store/categories/tree');
  final data = response as Map<String, dynamic>;
  return (data['data'] as List?) ?? [];
});

final allCategoriesProvider = FutureProvider((ref) async {
  final repo = ref.read(categoriesRepositoryProvider);
  final res = await repo.getCategories(page: 1, perPage: 1000);
  return res.when(
    success: (paged) => paged.items,
    failure: (e) => throw e,
  );
});

final allCompaniesProvider = FutureProvider((ref) async {
  final repo = ref.read(companiesRepositoryProvider);
  final res = await repo.getCompanies(page: 1, perPage: 1000);
  return res.when(
    success: (paged) => paged.items,
    failure: (e) => throw e,
  );
});

final allTagsProvider = FutureProvider((ref) async {
  final repo = ref.read(filtersRepositoryProvider);
  final res = await repo.getFilters(page: 1, perPage: 1000);
  return res.when(
    success: (paged) => paged.items,
    failure: (e) => throw e,
  );
});

final allPropertiesProvider = FutureProvider((ref) async {
  final repo = ref.read(propertiesRepositoryProvider);
  final res = await repo.getProperties(page: 1, perPage: 1000);
  return res.when(
    success: (paged) => paged.items,
    failure: (e) => throw e,
  );
});

final allProductsProvider = FutureProvider((ref) async {
  final repo = ref.read(productsRepositoryProvider);
  final res = await repo.getProducts(page: 1, perPage: 1000);
  return res.when(
    success: (paged) => paged.items,
    failure: (e) => throw e,
  );
});

final allCustomerGroupsProvider = FutureProvider((ref) async {
  final repo = ref.read(customerGroupsRepositoryProvider);
  final res = await repo.getCustomerGroups(page: 1);
  return res.when(
    success: (paged) => paged.items,
    failure: (e) => throw e,
  );
});

final allCountriesProvider = FutureProvider((ref) async {
  final repo = ref.read(countriesRepositoryProvider);
  final res = await repo.getCountries(page: 1, perPage: 1000);
  return res.when(
    success: (paged) => paged.items,
    failure: (e) => throw e,
  );
});

final paymentMethodTypesProvider = FutureProvider((ref) async {
  final repo = ref.read(paymentMethodsRepositoryProvider);
  final res = await repo.getPaymentMethodTypes();
  return res.when(
    success: (list) => list,
    failure: (e) => throw e,
  );
});

final singleOfferProvider = FutureProvider.family<OfferRow, int>((ref, id) async {
  final repo = ref.read(offersRepositoryProvider);
  final res = await repo.getOffer(id);
  return res.when(
    success: (data) => data,
    failure: (e) => throw e,
  );
});



