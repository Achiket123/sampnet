import 'dart:async';
import 'dart:convert';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/presentation/pages/call_page.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/user.dart' as user;
import 'package:hackathon/services/api_client.dart';
import 'package:flutter_web_notification_platform/flutter_web_notification_platform.dart';

class WebRTCSignaling {
  final ApiClient apiClient = getIt<ApiClient>();

  Future<void> createOffer(
    String offer,
    int roomId,
    ChatEntity chatEntity,
  ) async {
    try {
      await apiClient
          .put(ApiConstants.updateCallOffer(roomId.toString()), body: {
        "calling_id": getIt<user.User>().user!.id.toString(),
        'calling_first_name': getIt<user.User>().user!.firstName,
        'calling_last_name': getIt<user.User>().user!.lastName,
        'offer': offer,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static String? _lastOffer;

  static StreamSubscription? listenForCalling(BuildContext context) {
    return Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
      try {
        final response = await getIt<ApiClient>()
            .get(ApiConstants.getCall(getIt<user.User>().user!.id.toString()));
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      return null;
    }).listen((payload) {
      if (payload != null &&
          payload['offer'] != null &&
          payload['offer'] != _lastOffer) {
        _lastOffer = payload['offer'];
        final notificationPlatform = PlatformNotificationWeb();
        notificationPlatform.requestPermission();

        notificationPlatform.sendNotification(
            "${payload['calling_first_name']} ", "Calling You");

        ElegantNotification.info(
          description: const Text(
            "Calling...",
            style: TextStyle(color: Colors.black),
          ),
          action: IconButton(
            onPressed: () {
              ChatEntity chatEntity = ChatEntity(
                id: getIt<user.User>().user!.id,
                firstName: payload['calling_first_name'],
                lastName: payload['calling_last_name'],
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
      } else if (payload != null && payload['offer'] == null) {
        _lastOffer = null;
      }
    });
  }

  endCall(String id) async {
    try {
      await apiClient.put(ApiConstants.endCall(id));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
