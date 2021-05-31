import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/duplicate_message_exception.dart';
import 'package:libsignal_protocol_dart/src/identity_key.dart';
import 'package:libsignal_protocol_dart/src/identity_key_pair.dart';
import 'package:libsignal_protocol_dart/src/session_cipher.dart';
import 'package:libsignal_protocol_dart/src/signal_protocol_address.dart';
import 'package:libsignal_protocol_dart/src/ecc/curve.dart';
import 'package:libsignal_protocol_dart/src/ecc/ec_key_pair.dart';
import 'package:libsignal_protocol_dart/src/ecc/ec_public_key.dart';
import 'package:libsignal_protocol_dart/src/eq.dart';
import 'package:libsignal_protocol_dart/src/protocol/ciphertext_message.dart';
import 'package:libsignal_protocol_dart/src/protocol/signal_message.dart';
import 'package:libsignal_protocol_dart/src/ratchet/alice_signal_protocol_parameters.dart';
import 'package:libsignal_protocol_dart/src/ratchet/bob_signal_protocol_parameters.dart';
import 'package:libsignal_protocol_dart/src/ratchet/ratcheting_session.dart';
import 'package:libsignal_protocol_dart/src/state/session_record.dart';
import 'package:libsignal_protocol_dart/src/state/session_state.dart';
import 'package:optional/optional.dart';
import 'package:test/test.dart';

import 'test_in_memory_signal_protocol_store.dart';

Future<void> main() async {
  Future<void> runInteraction(
      SessionRecord aliceSessionRecord, SessionRecord bobSessionRecord) async {
    final aliceStore = TestInMemorySignalProtocolStore();
    final bobStore = TestInMemorySignalProtocolStore();

    await aliceStore.storeSession(
        SignalProtocolAddress('+14159999999', 1), aliceSessionRecord);
    await bobStore.storeSession(
        SignalProtocolAddress('+14158888888', 1), bobSessionRecord);

    final aliceCipher = SessionCipher.fromStore(
        aliceStore, SignalProtocolAddress('+14159999999', 1));
    final bobCipher = SessionCipher.fromStore(
        bobStore, SignalProtocolAddress('+14158888888', 1));

    final alicePlaintext =
        Uint8List.fromList(utf8.encode('This is a plaintext message.'));
    final message = await aliceCipher.encrypt(alicePlaintext);
    final bobPlaintext = await bobCipher
        .decryptFromSignal(SignalMessage.fromSerialized(message.serialize()));

    // ignore: avoid_dynamic_calls
    assert(eq(alicePlaintext, bobPlaintext));

    final bobReply =
        Uint8List.fromList(utf8.encode('This is a message from Bob.'));
    final reply = await bobCipher.encrypt(bobReply);
    final receivedReply = await aliceCipher
        .decryptFromSignal(SignalMessage.fromSerialized(reply.serialize()));

    // ignore: avoid_dynamic_calls
    assert(eq(bobReply, receivedReply));

    final aliceCiphertextMessages = <CiphertextMessage>[];
    final alicePlaintextMessages = <Uint8List>[];

    for (var i = 0; i < 50; i++) {
      alicePlaintextMessages
          .add(Uint8List.fromList(utf8.encode('смерть за смерть $i')));
      aliceCiphertextMessages.add(await aliceCipher
          .encrypt(Uint8List.fromList(utf8.encode('смерть за смерть $i'))));
    }

    var seed = DateTime.now().microsecondsSinceEpoch;

    aliceCiphertextMessages.shuffle(Random(seed));
    alicePlaintextMessages.shuffle(Random(seed));

    for (var i = 0; i < aliceCiphertextMessages.length / 2; i++) {
      final receivedPlaintext = bobCipher.decryptFromSignal(
          SignalMessage.fromSerialized(aliceCiphertextMessages[i].serialize()));
      // ignore: avoid_dynamic_calls
      assert(eq(receivedPlaintext, alicePlaintextMessages[i]));
    }

    final bobCiphertextMessages = <CiphertextMessage>[];
    final bobPlaintextMessages = <Uint8List>[];

    for (var i = 0; i < 20; i++) {
      bobPlaintextMessages
          .add(Uint8List.fromList(utf8.encode('смерть за смерть $i')));
      bobCiphertextMessages.add(await bobCipher
          .encrypt(Uint8List.fromList(utf8.encode('смерть за смерть $i'))));
    }

    seed = DateTime.now().millisecondsSinceEpoch;

    bobCiphertextMessages.shuffle(Random(seed));
    bobPlaintextMessages.shuffle(Random(seed));

    for (var i = 0; i < bobCiphertextMessages.length / 2; i++) {
      final receivedPlaintext = aliceCipher.decryptFromSignal(
          SignalMessage.fromSerialized(bobCiphertextMessages[i].serialize()));
      // ignore: avoid_dynamic_calls
      assert(eq(receivedPlaintext, bobPlaintextMessages[i]));
    }

    for (var i = aliceCiphertextMessages.length ~/ 2;
        i < aliceCiphertextMessages.length;
        i++) {
      final receivedPlaintext = bobCipher.decryptFromSignal(
          SignalMessage.fromSerialized(aliceCiphertextMessages[i].serialize()));
      // ignore: avoid_dynamic_calls
      assert(eq(receivedPlaintext, alicePlaintextMessages[i]));
    }

    for (var i = bobCiphertextMessages.length ~/ 2;
        i < bobCiphertextMessages.length;
        i++) {
      final receivedPlaintext = aliceCipher.decryptFromSignal(
          SignalMessage.fromSerialized(bobCiphertextMessages[i].serialize()));
      // ignore: avoid_dynamic_calls
      assert(eq(receivedPlaintext, bobPlaintextMessages[i]));
    }
  }

  void initializeSessionsV3(
      SessionState aliceSessionState, SessionState bobSessionState) {
    final aliceIdentityKeyPair = Curve.generateKeyPair();
    final aliceIdentityKey = IdentityKeyPair(
        IdentityKey(aliceIdentityKeyPair.publicKey),
        aliceIdentityKeyPair.privateKey);
    final aliceBaseKey = Curve.generateKeyPair();
    // ignore: unused_local_variable
    final aliceEphemeralKey = Curve.generateKeyPair();

    // ignore: unused_local_variable
    final alicePreKey = aliceBaseKey;

    final bobIdentityKeyPair = Curve.generateKeyPair();
    final bobIdentityKey = IdentityKeyPair(
        IdentityKey(bobIdentityKeyPair.publicKey),
        bobIdentityKeyPair.privateKey);
    final bobBaseKey = Curve.generateKeyPair();
    final bobEphemeralKey = bobBaseKey;

    // ignore: unused_local_variable
    final bobPreKey = Curve.generateKeyPair();

    final aliceParameters = AliceSignalProtocolParameters.newBuilder()
        .setOurBaseKey(aliceBaseKey)
        .setOurIdentityKey(aliceIdentityKey)
        .setTheirOneTimePreKey(const Optional<ECPublicKey>.empty())
        .setTheirRatchetKey(bobEphemeralKey.publicKey)
        .setTheirSignedPreKey(bobBaseKey.publicKey)
        .setTheirIdentityKey(bobIdentityKey.getPublicKey())
        .create();

    final bobParameters = BobSignalProtocolParameters.newBuilder()
        .setOurRatchetKey(bobEphemeralKey)
        .setOurSignedPreKey(bobBaseKey)
        .setOurOneTimePreKey(const Optional<ECKeyPair>.empty())
        .setOurIdentityKey(bobIdentityKey)
        .setTheirIdentityKey(aliceIdentityKey.getPublicKey())
        .setTheirBaseKey(aliceBaseKey.publicKey)
        .create();

    RatchetingSession.initializeSessionAlice(
        aliceSessionState, aliceParameters);
    RatchetingSession.initializeSessionBob(bobSessionState, bobParameters);
  }

  test('testBasicSessionV3', () {
    final aliceSessionRecord = SessionRecord();
    final bobSessionRecord = SessionRecord();

    initializeSessionsV3(
        aliceSessionRecord.sessionState, bobSessionRecord.sessionState);
    runInteraction(aliceSessionRecord, bobSessionRecord);
  });

  test('testMessageKeyLimits', () async {
    final aliceSessionRecord = SessionRecord();
    final bobSessionRecord = SessionRecord();

    initializeSessionsV3(
        aliceSessionRecord.sessionState, bobSessionRecord.sessionState);

    final aliceStore = TestInMemorySignalProtocolStore();
    final bobStore = TestInMemorySignalProtocolStore();

    await aliceStore.storeSession(
        SignalProtocolAddress('+14159999999', 1), aliceSessionRecord);
    await bobStore.storeSession(
        SignalProtocolAddress('+14158888888', 1), bobSessionRecord);

    final aliceCipher = SessionCipher.fromStore(
        aliceStore, SignalProtocolAddress('+14159999999', 1));
    final bobCipher = SessionCipher.fromStore(
        bobStore, SignalProtocolAddress('+14158888888', 1));

    final inflight = <CiphertextMessage>[];

    for (var i = 0; i < 2010; i++) {
      inflight.add(await aliceCipher.encrypt(Uint8List.fromList(utf8
          .encode("you've never been so hungry, you've never been so cold"))));
    }

    await bobCipher.decryptFromSignal(
        SignalMessage.fromSerialized(inflight[1000].serialize()));
    await bobCipher.decryptFromSignal(SignalMessage.fromSerialized(
        inflight[inflight.length - 1].serialize()));

    try {
      await bobCipher.decryptFromSignal(
          SignalMessage.fromSerialized(inflight[0].serialize()));
      throw AssertionError('Should have failed!');
    } on DuplicateMessageException {
      // good
    }
  }, skip: 'Failing historical test');
}
