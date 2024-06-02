

// import 'dart:convert';
// import 'dart:async';
// import 'package:auto_route/auto_route.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:logger/logger.dart';
// import 'package:permission_handler/permission_handler.dart';
// // import 'package:reshuffle/presentation/app/core/common/check_permission.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// enum SignalingState {
//   connectionOpen,
//   connectionClosed,
//   connectionError,
// }

// enum CallState {
//   callStateNew,
//   videoCallStateRinging,
//   callStateInvite,
//   callStateConnected,
//   callStateBye,
// }

// enum VideoSource {
//   camera,
//   screen,
// }

// class Session {
//   Session({required this.sid, required this.pid});
//   String pid;
//   String sid;
//   RTCPeerConnection? pc;
//   RTCDataChannel? dc;
//   List<RTCIceCandidate> remoteCandidates = [];
// }

// class Signaling {
//   Signaling(this.userFromId, this.callId, this.context);

//   // JsonEncoder _encoder = JsonEncoder();
//   JsonDecoder decoder = const JsonDecoder();
//   final String selfId = FirebaseAuth.instance.currentUser!.uid;
//   final String userFromId;
//   final String callId;
//   // SimpleWebSocket? _socket;
//   BuildContext? context;
//   WebSocketChannel? _socket;
//   Map<String, Session> _sessions = {};
//   MediaStream? _localStream;
//   List<MediaStream> remoteStreams = <MediaStream>[];
//   List<RTCRtpSender> senders = <RTCRtpSender>[];
//   VideoSource _videoSource = VideoSource.camera;

//   Function(SignalingState state)? onSignalingStateChange;
//   Function(Session session, CallState state)? onCallStateChange;
//   Function(MediaStream stream)? onLocalStream;
//   Function(Session session, MediaStream stream)? onAddRemoteStream;
//   Function(Session session, MediaStream stream)? onRemoveRemoteStream;
//   Function(Session session, RTCDataChannel dc, RTCDataChannelMessage data)?
//       onDataChannelMessage;
//   Function(Session session, RTCDataChannel dc)? onDataChannel;

//   String get sdpSemantics => 'unified-plan';

//   final Map<String, dynamic> _iceServers = {
//     'iceServers': [
//       {'url': 'stun:stun.l.google.com:19302'},
//       {
//         'url': 'turn:webrtc.sammrafi.com:3478?transport=tcp',
//         'username': 'sammrafi',
//         'credential': 'sammrafi'
//       },
//     ]
//   };

//   final Map<String, dynamic> _config = {
//     'mandatory': {},
//     'optional': [
//       {'DtlsSrtpKeyAgreement': true},
//     ]
//   };

//   final Map<String, dynamic> _dcConstraints = {
//     'mandatory': {
//       'OfferToReceiveAudio': false,
//       'OfferToReceiveVideo': false,
//     },
//     'optional': [],
//   };

//   close() async {
//     await _cleanSessions();
//     _socket!.sink.close();
//   }

//   void switchCamera() {
//     if (_localStream != null) {
//       if (_videoSource != VideoSource.camera) {
//         for (var sender in senders) {
//           if (sender.track!.kind == 'video') {
//             sender.replaceTrack(_localStream!.getVideoTracks()[0]);
//           }
//         }
//         _videoSource = VideoSource.camera;
//         onLocalStream?.call(_localStream!);
//       } else {
//         Helper.switchCamera(_localStream!.getVideoTracks()[0]);
//       }
//     }
//   }

//   void switchToScreenSharing(MediaStream stream) {
//     if (_localStream != null && _videoSource != VideoSource.screen) {
//       for (var sender in senders) {
//         if (sender.track!.kind == 'video') {
//           sender.replaceTrack(stream.getVideoTracks()[0]);
//         }
//       }
//       onLocalStream?.call(stream);
//       _videoSource = VideoSource.screen;
//     }
//   }

//   void muteMic() {
//     if (_localStream != null) {
//       bool enabled = _localStream!.getAudioTracks()[0].enabled;
//       _localStream!.getAudioTracks()[0].enabled = !enabled;
//     }
//   }

//   void speaker(speaker) {
//     if (_localStream != null) {
//       _localStream!.getAudioTracks()[0].enableSpeakerphone(speaker);
//     }
//   }

//   void invite(String peerId, String media, bool useScreen) async {
//     var sessionId = '$selfId-$peerId';
//     Session session = await _createSession(null,
//         peerId: peerId,
//         sessionId: sessionId,
//         media: media,
//         screenSharing: useScreen);
//     _sessions[sessionId] = session;
//     if (media == 'data') {
//       _createDataChannel(session);
//     }
//     _createOffer(session, media);
//     onCallStateChange?.call(session, CallState.callStateNew);
//     onCallStateChange?.call(session, CallState.callStateInvite);
//   }

//   void bye(String sessionId) {
//     _socket!.sink.add(jsonEncode({
//       'request': 'bye',
//       'session_id': sessionId,
//       'user_from': selfId,
//     }));
//     var sess = _sessions[sessionId];
//     if (sess != null) {
//       _closeSession(sess);
//     }
//   }

//   void informReady() async {
//     Logger().wtf("Ready");
//     _socket!.sink.add(jsonEncode({
//       'request': 'user_is_ready',
//       'user_from': selfId,
//     }));
//   }

//   void accept(String sessionId, String media) {
//     var session = _sessions[sessionId];
//     if (session == null) {
//       return;
//     }
//     _createAnswer(session, media);
//   }

//   void reject(String sessionId) {
//     var session = _sessions[sessionId];
//     if (session == null) {
//       return;
//     }
//     bye(session.sid);
//   }

//   void cancel({required String userId}) {
//     _socket!.sink.add(jsonEncode({
//       'request': 'bye',
//       'user_from': userId,
//     }));
//   }

//   void onMessage(message) async {
//     Map<String, dynamic> mapData = message;
//     var callRequest = mapData['call_request'];
//     Logger().w(callRequest);
//     if (callRequest['request'] == "user_is_ready" &&
//         callRequest['user_from'] != selfId) {
//       Logger().wtf("This is called");
//       invite(userFromId, 'video', false);
//     } else if (callRequest['request'] == "offer" &&
//         callRequest['user_from'] != selfId) {
//       var peerId = callRequest['user_from'];
//       var description = callRequest['description'];
//       var media = callRequest['media'];
//       var sessionId = callRequest['session_id'];
//       var session = _sessions[sessionId];
//       var newSession = await _createSession(session,
//           peerId: peerId,
//           sessionId: sessionId,
//           media: media,
//           screenSharing: false);
//       _sessions[sessionId] = newSession;
//       await newSession.pc?.setRemoteDescription(
//           RTCSessionDescription(description['sdp'], description['type']));
//       // await _createAnswer(newSession, media);
//       // Logger().wtf("Get Offer", newSession);
//       if (newSession.remoteCandidates.isNotEmpty) {
//         newSession.remoteCandidates.forEach((candidate) async {
//           await newSession.pc?.addCandidate(candidate);
//         });
//         newSession.remoteCandidates.clear();
//       }

//       onCallStateChange?.call(newSession, CallState.callStateNew);
//       if (media == "video") {
//         onCallStateChange?.call(newSession, CallState.videoCallStateRinging);
//       }
//     } else if (callRequest['request'] == "answer" &&
//         callRequest['user_from'] != selfId) {
//       var description = callRequest['description'];
//       var sessionId = callRequest['session_id'];
//       var session = _sessions[sessionId];
//       session?.pc?.setRemoteDescription(
//           RTCSessionDescription(description['sdp'], description['type']));
//       onCallStateChange?.call(session!, CallState.callStateConnected);
//     } else if (callRequest['request'] == "candidate" &&
//         callRequest['user_from'] != selfId) {
//       var peerId = callRequest['user_from'];
//       var candidateMap = callRequest['candidate'];
//       var sessionId = callRequest['session_id'];
//       var session = _sessions[sessionId];
//       RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
//           candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);

//       if (session != null) {
//         if (session.pc != null) {
//           await session.pc?.addCandidate(candidate);
//         } else {
//           session.remoteCandidates.add(candidate);
//         }
//       } else {
//         _sessions[sessionId] = Session(pid: peerId, sid: sessionId)
//           ..remoteCandidates.add(candidate);
//       }
//     } else if (callRequest['request'] == 'bye') {
//       var sessionId = callRequest['session_id'];
//       if (sessionId == null) {
//         _cleanSessions();
//         onCallStateChange?.call(
//             Session(sid: 'sid', pid: 'pid'), CallState.callStateBye);
//       }
//       var session = _sessions.remove(sessionId);
//       if (session != null) {
//         onCallStateChange?.call(session, CallState.callStateBye);
//         _closeSession(session);
//       }
//     }
//   }

//   Future<void> connect() async {
//     _socket = IOWebSocketChannel.connect(
//         Uri.parse('wss://shop.sammrafi.com/ws/webrtc/$callId/'));
//     // Logger().wtf("Socket Url: ", callId);
//     onSignalingStateChange?.call(SignalingState.connectionOpen);
//     _socket!.sink.add(jsonEncode({
//       'request': 'new',
//       'name': await FirebaseAuth.instance.currentUser!.displayName,
//       'id': selfId,
//     }));

//     _socket!.stream.listen((message) {
//       Logger().wtf('Received data: $message');
//       onMessage(decoder.convert(message));
//     }, onDone: () {
//       Logger().w("The Websocket is done:");
//     }, onError: (e) {
//       Logger().e("The Websocket has some error",error: e);
//     });

//     // _socket?.onClose = (int? code, String? reason) {
//     //   Logger().e('Closed by server [$code => $reason]!');
//     //   onSignalingStateChange?.call(SignalingState.ConnectionClosed);
//     // };

//     // await _socket?.connect();
//   }

//   Future<MediaStream> createStream(String media, bool userScreen,
//       {BuildContext? context}) async {
//     final Map<String, dynamic> mediaConstraints = {
//       'audio': userScreen ? false : true,
//       'video': userScreen
//           ? true
//           : {
//               'mandatory': {
//                 'minWidth':
//                     '1280', // Provide your own width, height and frame rate here
//                 'minHeight': '720',
//                 'minFrameRate': '30',
//               },
//               'facingMode': 'user',
//               'optional': [],
//             }
//     };
//     late MediaStream stream;
//     if (userScreen) {
//       // if (WebRTC.platformIsDesktop) {
//       //   final source = await showDialog<DesktopCapturerSource>(
//       //     context: context!,
//       //     builder: (context) => ScreenSelectDialog(),
//       //   );
//       //   stream = await navigator.mediaDevices.getDisplayMedia(<String, dynamic>{
//       //     'video': source == null
//       //         ? true
//       //         : {
//       //       'deviceId': {'exact': source.id},
//       //       'mandatory': {'frameRate': 30.0}
//       //     }
//       //   });
//       // } else {
//       stream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
//       // }
//     } else {
//       try {
//         stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//       } catch (e) {
//         if (e.toString() ==
//             "Unable to getUserMedia: getUserMedia(): DOMException, NotAllowedError") {
//           // checkPermission(this.context!, Permission.camera, false);
//           // checkPermission(this.context!, Permission.microphone, false);
//         }
//       }
//     }

//     onLocalStream?.call(stream);
//     return stream;
//   }

//   Future<Session> _createSession(
//     Session? session, {
//     required String peerId,
//     required String sessionId,
//     required String media,
//     required bool screenSharing,
//   }) async {
//     var newSession = session ?? Session(sid: sessionId, pid: peerId);
//     if (media != 'data') {
//       _localStream = await createStream(media, screenSharing, context: context);
//       _localStream!
//           .getAudioTracks()[0]
//           .enableSpeakerphone(true); //true value is loud speaker
//     }

//     RTCPeerConnection pc = await createPeerConnection({
//       ..._iceServers,
//       ...{'sdpSemantics': sdpSemantics}
//     }, _config);
//     if (media != 'data') {
//       switch (sdpSemantics) {
//         case 'plan-b':
//           pc.onAddStream = (MediaStream stream) {
//             onAddRemoteStream?.call(newSession, stream);
//             remoteStreams.add(stream);
//           };
//           await pc.addStream(_localStream!);
//           break;
//         case 'unified-plan':
//           // Unified-Plan
//           pc.onTrack = (event) {
//             if (event.track.kind == 'video') {
//               onAddRemoteStream?.call(newSession, event.streams[0]);
//             }
//           };
//           _localStream!.getTracks().forEach((track) async {
//             senders.add(await pc.addTrack(track, _localStream!));
//           });
//           break;
//       }

//       // Unified-Plan: Simuclast
//       /*
//       await pc.addTransceiver(
//         track: _localStream.getAudioTracks()[0],
//         init: RTCRtpTransceiverInit(
//             direction: TransceiverDirection.SendOnly, streams: [_localStream]),
//       );

//       await pc.addTransceiver(
//         track: _localStream.getVideoTracks()[0],
//         init: RTCRtpTransceiverInit(
//             direction: TransceiverDirection.SendOnly,
//             streams: [
//               _localStream
//             ],
//             sendEncodings: [
//               RTCRtpEncoding(rid: 'f', active: true),
//               RTCRtpEncoding(
//                 rid: 'h',
//                 active: true,
//                 scaleResolutionDownBy: 2.0,
//                 maxBitrate: 150000,
//               ),
//               RTCRtpEncoding(
//                 rid: 'q',
//                 active: true,
//                 scaleResolutionDownBy: 4.0,
//                 maxBitrate: 100000,
//               ),
//             ]),
//       );*/
//       /*
//         var sender = pc.getSenders().find(s => s.track.kind == "video");
//         var parameters = sender.getParameters();
//         if(!parameters)
//           parameters = {};
//         parameters.encodings = [
//           { rid: "h", active: true, maxBitrate: 900000 },
//           { rid: "m", active: true, maxBitrate: 300000, scaleResolutionDownBy: 2 },
//           { rid: "l", active: true, maxBitrate: 100000, scaleResolutionDownBy: 4 }
//         ];
//         sender.setParameters(parameters);
//       */
//     }
//     pc.onIceCandidate = (candidate) async {
//       if (candidate == null) {
//         Logger().wtf('onIceCandidate: complete!');
//         return;
//       }
//       // This delay is needed to allow enough time to try an ICE candidate
//       // before skipping to the next one. 1 second is just an heuristic value
//       // and should be thoroughly tested in your own environment.
//       await Future.delayed(
//           const Duration(seconds: 1),
//           () => _socket!.sink.add(jsonEncode({
//                 'request': 'candidate',
//                 'to': peerId,
//                 'user_from': selfId,
//                 'candidate': {
//                   'sdpMLineIndex': candidate.sdpMLineIndex,
//                   'sdpMid': candidate.sdpMid,
//                   'candidate': candidate.candidate,
//                 },
//                 'session_id': sessionId,
//               })));
//     };

//     pc.onIceConnectionState = (state) {};

//     pc.onRemoveStream = (stream) {
//       onRemoveRemoteStream?.call(newSession, stream);
//       remoteStreams.removeWhere((it) {
//         return (it.id == stream.id);
//       });
//     };

//     pc.onDataChannel = (channel) {
//       _addDataChannel(newSession, channel);
//     };

//     newSession.pc = pc;
//     return newSession;
//   }

//   void _addDataChannel(Session session, RTCDataChannel channel) {
//     channel.onDataChannelState = (e) {};
//     channel.onMessage = (RTCDataChannelMessage data) {
//       onDataChannelMessage?.call(session, channel, data);
//     };
//     session.dc = channel;
//     onDataChannel?.call(session, channel);
//   }

//   Future<void> _createDataChannel(Session session,
//       {label = 'fileTransfer'}) async {
//     RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
//       ..maxRetransmits = 30;
//     RTCDataChannel channel =
//         await session.pc!.createDataChannel(label, dataChannelDict);
//     _addDataChannel(session, channel);
//   }

//   Future<void> _createOffer(Session session, String media) async {
//     try {
//       RTCSessionDescription s =
//           await session.pc!.createOffer(media == 'data' ? _dcConstraints : {});
//       // Logger().w("Get Sending RTC Description", _socket!.ready);
//       await session.pc!.setLocalDescription(_fixSdp(s));
//       _socket!.sink.add(jsonEncode({
//         'request': "offer",
//         'to': session.pid,
//         'user_from': selfId,
//         'description': {'sdp': s.sdp, 'type': s.type},
//         'session_id': session.sid,
//         'media': media,
//       }));
//     } catch (e) {
//       Logger().e(e.toString());
//     }
//   }

//   RTCSessionDescription _fixSdp(RTCSessionDescription s) {
//     var sdp = s.sdp;
//     s.sdp =
//         sdp!.replaceAll('profile-level-id=640c1f', 'profile-level-id=42e032');
//     return s;
//   }

//   Future<void> _createAnswer(Session session, String media) async {
//     try {
//       Logger().w("This Session Create Answer");
//       RTCSessionDescription s =
//           await session.pc!.createAnswer(media == 'data' ? _dcConstraints : {});
//       // Logger().wtf("Get Answer Description", s.sdp);
//       await session.pc!.setLocalDescription(_fixSdp(s));
//       _socket!.sink.add(jsonEncode({
//         'request': "answer",
//         'to': session.pid,
//         'user_from': selfId,
//         'description': {'sdp': s.sdp, 'type': s.type},
//         'session_id': session.sid,
//       }));
//     } catch (e) {
//       Logger().e(e.toString());
//     }
//   }

//   // _send(event, data) {
//   //   var request = Map();
//   //   request["type"] = event;
//   //   request["data"] = data;
//   //   Logger().w("Send Data", request);
//   //   _socket!.sink.add(jsonEncode(request));
//   // }

//   Future<void> _cleanSessions() async {
//     if (_localStream != null) {
//       _localStream!.getTracks().forEach((element) async {
//         await element.stop();
//       });
//       await _localStream!.dispose();
//       _localStream = null;
//     }
//     _sessions.forEach((key, sess) async {
//       await sess.pc?.close();
//       await sess.dc?.close();
//     });
//     _sessions.clear();
//   }

//   void _closeSessionByPeerId(String peerId) {
//     var session;
//     _sessions.removeWhere((String key, Session sess) {
//       var ids = key.split('-');
//       session = sess;
//       return peerId == ids[0] || peerId == ids[1];
//     });
//     if (session != null) {
//       _closeSession(session);
//       onCallStateChange?.call(session, CallState.callStateBye);
//     }
//   }

//   Future<void> _closeSession(Session session) async {
//     _localStream?.getTracks().forEach((element) async {
//       await element.stop();
//     });
//     await _localStream?.dispose();
//     _localStream = null;

//     await session.pc?.close();
//     await session.dc?.close();
//     senders.clear();
//     _videoSource = VideoSource.camera;
//   }
// }
