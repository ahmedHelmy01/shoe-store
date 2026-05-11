import 'package:erp/core/network/network_service.dart';
import 'package:image_picker/image_picker.dart' show XFile;

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

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    Map<String, XFile>? files,
    Map<String, List<XFile>>? multiFiles,
    void Function(double)? onProgress,
  }) async {
    final res = await network.postMultipart(
      path, 
      fields: fields, 
      files: files, 
      multiFiles: multiFiles,
      onProgress: onProgress,
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> putMultipart(
    String path, {
    required Map<String, String> fields,
    Map<String, XFile>? files,
    Map<String, List<XFile>>? multiFiles,
    void Function(double)? onProgress,
  }) async {
    final res = await network.putMultipart(
      path, 
      fields: fields, 
      files: files, 
      multiFiles: multiFiles,
      onProgress: onProgress,
    );
    return (res as Map).cast<String, dynamic>();
  }

  Future<void> deleteData(String path) async {
    await network.delete(path);
  }
}
