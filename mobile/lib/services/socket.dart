import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import '../models/recieve_message.dart';


class SocketService extends ChangeNotifier {
  IO.Socket? socket;

  static final SocketService _instance = SocketService._internal();

  SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  void initiateSocketConnection() async {
    socket = IO.io(
      "http://localhost:3005",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1000)
          .disableAutoConnect()
          .build(),
    );

    socket?.onConnect((_) {
      debugPrint('Connected to socket server');
    });

    socket?.onDisconnect((_) {
      debugPrint('Disconnected from socket server');
    });

    socket?.on('message', (data) {
      debugPrint('Received message: $data');
    });

    socket?.on('connect_error', (error) {
      debugPrint('Connection error: $error');
    });

    socket?.on('connect_timeout', (data) {
      debugPrint('Connection timeout');
    });

    socket?.on('error', (error) {
      debugPrint('Error: $error');
    });

    socket?.on('reconnect', (attemptNumber) {
      debugPrint('Reconnected: $attemptNumber');
    });

    socket?.on('reconnect_attempt', (attemptNumber) {
      debugPrint('Reconnect attempt: $attemptNumber');
    });

    socket?.on('reconnecting', (attemptNumber) {
      debugPrint('Reconnecting: $attemptNumber');
    });

    socket?.on('reconnect_error', (error) {
      debugPrint('Reconnect error: $error');
    });

    socket?.connect();
  }

  void addUser(String userId) {
    socket?.emit('addUser', {
      'userId': userId,
    });
  }

  void listenToMessages(addNotification) {

    socket?.on('receiveNotification', (data) {
      print('receiveNotification');
      print(data);
      ReceivedMessage message = ReceivedMessage(
        receiverId: data['receiverId'],
        orderId: data['orderId'],
        status: data['status'],
        createdAt: data['createdAt'],
      );
      print(message);
      addNotification(message);
    });
  }

  void deleteNotificationListener() {
    socket?.off('receiveNotification');
    socket?.off('removeReceiveNotification');
  }

  void sendNotification(
      String receiverId,
      String orderId,
      String status,
      String createdAt,
      ) {
    GetStorage box = GetStorage();

    if(receiverId != box.read('user')['id']) {
      socket?.emit('sendNotification', {
        'receiverId': receiverId,
        'orderId': orderId,
        'status': status,
        'createdAt': createdAt,
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    deleteNotificationListener();
    socket?.disconnect();
    socket?.destroy();
  }
}
