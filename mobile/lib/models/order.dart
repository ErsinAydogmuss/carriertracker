import 'user.dart';
import 'admin.dart';
import 'carrier.dart';
import 'enums.dart';
import 'location.dart';

class Order {
  int id;
  OrderStatus status;
  String product;
  Admin? assignedBy;
  Carrier? assignedTo;
  User? user;
  Location? moveTo;

  Order({
    required this.id,
    this.status = OrderStatus.PENDING,
    required this.product,
    this.assignedBy,
    this.assignedTo,
    required this.user,
    required this.moveTo,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'] != null ? orderStatusFromJson(json['status']) : OrderStatus.PENDING,
      product: json['product'],
      assignedBy: json['assignedBy'] != null ? Admin.fromJson(json['assignedBy']) : null,
      assignedTo: json['assignedTo'] != null ? Carrier.fromJson(json['assignedTo']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      moveTo: json['moveTo'] != null ? Location.fromJson(json['moveTo']) : null,
    );
  }

  @override
  String toString() {
    return 'Order{id: $id, status: $status, product: $product, assignedBy: $assignedBy, assignedTo: $assignedTo, user: $user, moveTo: $moveTo}';
  }
}