import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/services/webrtc_service.dart';
import 'package:hackathon/services/floating_call_overlay_service.dart';
import 'package:hackathon/globals/constants/globals.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';
import 'package:hackathon/globals/constants/user.dart' as user;

class CallPage extends StatefulWidget {
  static const routePath = '/call';
  final ChatEntity chatEntity;
  final bool isCalling;
  const CallPage({super.key, required this.chatEntity, required this.isCalling});
  @override
  _WebRTCClientState createState() => _WebRTCClientState();
}

class _WebRTCClientState extends State<CallPage> {
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer localScreenRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteScreenRenderer = RTCVideoRenderer();
  RTCVideoRenderer? fullScreenRenderer;
  bool inCall = false;
  late final WebRtcService _webRtcService;

  @override
  void initState() {
    super.initState();
    FloatingCallOverlayService.hide();
    _webRtcService = getIt<WebRtcService>();
    _initializeRenderers().then((_) {
      if (mounted) {
        _webRtcService.onLocalStream = (stream) {
          if (mounted) {
            setState(() {
              localRenderer.srcObject = null;
              localRenderer.srcObject = stream;
            });
          }
        };

        _webRtcService.onLocalScreenStream = (stream) {
          if (mounted) {
            setState(() {
              localScreenRenderer.srcObject = null;
              localScreenRenderer.srcObject = stream;
            });
          }
        };

        _webRtcService.onRemoteStream = (stream) {
          if (mounted) {
            setState(() {
              remoteRenderer.srcObject = null;
              remoteRenderer.srcObject = stream;
            });
          }
        };

        _webRtcService.onRemoteScreenStream = (stream) {
          if (mounted) {
            setState(() {
              remoteScreenRenderer.srcObject = null;
              remoteScreenRenderer.srcObject = stream;
            });
          }
        };

        _webRtcService.onCallEnded = () {
          if (mounted) {
            setState(() {
              inCall = false;
            });
            if (context.canPop()) context.pop();
          }
        };

        // Always start WebRTC; WebRtcService will handle offer vs answer based on isCalling
        startWebRTC();
      }
    });
  }

  Future<void> _initializeRenderers() async {
    await localRenderer.initialize();
    await localScreenRenderer.initialize();
    await remoteRenderer.initialize();
    await remoteScreenRenderer.initialize();
  }

  Future<void> startWebRTC() async {
    if (inCall) return;
    setState(() {
      inCall = true;
    });

    try {
      final roomId = widget.chatEntity.roomId ?? widget.chatEntity.id.toString();
      final currentUserId = getIt<user.User>().user?.id ?? 0;
      final targetUserIds = widget.chatEntity.participants
          .where((p) => p.userId != currentUserId)
          .map((p) => p.userId.toString())
          .toList();
      await _webRtcService.startCall(roomId, isCaller: widget.isCalling, targetUserIds: targetUserIds);
    } catch (e) {
      debugPrint('Error starting WebRTC: $e');
    }
  }

  Future<void> endWebRTCcall() async {
    _webRtcService.endCall();
    setState(() {
      inCall = false;
      fullScreenRenderer = null;
    });
    localRenderer.srcObject = null;
    localScreenRenderer.srcObject = null;
    remoteRenderer.srcObject = null;
    remoteScreenRenderer.srcObject = null;
  }

  @override
  void dispose() {
    final wasInCall = inCall;
    _webRtcService.onLocalStream = null;
    _webRtcService.onLocalScreenStream = null;
    _webRtcService.onRemoteStream = null;
    _webRtcService.onRemoteScreenStream = null;
    _webRtcService.onCallEnded = null;
    localRenderer.dispose();
    localScreenRenderer.dispose();
    remoteRenderer.dispose();
    remoteScreenRenderer.dispose();

    if (wasInCall) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          FloatingCallOverlayService.show(context, widget.chatEntity, widget.isCalling);
        }
      });
    }

    super.dispose();
  }

  bool get isCameraVisible => _webRtcService.isCameraEnabled;
  bool get isScreenSharing => _webRtcService.isScreenSharing;

  @override
  Widget build(BuildContext context) {
    if (fullScreenRenderer != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: RTCVideoView(
                fullScreenRenderer!,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                mirror: fullScreenRenderer == localRenderer,
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.6),
                child: IconButton(
                  icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      fullScreenRenderer = null;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool localHasVideo = localRenderer.srcObject != null &&
        localRenderer.srcObject!.getVideoTracks().isNotEmpty &&
        localRenderer.srcObject!.getVideoTracks().first.enabled;

    final bool remoteHasVideo = remoteRenderer.srcObject != null &&
        remoteRenderer.srcObject!.getVideoTracks().isNotEmpty &&
        remoteRenderer.srcObject!.getVideoTracks().first.enabled;

    final activeVideos = <Widget>[];
    
    // Always include My Camera
    activeVideos.add(_buildVideoCard(
      "My Camera",
      localRenderer,
      isLocal: true,
      hasStream: localHasVideo,
    ));

    // Always include Remote User
    activeVideos.add(_buildVideoCard(
      "Remote User",
      remoteRenderer,
      isLocal: false,
      hasStream: remoteHasVideo,
    ));

    if (localScreenRenderer.srcObject != null) {
      activeVideos.add(_buildVideoCard(
        "My Screen",
        localScreenRenderer,
        isLocal: true,
        hasStream: true,
      ));
    }
    if (remoteScreenRenderer.srcObject != null) {
      activeVideos.add(_buildVideoCard(
        "Remote Screen",
        remoteScreenRenderer,
        isLocal: false,
        hasStream: true,
      ));
    }

    Widget videoLayout;
    if (activeVideos.isEmpty) {
      videoLayout = const Center(
        child: Text(
          "Connecting or awaiting media stream...",
          style: TextStyle(color: ColorPallete.textSecondary, fontSize: 16),
        ),
      );
    } else if (activeVideos.length == 1) {
      videoLayout = Center(
        child: SizedBox(
          width: screenWidth * 0.4,
          height: screenHeight * 0.4,
          child: activeVideos.first,
        ),
      );
    } else {
      videoLayout = GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 4 / 3,
        ),
        itemCount: activeVideos.length,
        itemBuilder: (context, index) => activeVideos[index],
      );
    }

    return Scaffold(
        backgroundColor: ColorPallete.backgroundSecondary,
        body: Column(children: <Widget>[
          CustomAppBar(children: [
            Text(
              "Chats > Calling",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            IconButton(
                icon: const Icon(
                  Icons.home,
                  color: ColorPallete.textPrimary,
                ),
                onPressed: () {
                  context.go(Dashboard.routePath);
                }),
          ]),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: ColorPallete.textPrimary.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(20)),
              width: screenWidth * 0.8,
              height: screenHeight * 0.75,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: videoLayout,
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !inCall
                            ? Tooltip(
                                message: "Call",
                                child: IconButton(
                                    onPressed: () {
                                      startWebRTC();
                                    },
                                    icon: const CircleAvatar(
                                      backgroundColor:
                                          ColorPallete.success,
                                      child: Icon(
                                        Icons.call,
                                      ),
                                    )),
                              )
                            : Tooltip(
                                message: "Call End",
                                child: IconButton(
                                    onPressed: () {
                                      endWebRTCcall();
                                      context.canPop() ? context.pop() : null;
                                    },
                                    icon: const CircleAvatar(
                                      backgroundColor: ColorPallete.redPrimary,
                                      child: Icon(
                                        Icons.call_end,
                                      ),
                                    )),
                              ),
                        const SizedBox(width: 15),
                        Tooltip(
                          message: isScreenSharing ? "Stop Screen Share" : "Share Screen",
                          child: IconButton(
                              onPressed: () {
                                shareScreen();
                              },
                              icon: CircleAvatar(
                                backgroundColor: isScreenSharing
                                    ? ColorPallete.success
                                    : ColorPallete.redPrimary,
                                child: Icon(
                                  isScreenSharing
                                      ? Icons.stop_screen_share
                                      : Icons.screen_share,
                                ),
                              )),
                        ),
                        const SizedBox(width: 15),
                        Tooltip(
                          message: isCameraVisible ? "Toggle Camera Off" : "Toggle Camera On",
                          child: IconButton(
                              onPressed: () {
                                _toggleCamera();
                              },
                              icon: CircleAvatar(
                                backgroundColor: ColorPallete.redPrimary,
                                child: Icon(isCameraVisible
                                    ? Icons.videocam
                                    : Icons.videocam_off),
                              )),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ]));
  }

  Widget _buildVideoCard(String title, RTCVideoRenderer renderer, {bool isLocal = false, bool hasStream = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorPallete.backgroundPrimary,
          border: Border.all(color: ColorPallete.textPrimary.withOpacity(0.1), width: 1),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: hasStream
                  ? RTCVideoView(
                      renderer,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror: isLocal && renderer == localRenderer,
                    )
                  : Container(
                      color: ColorPallete.backgroundSecondary,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: ColorPallete.redPrimary,
                              child: Text(
                                isLocal ? "ME" : _getInitials(_getRemoteName()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isLocal ? "Your video is loading..." : "Awaiting remote stream...",
                              style: const TextStyle(
                                color: ColorPallete.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            if (hasStream)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white, size: 20),
                    onPressed: () {
                      setState(() {
                        fullScreenRenderer = renderer;
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> shareScreen() async {
    await _webRtcService.toggleScreenShare();
    setState(() {});
  }

  void _toggleCamera() async {
    await _webRtcService.toggleCamera();
    setState(() {});
  }

  String _getRemoteName() {
    final currentUserId = getIt<user.User>().user?.id ?? 0;
    final otherParticipants = widget.chatEntity.participants.where((p) => p.userId != currentUserId);
    if (otherParticipants.isNotEmpty) {
      final p = otherParticipants.first;
      return "${p.firstName} ${p.lastName}".trim();
    }
    return "Remote User";
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "U";
    if (parts.length == 1) return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : "U";
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
