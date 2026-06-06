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

class IncomingCallOverlayService {
  final WebsocketService websocketService;
  OverlayEntry? _overlayEntry;

  IncomingCallOverlayService({required this.websocketService}) {
    websocketService.callStream.listen(_handleCallEvent);
  }

  void _handleCallEvent(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return;
    
    final type = data['type'];
    if (type == 'call_offer') {
      _showIncomingCallOverlay(data);
    } else if (type == 'call_ended') {
      _hideIncomingCallOverlay();
    }
  }

  void _showIncomingCallOverlay(Map<String, dynamic> data) {
    if (_overlayEntry != null) return;

    final callingId = data['calling_id']?.toString() ?? '';
    final callingFirstName = data['calling_first_name'] ?? 'Someone';
    final callingLastName = data['calling_last_name'] ?? '';
    final roomId = data['room_id'];

    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorPallete.blackSecondary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: ColorPallete.greenPrimary,
                  child: Icon(Icons.call, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$callingFirstName $callingLastName",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Incoming video call...",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.redAccent),
                  onPressed: () {
                    _hideIncomingCallOverlay();
                    // Optional: Send call_rejected event back
                    websocketService.sendWebSocketMessage({
                      'type': 'call_rejected',
                      'room_id': roomId,
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.greenAccent),
                  onPressed: () {
                    _hideIncomingCallOverlay();
                    
                    final context = navigatorKey.currentContext;
                    if (context != null) {
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

                      context.push(
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
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void _hideIncomingCallOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
