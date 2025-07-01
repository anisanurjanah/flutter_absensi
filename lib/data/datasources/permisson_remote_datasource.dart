import 'package:dartz/dartz.dart';
import 'package:flutter_absensi_app/core/constants/variables.dart';
import 'package:flutter_absensi_app/data/datasources/auth_local_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PermissonRemoteDatasource {
  Future<Either<String, String>> addPermission(
      String type, String date, String reason, XFile? image) async {

    print("AKAN KIRIM PERMISSION...");
    print("type: $type");
    print("date: $date");
    print("reason: $reason");
    print("image: ${image?.path}");

    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/api-permissions');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData?.token}',
    };

    var request = http.MultipartRequest('POST', url);

    request.headers.addAll(headers);
    request.fields['type'] = type;
    request.fields['date'] = date;
    request.fields['reason'] = reason;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    print("REQUEST SIAP DIKIRIM...");
    http.StreamedResponse response = await request.send();
    print("REQUEST SELESAI DIKIRIM. Status code: ${response.statusCode}");

    final String body = await response.stream.bytesToString();
    print("Response body: $body");

    if (response.statusCode == 201) {
      return const Right('Permission added successfully');
    } else {
      return const Left('Failed to add permission');
    }
  }
}
