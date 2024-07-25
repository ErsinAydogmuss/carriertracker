import 'user.dart';
import 'order.dart';

class Admin {
  int id;
  List<Order>? orders;
  int? userId;
  User? user;

  Admin({
    required this.id,
    this.orders,
    this.userId,
    this.user,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      orders: json['orders'] != null ? (json['orders'] as List).map((i) => Order.fromJson(i)).toList() : null,
      userId: json['userId'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  @override
  String toString() {
    return 'Admin{id: $id, orders: $orders, userId: $userId, user: $user}';
  }
}