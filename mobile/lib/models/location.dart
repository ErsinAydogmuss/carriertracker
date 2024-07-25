import 'carrier.dart';
import 'order.dart';

class Location {
  int id;
  double latitude;
  double longitude;
  List<Order>? orders;
  List<Carrier>? carriers;

  Location({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.orders,
    this.carriers,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      orders: json['orders'] != null ? (json['orders'] as List).map((i) => Order.fromJson(i)).toList() : null,
      carriers: json['carriers'] != null ? (json['carriers'] as List).map((i) => Carrier.fromJson(i)).toList() : null,
    );
  }

  @override
  String toString() {
    return 'Location{id: $id, latitude: $latitude, longitude: $longitude, orders: $orders, carriers: $carriers}';
  }
}