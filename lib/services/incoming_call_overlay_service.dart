import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/domain/entities/chat_participant_entity.dart';
import 'package:hackathon/features/chats/presentation/pages/call_page.dart';
import 'package:hackathon/globals/constants/globals.dart';
import 'package:hackathon/services/websocket_service.dart';
import 'package:hackathon/globals/constants/user.dart' as user;
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';

class IncomingCallOverlayService {
  final WebsocketService websocketService;
  ElegantNotification? _elegantNotification;

  IncomingCallOverlayService({required this.websocketService}) {
    websocketService.callStream.listen(_handleCallEvent);
  }

  void _handleCallEvent(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return;
    
    final type = data['type'];
    if (type == 'call_offer') {
      if (data['renegotiate'] == true) return;
      final callingId = data['calling_id']?.toString() ?? '';
      final currentUserId = getIt<user.User>().user?.id.toString();
      if (callingId == currentUserId) return;
      _showIncomingCallOverlay(data);
    } else if (type == 'call_ended') {
      _hideIncomingCallOverlay();
    }
  }

  void _showIncomingCallOverlay(Map<String, dynamic> data) {
    if (_elegantNotification != null) return;

    final callingId = data['calling_id']?.toString() ?? '';
    final callingFirstName = data['calling_first_name'] ?? 'Someone';
    final callingLastName = data['calling_last_name'] ?? '';
    final roomId = data['room_id'];

    final context = navigatorKey.currentContext;
    if (context == null) return;

    _elegantNotification = ElegantNotification(
      title: const Text("Incoming video call...", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      description: Text("$callingFirstName $callingLastName", style: const TextStyle(color: Colors.white70)),
      icon: const Icon(Icons.call, color: ColorPallete.success),
      background: ColorPallete.backgroundSecondary,
      animation: AnimationType.fromTop,
      position: Alignment.topCenter,
      autoDismiss: false,
      isDismissable: false,
      showProgressIndicator: false,
      displayCloseButton: false,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.redAccent),
            onPressed: () {
              _hideIncomingCallOverlay();
              websocketService.sendWebSocketMessage({
                'type': 'call_rejected',
                'room_id': roomId,
                'target_user_ids': [callingId],
              });
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.greenAccent),
            onPressed: () {
              _hideIncomingCallOverlay();
              
              final currentContext = navigatorKey.currentContext;
              if (currentContext != null) {
                final chatEntity = ChatEntity(
                  id: int.tryParse(callingId) ?? 0,
                  roomId: roomId,
                  organisationId: getIt<user.User>().organisation?.id ?? 0,
                  isGroup: false,
                  createdBy: getIt<user.User>().user?.id ?? 0,
                  participants: [
                    ChatParticipantEntity(
                      userId: int.tryParse(callingId) ?? 0,
                      chatId: 0,
                      unreadCount: 0,
                      lastReadMessageId: 0,
                      firstName: callingFirstName,
                      lastName: callingLastName,
                      joinedAt: DateTime.now(),
                    )
                  ],
                  messageCount: 0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                currentContext.push(
                  CallPage.routePath,
                  extra: {
                    'chat': chatEntity,
                    'isCalling': false,
                  },
                );
              }
            },
          ),
        ],
      ),
    );

    _elegantNotification!.show(context);
  }

  void _hideIncomingCallOverlay() {
    _elegantNotification?.dismiss();
    _elegantNotification = null;
  }
}
