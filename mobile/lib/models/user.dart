import 'admin.dart';
import 'carrier.dart';
import 'enums.dart';
import 'order.dart';

class User {
  int? id;
  String name;
  String email;
  String password;
  Role role;
  List<Order>? orders;
  Carrier? carrier;
  Admin? admin;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.orders,
    required this.carrier,
    required this.admin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'] ?? '',
      role: json['role'] != null ? roleFromJson(json['role']) : Role.USER,
      orders: json['orders'] != null ? (json['orders'] as List).map((i) => Order.fromJson(i)).toList() : null,
      carrier: json['carrier'] != null ? Carrier.fromJson(json['carrier']) : null,
      admin: json['admin'] != null ? Admin.fromJson(json['admin']) : null,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password, role: $role, orders: $orders, carrier: $carrier, admin: $admin}';
  }
}

