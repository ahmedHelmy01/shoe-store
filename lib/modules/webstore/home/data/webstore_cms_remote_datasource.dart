/// WebStore CMS Remote DataSource
///
/// CMS-only HTTP calls to WebStore API endpoints using NetworkService.
library;

import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class WebStoreCmsRemoteDataSource {
  final NetworkService _networkService;

  WebStoreCmsRemoteDataSource(this._networkService);

  Future<dynamic> getSliders() {
    return _networkService.get(ApiEndpoints.webstore.cms.sliders);
  }

  Future<dynamic> getAds() {
    return _networkService.get(ApiEndpoints.webstore.cms.ads);
  }

  Future<dynamic> getCoupons() {
    return _networkService.get(ApiEndpoints.webstore.cms.coupons);
  }

  Future<dynamic> getBoardings() {
    return _networkService.get(ApiEndpoints.webstore.cms.boardings);
  }

  Future<dynamic> getPages() {
    return _networkService.get(ApiEndpoints.webstore.cms.pages);
  }

  Future<dynamic> getPageBySlug(String slug) {
    return _networkService.get(ApiEndpoints.withSlug(ApiEndpoints.webstore.cms.pageDetail, slug));
  }

  Future<dynamic> getSettings() {
    return _networkService.get(ApiEndpoints.webstore.cms.settings);
  }

  Future<dynamic> getBranches() {
    return _networkService.get(ApiEndpoints.webstore.cms.branches);
  }

  Future<dynamic> submitContact(Map<String, dynamic> data) {
    return _networkService.post(ApiEndpoints.webstore.cms.contact, body: data);
  }
}

