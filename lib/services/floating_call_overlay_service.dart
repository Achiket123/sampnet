import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/presentation/pages/call_page.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/services/webrtc_service.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/globals.dart';
import 'package:hackathon/globals/constants/user.dart' as user;

class FloatingCallOverlayService {
  static OverlayEntry? _overlayEntry;
  static double _x = 20.0;
  static double _y = 100.0;

  static bool get isActive => _overlayEntry != null;

  static void show(BuildContext context, ChatEntity chatEntity, bool isCalling) {
    if (_overlayEntry != null) return;

    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) {
      debugPrint("FloatingCallOverlayService: Could not find OverlayState via navigatorKey.");
      return;
    }

    final size = MediaQuery.maybeOf(context)?.size ?? const Size(1024, 768);
    
    // Position it in the bottom-right corner of the screen by default
    _x = size.width - 180 - 24;
    _y = size.height - 240 - 24;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _FloatingCallWidget(
          chatEntity: chatEntity,
          isCalling: isCalling,
          onDismiss: hide,
        );
      },
    );

    overlayState.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _FloatingCallWidget extends StatefulWidget {
  final ChatEntity chatEntity;
  final bool isCalling;
  final VoidCallback onDismiss;

  const _FloatingCallWidget({
    required this.chatEntity,
    required this.isCalling,
    required this.onDismiss,
  });

  @override
  State<_FloatingCallWidget> createState() => _FloatingCallWidgetState();
}

class _FloatingCallWidgetState extends State<_FloatingCallWidget> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  late final WebRtcService _webRtcService;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _webRtcService = getIt<WebRtcService>();
    _initRenderers();
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    if (!mounted) return;

    setState(() {
      _localRenderer.srcObject = _webRtcService.localStream;
      _remoteRenderer.srcObject = _webRtcService.remoteStream;
      _initialized = true;
    });

    _webRtcService.onLocalStream = (stream) {
      if (mounted) {
        setState(() {
          _localRenderer.srcObject = null;
          _localRenderer.srcObject = stream;
        });
      }
    };

    _webRtcService.onRemoteStream = (stream) {
      if (mounted) {
        setState(() {
          _remoteRenderer.srcObject = null;
          _remoteRenderer.srcObject = stream;
        });
      }
    };

    _webRtcService.onCallEnded = () {
      widget.onDismiss();
    };
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox.shrink();

    final hasRemoteVideo = _remoteRenderer.srcObject != null &&
        _remoteRenderer.srcObject!.getVideoTracks().isNotEmpty &&
        _remoteRenderer.srcObject!.getVideoTracks().first.enabled;

    final participant = widget.chatEntity.participants.firstWhere(
      (p) => p.userId != getIt<user.User>().user?.id,
      orElse: () => widget.chatEntity.participants.first,
    );
    
    final firstChar = (participant.firstName != null && participant.firstName!.isNotEmpty) ? participant.firstName![0] : '';
    final lastChar = (participant.lastName != null && participant.lastName!.isNotEmpty) ? participant.lastName![0] : '';
    final initials = "$firstChar$lastChar".toUpperCase();

    return Positioned(
      left: FloatingCallOverlayService._x,
      top: FloatingCallOverlayService._y,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            FloatingCallOverlayService._x += details.delta.dx;
            FloatingCallOverlayService._y += details.delta.dy;

            // Enforce constraints to stay on screen
            final size = MediaQuery.of(context).size;
            FloatingCallOverlayService._x = FloatingCallOverlayService._x.clamp(8.0, size.width - 180.0 - 8.0);
            FloatingCallOverlayService._y = FloatingCallOverlayService._y.clamp(8.0, size.height - 240.0 - 8.0);
          });
          FloatingCallOverlayService._overlayEntry?.markNeedsBuild();
        },
        child: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(16),
          color: ColorPallete.backgroundSecondary,
          child: Container(
            width: 180,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12, width: 1.5),
            ),
            child: Stack(
              children: [
                // Remote Video Stream / Initials Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: hasRemoteVideo
                      ? RTCVideoView(
                          _remoteRenderer,
                          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        )
                      : Container(
                          color: ColorPallete.backgroundSecondary,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: ColorPallete.redPrimary.withOpacity(0.15),
                                  child: Text(
                                    initials.isNotEmpty ? initials : "?",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "${participant.firstName ?? ''} ${participant.lastName ?? ''}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Active call...",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),

                // Restore / Maximize button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      widget.onDismiss();
                      final context = navigatorKey.currentContext;
                      if (context != null) {
                        context.push(
                          CallPage.routePath,
                          extra: {
                            'chat': widget.chatEntity,
                            'isCalling': widget.isCalling,
                          },
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.open_in_full,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),

                // End call button
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        _webRtcService.endCall();
                        widget.onDismiss();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
