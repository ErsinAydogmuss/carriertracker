import 'location.dart';
import 'order.dart';
import 'user.dart';

class Carrier {
  int id;
  bool isReady;
  List<Order>? orders;
  int? locationId;
  Location? location;
  int? userId;
  User? user;

  Carrier({
    required this.id,
    this.isReady = false,
    this.orders,
    this.locationId,
    this.location,
    this.userId,
    this.user,
  });

  factory Carrier.fromJson(Map<String, dynamic> json) {
    return Carrier(
      id: json['id'],
      isReady: json['isReady'],
      orders: json['orders'] != null ? (json['orders'] as List).map((i) => Order.fromJson(i)).toList() : null,
      locationId: json['locationId'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      userId: json['userId'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  @override
  String toString() {
    return 'Carrier{id: $id, isReady: $isReady, orders: $orders, locationId: $locationId, location: $location, userId: $userId, user: $user}';
  }
}