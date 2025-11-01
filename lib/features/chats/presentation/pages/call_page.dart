import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/chats/data/data_sources/signaling.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CallPage extends StatefulWidget {
  static const routePath = '/call';
  final ChatEntity chatEntity;
  final bool isCalling;
  const CallPage({super.key, required this.chatEntity, required this.isCalling});
  @override
  _WebRTCClientState createState() => _WebRTCClientState();
}

class _WebRTCClientState extends State<CallPage> {
  late WebSocketChannel signalingServer;

  late MediaStream localStream;
  MediaStream? remoteStream;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool inCall = false;
  MediaStreamTrack? _localVideoTrack;
  WebRTCSignaling webRTCSignaling = WebRTCSignaling();
  RTCPeerConnection? peerConnection;
  bool isCameraVisible = true;
  // ICE Servers configuration
  final Map<String, dynamic> configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'}
    ]
  };
  final List<RTCIceCandidate> _candidateQueue = [];
  @override
  void initState() {
    super.initState();

    _initializeRenderers();

    if (widget.isCalling) {
      startWebRTC();
    }
  }

 

  Future<void> _initializeRenderers() async {
    remoteStream = await createLocalMediaStream('remote');
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<void> startWebRTC() async {
    if (inCall) {
      return;
    }
    inCall = true;
    try {
      // Get user media (local stream)
      localStream = await navigator.mediaDevices
          .getUserMedia({'video': true, 'audio': true});
      setState(() {
        localRenderer.srcObject = localStream;
      });
      _localVideoTrack = localStream.getVideoTracks().first;
      // Initialize RTCPeerConnection
      peerConnection = await createPeerConnection(configuration);

      signalingServer = WebSocketChannel.connect(Uri.parse(
          ApiConstants.callingEndpoint + widget.chatEntity.id.toString()));
      signalingServer.stream.listen(_onSignalingMessage);

      // Add local stream tracks to peer connection
      localStream.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream);
      });

      // Handle remote tracks
      peerConnection?.onTrack = (event) {
        remoteStream?.addTrack(event.track);
        remoteRenderer.srcObject = remoteStream;
      };

      // Handle ICE candidates
      peerConnection?.onIceCandidate = (candidate) {
        signalingServer.sink.add(jsonEncode({
          'type': 'candidate',
          'candidate': candidate.toMap(),
        }));
            };

      // Create an offer and send it to the signaling server

      if (!widget.isCalling) {
        final offer = await peerConnection?.createOffer();
        await peerConnection?.setLocalDescription(offer!);
        webRTCSignaling.createOffer(
            offer.toString(), widget.chatEntity.id, widget.chatEntity);

        signalingServer.sink.add(jsonEncode({
          'type': 'offer',
          'offer': offer!.toMap(),
        }));
      }
    } catch (e) {
      print('Error starting WebRTC: $e');
    }
  }

  endWebRTCcall() async {
    await peerConnection?.close();
    peerConnection = null;
    localStream.getTracks().forEach((track) {
      track.stop();
    });
    signalingServer.sink.close();
    localStream.dispose();
    remoteStream?.dispose();
    localRenderer.dispose();
    remoteRenderer.dispose();
    localStream.dispose();
    signalingServer.sink.close();
    await webRTCSignaling.endCall(widget.chatEntity.id.toString());
    inCall = false;
  }

  // Handle incoming signaling messages
  Future<void> _onSignalingMessage(dynamic message) async {
    try {
      final Map<String, dynamic> data = jsonDecode(message);

      switch (data['type']) {
        case 'offer':
          final remoteOffer = RTCSessionDescription(
              data['offer']['sdp'], data['offer']['type']);
          await peerConnection?.setRemoteDescription(remoteOffer);

          // Create an answer
          final RTCSessionDescription? answer =
              await peerConnection?.createAnswer();

          await peerConnection?.setLocalDescription(answer!);
          signalingServer.sink.add(jsonEncode({
            'type': 'answer',
            'answer': answer!.toMap(),
          }));

          break;
        case 'answer':
          final remoteAnswer = RTCSessionDescription(
              data['answer']['sdp'], data['answer']['type']);
          await peerConnection?.setRemoteDescription(remoteAnswer);
          break;

        case 'candidate':
          final candidate = RTCIceCandidate(
            data['candidate']['candidate'],
            data['candidate']['sdpMid'],
            data['candidate']['sdpMLineIndex'],
          );

          await peerConnection?.addCandidate(candidate);

          break;

        default:
          print('Unknown message type: ${data['type']}');
      }
    } catch (e) {
      print('Error handling signaling message: $e');
    }
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
                                      webRTCSignaling.endCall(
                                          widget.chatEntity.id.toString());
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
  try {
    // Replace the current media stream with the screen share stream
    final MediaStream screenStream = await navigator.mediaDevices.getDisplayMedia({
      'video': true,
      'audio': true,
    });

    // Update the UI to show the shared screen in the local video renderer
    setState(() {
      _localVideoTrack?.enabled = false; 
      localRenderer.srcObject = screenStream;
    });

    // Replace the video track in the peer connection
    final videoTrack = screenStream.getVideoTracks().first;
   (await peerConnection?.getSenders())!.forEach((sender) async {
      if (sender.track?.kind == 'video') {
        await sender.replaceTrack(videoTrack);
      }
    });
    
  } catch (e) {
    print('Error sharing screen: $e');
  }
}


  void _toggleCamera() {
    if (isCameraVisible) {
      // Stop the camera (video track)
      _localVideoTrack?.enabled = false;
    } else {
      // Start the camera (video track)
      _localVideoTrack?.enabled = true;
    }

    setState(() {
      isCameraVisible = !isCameraVisible;
    });
  }
}
