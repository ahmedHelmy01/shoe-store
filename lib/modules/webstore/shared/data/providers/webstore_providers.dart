import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/cms/data/repositories/cms_repository.dart';
import 'package:erp/modules/webstore/onboarding/data/repositories/boarding_repository.dart';
import 'package:erp/modules/webstore/cms/data/datasource/webstore_cms_remote_datasource.dart';

/// WebStore CMS Remote Data Source Provider
final webStoreCmsRemoteDataSourceProvider = Provider<WebStoreCmsRemoteDataSource>((ref) {
  return WebStoreCmsRemoteDataSource(ref.watch(networkServiceProvider));
});

/// CMS Repository Provider
final cmsRepositoryProvider = Provider<ICMSRepository>((ref) {
  return CMSRepository(ref.watch(webStoreCmsRemoteDataSourceProvider));
});

/// Boarding Repository Provider
final boardingRepositoryProvider = Provider<IBoardingRepository>((ref) {
  return BoardingRepository(ref.watch(webStoreCmsRemoteDataSourceProvider));
});
