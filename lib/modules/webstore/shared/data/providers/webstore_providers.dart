import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/home/data/cms_repository.dart';
import 'package:erp/modules/webstore/onboarding/data/repositories/boarding_repository.dart';

/// CMS Repository Provider
final cmsRepositoryProvider = Provider<ICMSRepository>((ref) {
  return CMSRepository();
});

/// Boarding Repository Provider
final boardingRepositoryProvider = Provider<IBoardingRepository>((ref) {
  return BoardingRepository();
});
