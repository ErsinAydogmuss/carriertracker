import 'package:yetis_mobile/models/enums.dart';

class ReceivedMessage {
  final String receiverId;
  final String orderId;
  final String status;
  final String createdAt;

  ReceivedMessage({
    required this.receiverId,
    required this.orderId,
    required this.status,
    required this.createdAt,
  });

  factory ReceivedMessage.fromJson(Map<String, dynamic> json) {
    return ReceivedMessage(
      receiverId: json['receiverId'],
      orderId: json['orderId'],
      status: json['status'],
      createdAt: json['\$createdAt'] ?? DateTime.now().toString(),
    );
  }

  @override
  String toString() {
    return 'ReceivedMessage{receiverId: $receiverId, orderId: $orderId, createdAt: $createdAt}';
  }
}