import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/carrier.dart';
import '../models/order.dart';
import '../utils/response_data.dart';

class CarrierService {
  Future<ResponseData> getPendingCarrierList() async {
    GetStorage box = GetStorage();
    return await http.get(Uri.parse(getPendingCarrierListUrl),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}'
        }).then((response) {
          print(response);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<Carrier> carriers = jsonData['result'].map<Carrier>((carrier) => Carrier.fromJson(carrier)).toList();

        print(carriers);
        return ResponseData(
          success: true,
          message: jsonData['message'],
          data: carriers,
        );
      } else {
        print(response.body);
        var responseBody = utf8.decode(response.bodyBytes);
        return ResponseData(
          success: false,
          message: responseBody,
        );
      }
    }
    );
  }

  Future<ResponseData> assignToCarrier({
    required int carrierId,
    required int orderId,
  }) async {
    GetStorage box = GetStorage();
    print(box.read('user'));
    return await http.post(Uri.parse(assignCarrierUrl),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}'
        },
        body: {
          'carrierId': carrierId.toString(),
          'orderId': orderId.toString(),
          'adminId' : box.read('user')['adminId'].toString(),
        }).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return ResponseData(
          success: true,
          message: jsonData['message'],
          data: jsonData['result'],
        );
      } else {
        var responseBody = utf8.decode(response.bodyBytes);
        return ResponseData(
          success: false,
          message: responseBody,
        );
      }
    });
  }

  Future<ResponseData> updateLocation({
    required int carrierId,
    required double latitude,
    required double longitude,
  }) async {
    GetStorage box = GetStorage();
    var queryUrl = updateLocationUrl.replaceAll('{carrierId}', carrierId.toString());

    return await http.put(Uri.parse(queryUrl),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}'
        },
        body: {
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        }).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        return ResponseData(
          success: true,
          message: jsonData['message'],
          data: jsonData['result'],
        );
      } else {
        var responseBody = utf8.decode(response.bodyBytes);
        return ResponseData(
          success: false,
          message: responseBody,
        );
      }
    });
  }

  Future<ResponseData> finishDelivery({
    required int orderId,
  }) async {
    GetStorage box = GetStorage();
    int carrierId = box.read('user')['carrierId'];
    var queryUrl = finishDeliveryUrl.replaceAll('{carrierId}', carrierId.toString());

    return await http.put(Uri.parse(queryUrl),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}'
        },
        body: {
          'orderId': orderId.toString(),
        }).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        Order order = Order.fromJson(jsonData['result']);
        return ResponseData(
          success: true,
          message: jsonData['message'],
          data: order
        );
      } else {
        var responseBody = utf8.decode(response.bodyBytes);
        return ResponseData(
          success: false,
          message: responseBody,
        );
      }
    });
  }

  Future<ResponseData> changeCarrierStatus({
    required int carrierId,
    required bool isReady,
  }) async {
    GetStorage box = GetStorage();
    var queryUrl = changeCarrierStatusUrl.replaceAll('{carrierId}', carrierId.toString());

    return await http.put(Uri.parse(queryUrl),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}'
        },
        body: {
          'isReady': isReady.toString(),
        }).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return ResponseData(
          success: true,
          message: jsonData['message'],
          data: jsonData['result'],
        );
      } else {
        var responseBody = utf8.decode(response.bodyBytes);
        return ResponseData(
          success: false,
          message: responseBody,
        );
      }
    });
  }
}