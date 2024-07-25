import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/order.dart';
import '../utils/response_data.dart';

class OrderService {

  Future<ResponseData> createOrder({
    required String product,
    required String latitude,
    required String longitude,
    required int userId,
  }) async {
    GetStorage box = GetStorage();
    return await http.post(Uri.parse(createOrderUrl),
        headers: {
          'Authorization' : 'Bearer ${box.read('token')}'
        },
        body: {
      'product': product,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId.toString(),
    }).then((response) {
      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        return ResponseData(
          success: true,
          message: jsonData['message'],
          data: jsonData['result'],
        );
      }else {
        var responseBody = utf8.decode(response.bodyBytes);
        print(responseBody);
        return ResponseData(
          success: false,
          message: responseBody,
        );
      }
    });
  }

  Future<ResponseData> getPendingOrderList() async {
    GetStorage box = GetStorage();
    return await http.get(Uri.parse(getPendingOrderListUrl),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}'
        }).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<Order> orders = jsonData['result'].map<Order>((order) => Order.fromJson(order)).toList();

        return ResponseData(
          success: true,
          message: jsonData['message'],
          data: orders,
        );
      } else {
        var responseBody = utf8.decode(response.bodyBytes);
        return ResponseData(
          success: false,
          message: responseBody,
        );
      }
    }
    );
  }

  Future<ResponseData> getMyOrders() async {
    GetStorage box = GetStorage();
    int userId = box.read('user')['id'];
    var queryUrl = getMyOrdersUrl.replaceAll('{userId}', userId.toString());

    return await http.get(Uri.parse(queryUrl),
        headers: {'Authorization': 'Bearer ${box.read('token')}'}).then((
        response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<Order> orders = jsonData['result'].map<Order>((order) => Order.fromJson(order)).toList();

        return ResponseData(
          success: true,
          message: jsonData['message'],
          data: orders,
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

  Future<ResponseData> getMyDelivery(int carrierId) async {
    GetStorage box = GetStorage();
    var queryUrl = getMyDeliveryUrl.replaceAll('{carrierId}', carrierId.toString());

    return await http.get(Uri.parse(queryUrl),
        headers: {'Authorization': 'Bearer ${box.read('token')}'}).then((
        response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        Order? order = jsonData['result'] == null ? null : Order.fromJson(jsonData['result']);

        return ResponseData(
          success: true,
          message: jsonData['message'],
          data: order,
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