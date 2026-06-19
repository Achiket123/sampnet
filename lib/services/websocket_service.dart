import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hackathon/features/notifications/data/models/notification_model.dart';
import 'package:hackathon/features/notifications/domain/entities/notification_entity.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService {
  final User user;
  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _shouldReconnect = true;
  Timer? _reconnectTimer;
  int _reconnectDelaySeconds = 2;

  final Set<String> _subscribedRooms = {};

  final ValueNotifier<List<int>> onlineUsersNotifier = ValueNotifier<List<int>>([]);
  final StreamController<NotificationEntity> _notificationStreamController =
      StreamController<NotificationEntity>.broadcast();
  final StreamController<dynamic> _messageStreamController =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> _callStreamController =
      StreamController<dynamic>.broadcast();

  Stream<NotificationEntity> get notificationStream => _notificationStreamController.stream;
  Stream<dynamic> get messageStream => _messageStreamController.stream;
  Stream<dynamic> get callStream => _callStreamController.stream;

  WebsocketService({required this.user});

  void connect() {
    if (_isConnected) return;
    _shouldReconnect = true;

    final token = user.employeeToken ?? user.token;
    if (token == null) {
      debugPrint("WebsocketService: No token available for connection.");
      return;
    }

    final rawUrl = "${ApiConstants.websocketBaseUrl}/ws?token=$token";
    Uri wsUri = Uri.parse(rawUrl);

    if (wsUri.scheme != 'ws' && wsUri.scheme != 'wss') {
      if (wsUri.scheme == 'http' || wsUri.scheme == 'https') {
        wsUri = wsUri.replace(scheme: wsUri.scheme == 'https' ? 'wss' : 'ws');
      } else if (kIsWeb) {
        // Resolve relative URI against Uri.base on web
        final resolvedUri = Uri.base.resolve(rawUrl);
        wsUri = resolvedUri.replace(scheme: resolvedUri.scheme == 'https' ? 'wss' : 'ws');
      }
    }

    debugPrint("WebsocketService: Connecting to $wsUri");

    try {
      _channel = WebSocketChannel.connect(wsUri);
      _isConnected = true;
      _reconnectDelaySeconds = 2; // Reset reconnect delay on connection attempt

      for (final roomId in _subscribedRooms) {
        final subMsg = jsonEncode({
          "type": "subscribe_room",
          "room_id": roomId,
        });
        _channel!.sink.add(subMsg);
        debugPrint("WebsocketService: Resubscribed to room $roomId on connection");
      }

      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          debugPrint("WebsocketService Error: $error");
          _handleDisconnect();
        },
        onDone: () {
          debugPrint("WebsocketService connection closed.");
          _handleDisconnect();
        },
      );
    } catch (e) {
      debugPrint("WebsocketService: connection exception: $e");
      _handleDisconnect();
    }
  }

  void sendWebSocketMessage(Map<String, dynamic> data) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(jsonEncode(data));
      debugPrint("WebsocketService: Sent ${data['type']}");
    }
  }

  void subscribeRoom(String roomId) {
    _subscribedRooms.add(roomId);
    if (_isConnected && _channel != null) {
      final subMsg = jsonEncode({
        "type": "subscribe_room",
        "room_id": roomId,
      });
      _channel!.sink.add(subMsg);
      debugPrint("WebsocketService: Sent subscribe_room for $roomId");
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final Map<String, dynamic> data = jsonDecode(message);
      
      final type = data['type'] as String?;
      if (type == 'chat_message' || type == 'new_message') {
        _messageStreamController.add(data['payload']);
        debugPrint("WebsocketService: Received chat message");
        return;
      } else if (type == 'call_incoming' || type == 'call_accepted' || type == 'call_rejected' || type == 'call_ended' || type == 'ice_candidate' || type == 'call_offer' || type == 'call_answer') {
        _callStreamController.add(data);
        debugPrint("WebsocketService: Received call event: $type");
        return;
      }

      if (data.containsKey('online_users')) {
        final List<dynamic> users = data['online_users'];
        onlineUsersNotifier.value = users.map((e) => e as int).toList();
        debugPrint("WebsocketService: Received online users: ${onlineUsersNotifier.value}");
      } else if (data.containsKey('id')) {
        final notification = NotificationModel.fromJson(data).toEntity();
        _notificationStreamController.add(notification);
        debugPrint("WebsocketService: Received notification: ${notification.title}");
      }
    } catch (e) {
      debugPrint("WebsocketService: Failed to parse message: $e");
    }
  }

  void _handleDisconnect() {
    _isConnected = false;
    _channel = null;
    onlineUsersNotifier.value = [];

    if (_shouldReconnect) {
      _reconnectTimer?.cancel();
      debugPrint("WebsocketService: Retrying connection in $_reconnectDelaySeconds seconds...");
      _reconnectTimer = Timer(Duration(seconds: _reconnectDelaySeconds), () {
        if (_reconnectDelaySeconds < 30) {
          _reconnectDelaySeconds *= 2;
        }
        connect();
      });
    }
  }

  void disconnect() {
    debugPrint("WebsocketService: Disconnecting...");
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    onlineUsersNotifier.value = [];
  }
}