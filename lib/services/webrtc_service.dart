import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hackathon/services/websocket_service.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/user.dart' as user;

class WebRtcService {
  final WebsocketService websocketService;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  final Map<String, dynamic> _configuration = {
    'sdpSemantics': 'unified-plan',
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'}
    ]
  };

  StreamSubscription? _callStreamSub;
  Function(MediaStream stream)? onLocalStream;
  Function(MediaStream stream)? onRemoteStream;
  Function(MediaStream? stream)? onLocalScreenStream;
  Function(MediaStream? stream)? onRemoteScreenStream;
  Function()? onCallEnded;

  String? _currentRoomId;
  List<String>? _targetUserIds;

  MediaStream? _localScreenStream;
  MediaStream? _remoteScreenStream;
  RTCRtpSender? _screenVideoSender;

  bool get isCameraEnabled {
    if (_localStream == null) return false;
    final videoTracks = _localStream!.getVideoTracks();
    return videoTracks.isNotEmpty && videoTracks.first.enabled;
  }

  MediaStream? get localStream => _localStream;
  MediaStream? get remoteStream => _remoteStream;
  MediaStream? get localScreenStream => _localScreenStream;
  MediaStream? get remoteScreenStream => _remoteScreenStream;
  String? get currentRoomId => _currentRoomId;
  List<String>? get targetUserIds => _targetUserIds;

  bool get isScreenSharing => _localScreenStream != null;

  WebRtcService({required this.websocketService}) {
    _callStreamSub = websocketService.callStream.listen(_handleSignalingMessage);
  }

  void dispose() {
    _callStreamSub?.cancel();
    _endCall();
  }

  Map<String, dynamic>? _pendingOffer;
  final List<RTCIceCandidate> _pendingIceCandidates = [];
  bool _hasRemoteDescription = false;

  Future<void> startCall(String roomId, {bool isCaller = false, List<String>? targetUserIds}) async {
    if (_peerConnection != null) {
      debugPrint("WebRtcService: Call already active, triggering stream callbacks...");
      if (_localStream != null && onLocalStream != null) {
        onLocalStream!(_localStream!);
      }
      if (_localScreenStream != null && onLocalScreenStream != null) {
        onLocalScreenStream!(_localScreenStream);
      }
      if (_remoteStream != null && onRemoteStream != null) {
        onRemoteStream!(_remoteStream!);
      }
      if (_remoteScreenStream != null && onRemoteScreenStream != null) {
        onRemoteScreenStream!(_remoteScreenStream);
      }
      return;
    }

    _currentRoomId = roomId;
    _targetUserIds = targetUserIds;

    try {
      _localStream = await navigator.mediaDevices.getUserMedia({
        'video': true,
        'audio': true,
      });
    } catch (e) {
      debugPrint("WebRtcService: Unable to get local media with video/audio: $e");
      try {
        _localStream = await navigator.mediaDevices.getUserMedia({
          'video': false,
          'audio': true,
        });
      } catch (ae) {
        debugPrint("WebRtcService: Unable to get local media audio-only fallback: $ae");
      }
    }
    
    if (_localStream != null && onLocalStream != null) {
      onLocalStream!(_localStream!);
    }

    _hasRemoteDescription = false;
    _peerConnection = await createPeerConnection(_configuration);

    _peerConnection?.onIceConnectionState = (state) {
      debugPrint("WebRtcService: ICE Connection State changed to: $state");
    };

    _peerConnection?.onConnectionState = (state) {
      debugPrint("WebRtcService: Connection State changed to: $state");
    };

    _peerConnection?.onSignalingState = (state) {
      debugPrint("WebRtcService: Signaling State changed to: $state");
    };

    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });
    }

    _peerConnection?.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        final stream = event.streams[0];
        debugPrint("WebRtcService: Received remote track ${event.track.kind} with stream id: ${stream.id}");
        
        if (_remoteStream == null) {
          _remoteStream = stream;
          if (onRemoteStream != null) {
            onRemoteStream!(_remoteStream!);
          }
        } else if (stream.id == _remoteStream!.id) {
          if (onRemoteStream != null) {
            onRemoteStream!(_remoteStream!);
          }
        } else {
          _remoteScreenStream = stream;
          if (onRemoteScreenStream != null) {
            onRemoteScreenStream!(_remoteScreenStream);
          }
          
          event.track.onEnded = () {
            _remoteScreenStream = null;
            if (onRemoteScreenStream != null) {
              onRemoteScreenStream!(null);
            }
          };
          event.track.onMute = () {
            _remoteScreenStream = null;
            if (onRemoteScreenStream != null) {
              onRemoteScreenStream!(null);
            }
          };
        }
      }
    };

    _peerConnection?.onIceCandidate = (candidate) {
      _sendSignalingMessage('ice_candidate', {
        'candidate': candidate.toMap(),
        'room_id': roomId,
      });
    };

    if (isCaller) {
      final offer = await _peerConnection?.createOffer();
      if (offer != null) {
        await _peerConnection?.setLocalDescription(offer);
        
        final userModel = getIt<user.User>().user;
        _sendSignalingMessage('call_offer', {
          'offer': offer.toMap(),
          'room_id': roomId,
          'calling_id': userModel?.id,
          'calling_first_name': userModel?.firstName,
          'calling_last_name': userModel?.lastName,
        });
      }
    } else if (_pendingOffer != null) {
      // We had a pending offer for this room, process it now
      final offerData = _pendingOffer!;
      _pendingOffer = null;
      await _processOffer(offerData, roomId);
    }
  }

  Future<void> _processOffer(Map<String, dynamic> offerData, String roomId) async {
    if (_peerConnection == null) return;
    final sigState = _peerConnection!.signalingState;
    if (sigState == RTCSignalingState.RTCSignalingStateClosed) {
      return;
    }
    if (sigState != null && sigState != RTCSignalingState.RTCSignalingStateStable) {
      debugPrint("WebRtcService: Ignoring offer because signaling state is not stable (current state: $sigState)");
      return;
    }

    _hasRemoteDescription = false;
    final remoteOffer = RTCSessionDescription(offerData['sdp'], offerData['type']);
    await _peerConnection?.setRemoteDescription(remoteOffer);
    _hasRemoteDescription = true;
    _processPendingIceCandidates();

    final answer = await _peerConnection?.createAnswer();
    if (answer != null) {
      await _peerConnection?.setLocalDescription(answer);
      _sendSignalingMessage('call_answer', {
        'answer': answer.toMap(),
        'room_id': roomId,
      });
    }
  }

  Future<void> _handleSignalingMessage(dynamic data) async {
    if (data == null || data is! Map<String, dynamic>) return;
    
    final type = data['type'];
    final roomId = data['room_id'];
    
    debugPrint("WebRtcService: Received signaling message '$type' for room: $roomId. Connection state: ${_peerConnection?.connectionState}, Signaling state: ${_peerConnection?.signalingState}, _hasRemoteDescription: $_hasRemoteDescription");

    if (_currentRoomId != null && roomId != _currentRoomId) {
      return; // Ignore messages for other rooms if currently in a call
    }

    try {
      if (type == 'call_offer') {
        final offerData = data['offer'];
        if (_peerConnection == null) {
          _pendingOffer = offerData;
        } else {
          await _processOffer(offerData, roomId);
        }
      } else if (type == 'call_answer') {
        if (_peerConnection == null) return;
        final sigState = _peerConnection!.signalingState;
        if (sigState != null && sigState != RTCSignalingState.RTCSignalingStateHaveLocalOffer) {
          debugPrint("WebRtcService: Ignoring call_answer because signaling state is not haveLocalOffer (current state: $sigState)");
          return;
        }
        _hasRemoteDescription = false;
        final answerData = data['answer'];
        final remoteAnswer = RTCSessionDescription(answerData['sdp'], answerData['type']);
        await _peerConnection?.setRemoteDescription(remoteAnswer);
        _hasRemoteDescription = true;
        _processPendingIceCandidates();
      } else if (type == 'ice_candidate') {
        final candidateData = data['candidate'];
        final candidate = RTCIceCandidate(
          candidateData['candidate'],
          candidateData['sdpMid'],
          candidateData['sdpMLineIndex'],
        );
        if (_peerConnection == null || !_hasRemoteDescription) {
          _pendingIceCandidates.add(candidate);
        } else {
          await _peerConnection?.addCandidate(candidate);
        }
      } else if (type == 'call_ended' || type == 'call_rejected') {
        _endCall();
        if (onCallEnded != null) onCallEnded!();
      }
    } catch (e) {
      debugPrint("WebRtcService Error handling $type: $e");
    }
  }

  void endCall() {
    if (_currentRoomId != null) {
      _sendSignalingMessage('call_ended', {
        'room_id': _currentRoomId,
      });
    }
    _endCall();
  }

  void _endCall() {
    _peerConnection?.close();
    _peerConnection = null;

    _localStream?.getTracks().forEach((track) {
      track.stop();
    });
    _localStream?.dispose();
    _localStream = null;

    _localScreenStream?.getTracks().forEach((track) {
      track.stop();
    });
    _localScreenStream?.dispose();
    _localScreenStream = null;
    _screenVideoSender = null;

    _remoteStream?.dispose();
    _remoteStream = null;

    _remoteScreenStream?.dispose();
    _remoteScreenStream = null;

    if (onLocalScreenStream != null) {
      onLocalScreenStream!(null);
    }
    if (onRemoteScreenStream != null) {
      onRemoteScreenStream!(null);
    }

    _currentRoomId = null;
    _pendingIceCandidates.clear();
    _hasRemoteDescription = false;
    _pendingOffer = null;
  }

  Future<void> _processPendingIceCandidates() async {
    if (_peerConnection != null) {
      for (var candidate in _pendingIceCandidates) {
        await _peerConnection?.addCandidate(candidate);
      }
      _pendingIceCandidates.clear();
    }
  }

  Future<void> toggleCamera([bool? isVisible]) async {
    if (_localStream == null) {
      try {
        _localStream = await navigator.mediaDevices.getUserMedia({
          'video': true,
          'audio': true,
        });
        if (onLocalStream != null) {
          onLocalStream!(_localStream!);
        }
        if (_peerConnection != null) {
          _localStream!.getTracks().forEach((track) {
            _peerConnection?.addTrack(track, _localStream!);
          });
          await _renegotiate();
        }
      } catch (e) {
        debugPrint("WebRtcService: Error toggling camera on: $e");
      }
      return;
    }
    
    final videoTracks = _localStream!.getVideoTracks();
    if (videoTracks.isNotEmpty) {
      final track = videoTracks.first;
      track.enabled = isVisible ?? !track.enabled;
    } else {
      try {
        final videoStream = await navigator.mediaDevices.getUserMedia({'video': true});
        final videoTrack = videoStream.getVideoTracks().first;
        _localStream!.addTrack(videoTrack);
        if (onLocalStream != null) {
          onLocalStream!(_localStream!);
        }
        if (_peerConnection != null) {
          await _peerConnection!.addTrack(videoTrack, _localStream!);
          await _renegotiate();
        }
      } catch (e) {
        debugPrint("WebRtcService: Error adding video track: $e");
      }
    }
  }

  Future<void> shareScreen() => toggleScreenShare();

  Future<void> toggleScreenShare() async {
    if (_localScreenStream != null) {
      await _stopScreenShare();
    } else {
      await _startScreenShare();
    }
  }

  Future<void> _startScreenShare() async {
    if (_peerConnection == null) return;
    try {
      _localScreenStream = await navigator.mediaDevices.getDisplayMedia({
        'video': true,
        'audio': false,
      });

      final videoTrack = _localScreenStream!.getVideoTracks().first;
      
      if (onLocalScreenStream != null) {
        onLocalScreenStream!(_localScreenStream);
      }

      _screenVideoSender = await _peerConnection!.addTrack(videoTrack, _localScreenStream!);

      videoTrack.onEnded = () {
        _stopScreenShare();
      };
      
      await _renegotiate();
    } catch (e) {
      debugPrint('Error starting screen share: $e');
    }
  }

  Future<void> _stopScreenShare() async {
    if (_localScreenStream == null) return;

    final tracks = _localScreenStream!.getTracks();
    for (var track in tracks) {
      track.stop();
    }
    _localScreenStream?.dispose();
    _localScreenStream = null;

    if (onLocalScreenStream != null) {
      onLocalScreenStream!(null);
    }

    if (_peerConnection != null && _screenVideoSender != null) {
      try {
        await _peerConnection!.removeTrack(_screenVideoSender!);
      } catch (e) {
        debugPrint("Error removing screen track: $e");
      }
      _screenVideoSender = null;
      await _renegotiate();
    }
  }

  Future<void> _renegotiate() async {
    if (_peerConnection == null || _currentRoomId == null) return;
    try {
      _hasRemoteDescription = false;
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      
      final userModel = getIt<user.User>().user;
      _sendSignalingMessage('call_offer', {
        'offer': offer.toMap(),
        'room_id': _currentRoomId,
        'calling_id': userModel?.id,
        'calling_first_name': userModel?.firstName,
        'calling_last_name': userModel?.lastName,
        'renegotiate': true,
      });
    } catch (e) {
      debugPrint('Error during WebRTC renegotiation: $e');
    }
  }

  void _sendSignalingMessage(String type, Map<String, dynamic> payload) {
    websocketService.sendWebSocketMessage({
      'type': type,
      if (_targetUserIds != null) 'target_user_ids': _targetUserIds,
      ...payload,
    });
  }
}
