import 'dart:async';
import 'dart:convert';
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
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'}
    ]
  };

  StreamSubscription? _callStreamSub;
  Function(MediaStream stream)? onLocalStream;
  Function(MediaStream stream)? onRemoteStream;
  Function()? onCallEnded;

  String? _currentRoomId;
  List<String>? _targetUserIds;

  WebRtcService({required this.websocketService}) {
    _callStreamSub = websocketService.callStream.listen(_handleSignalingMessage);
  }

  void dispose() {
    _callStreamSub?.cancel();
    _endCall();
  }

  Map<String, dynamic>? _pendingOffer;
  List<RTCIceCandidate> _pendingIceCandidates = [];
  bool _hasRemoteDescription = false;

  Future<void> startCall(String roomId, {bool isCaller = false, List<String>? targetUserIds}) async {
    _currentRoomId = roomId;
    _targetUserIds = targetUserIds;

    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });
    
    if (onLocalStream != null) {
      onLocalStream!(_localStream!);
    }

    _peerConnection = await createPeerConnection(_configuration);

    _localStream!.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
        if (onRemoteStream != null) {
          onRemoteStream!(_remoteStream!);
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

    _remoteStream?.dispose();
    _remoteStream = null;

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

  Future<void> toggleCamera(bool isVisible) async {
    if (_localStream == null) return;
    final videoTracks = _localStream!.getVideoTracks();
    if (videoTracks.isNotEmpty) {
      videoTracks.first.enabled = isVisible;
    }
  }

  Future<void> shareScreen() async {
    if (_peerConnection == null || _localStream == null) return;
    
    try {
      final MediaStream screenStream = await navigator.mediaDevices.getDisplayMedia({
        'video': true,
        'audio': true,
      });

      final videoTrack = screenStream.getVideoTracks().first;
      
      if (onLocalStream != null) {
        onLocalStream!(screenStream);
      }

      final senders = await _peerConnection!.getSenders();
      for (var sender in senders) {
        if (sender.track?.kind == 'video') {
          await sender.replaceTrack(videoTrack);
        }
      }
      
    } catch (e) {
      debugPrint('Error sharing screen: $e');
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
