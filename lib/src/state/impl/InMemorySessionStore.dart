import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/state/SessionRecord.dart';

import '../../SignalProtocolAddress.dart';
import '../SessionStore.dart';

class InMemorySessionStore extends SessionStore {
  var sessions = HashMap<SignalProtocolAddress, Uint8List>();

  InMemorySessionStore();

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    return sessions.containsKey(address);
  }

  @override
  void deleteAllSessions(String name) {
    for (var k in sessions.keys.toList()) {
      if (k.getName() == name) {
        sessions.remove(k);
      }
    }
  }

  @override
  void deleteSession(SignalProtocolAddress address) {
    sessions.remove(address);
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    var deviceIds = <int>[];

    for (var key in sessions.keys) {
      if (key.getName() == name && key.getDeviceId() != 1) {
        deviceIds.add(key.getDeviceId());
      }
    }

    return deviceIds;
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress remoteAddress) async {
    try {
      if (await containsSession(remoteAddress)) {
        return SessionRecord.fromSerialized(sessions[remoteAddress]!);
      } else {
        return SessionRecord();
      }
    } on IOException catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  void storeSession(SignalProtocolAddress address, SessionRecord record) {
    sessions[address] = record.serialize();
  }
}
