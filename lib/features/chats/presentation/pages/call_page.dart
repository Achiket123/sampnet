import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/services/webrtc_service.dart';
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
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool inCall = false;
  late final WebRtcService _webRtcService;
  bool isCameraVisible = true;

  @override
  void initState() {
    super.initState();
    _webRtcService = getIt<WebRtcService>();
    _initializeRenderers().then((_) {
      if (mounted) {
        _webRtcService.onLocalStream = (stream) {
          setState(() {
            localRenderer.srcObject = stream;
          });
        };

        _webRtcService.onRemoteStream = (stream) {
          setState(() {
            remoteRenderer.srcObject = stream;
          });
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
    await remoteRenderer.initialize();
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
    });
    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ColorPallete.blackSecondary,
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
                  color: Colors.white,
                ),
                onPressed: () {
                  context.go(Dashboard.routePath);
                }),
          ]),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: ColorPallete.offWhite2,
                  borderRadius: BorderRadius.circular(20)),
              width: screenWidth * 0.7,
              height: screenHeight * 0.7,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorPallete.blackPrimary),
                            child: RTCVideoView(localRenderer,
                                objectFit: RTCVideoViewObjectFit
                                    .RTCVideoViewObjectFitCover,
                                mirror: true),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorPallete.blackPrimary),
                            child: RTCVideoView(
                              remoteRenderer,
                              objectFit: RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover,
                            ),
                          ),
                        ),
                      ]),
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
                                          ColorPallete.greenPrimary,
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
                        Tooltip(
                          message: "Share Screen",
                          child: IconButton(
                              onPressed: () {
                                shareScreen();
                              },
                              icon: const CircleAvatar(
                                backgroundColor: ColorPallete.redPrimary,
                                child: Icon(
                                  Icons.screen_share,
                                ),
                              )),
                        ),
                        Tooltip(
                          message: "Toggle Camera",
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
  Future<void> shareScreen() async {
    await _webRtcService.shareScreen();
  }

  void _toggleCamera() {
    setState(() {
      isCameraVisible = !isCameraVisible;
    });
    _webRtcService.toggleCamera(isCameraVisible);
  }
}
