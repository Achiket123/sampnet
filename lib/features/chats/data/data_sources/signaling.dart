import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/presentation/pages/call_page.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/globals/constants/user.dart' as user;
import 'package:hackathon/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_web_notification_platform/flutter_web_notification_platform.dart';

class WebRTCSignaling {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createOffer(
    String offer,
    int roomId,
    ChatEntity chatEntity,
  ) async {
    // Create SDP offer
    try {
      // Save offer to Firestore
      await supabase.from('calls').update({
        "calling_id": user.User.user.id.toString(),
        'calling_first_name': user.User.user.firstName,
        'calling_last_name': user.User.user.lastName,
        'offer': offer,
      }).eq('id', roomId);
    } catch (e) {
      print(e.toString());
    }
  }

  static RealtimeChannel listenForCalling(BuildContext context) {
    return supabase
        .channel('channel:calls')
        .onPostgresChanges(
          schema: 'public',
          table: 'calls',
          event: PostgresChangeEvent.update,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: user.User.user.id,
          ),
          callback: (payload) async {
            debugPrint(
              payload.newRecord.toString(),
            );

            if (payload.newRecord['offer'] != null) {
              final notificationPlatform = PlatformNotificationWeb();
              notificationPlatform.requestPermission();

              notificationPlatform.sendNotification(
                  "${payload.newRecord['calling_first_name']} ", "Calling You");

              ElegantNotification.info(
                description: const Text(
                  "Calling...",
                  style: TextStyle(color: Colors.black),
                ),
                action: IconButton(
                  onPressed: () {
                    ChatEntity chatEntity = ChatEntity(
                      id: user.User.user.id,
                      firstName: payload.newRecord['calling_first_name'],
                      lastName: payload.newRecord['calling_last_name'],
                      numberOfMessage: 0,
                    );

                    context.push(
                      CallPage.routePath,
                      extra: {
                        'chat': chatEntity,
                        'isCalling': true,
                      },
                    );
                  },
                  icon: const Icon(Icons.call),
                ),
              ).show(parentContext!);
            }
          },
        )
        .subscribe();
  }

  endCall(String id) async {
    await supabase.from('calls').update({
      'calling_id': null,
      'calling_first_name': null,
      'offer': null,
      'calling_last_name': null,
    }).eq('id', id);
  }
}
