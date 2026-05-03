import 'package:erp/core/network/network_service.dart';

class AdminRemoteDataSource {
  final NetworkService network;

  AdminRemoteDataSource(this.network);

  Future<Map<String, dynamic>> postData(String path, Map<String, dynamic> data) async {
    final res = await network.post(path, body: data);
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> putData(String path, Map<String, dynamic> data) async {
    final res = await network.put(path, body: data);
    return (res as Map).cast<String, dynamic>();
  }

  Future<void> deleteData(String path) async {
    await network.delete(path);
  }
}
