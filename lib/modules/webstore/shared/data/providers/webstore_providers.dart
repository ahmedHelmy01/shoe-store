import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/shared/data/datasource/webstore_remote_datasource.dart';
import 'package:erp/modules/webstore/cms/data/repositories/cms_repository.dart';
import 'package:erp/modules/webstore/onboarding/data/repositories/boarding_repository.dart';

/// WebStore Module Remote Data Source Provider
final webStoreRemoteDataSourceProvider = Provider<WebStoreRemoteDataSource>((ref) {
  return WebStoreRemoteDataSource(ref.watch(networkServiceProvider));
});

/// CMS Repository Provider
final cmsRepositoryProvider = Provider<ICMSRepository>((ref) {
  return CMSRepository(ref.watch(webStoreRemoteDataSourceProvider));
});

/// Boarding Repository Provider
final boardingRepositoryProvider = Provider<IBoardingRepository>((ref) {
  return BoardingRepository(ref.watch(webStoreRemoteDataSourceProvider));
});
