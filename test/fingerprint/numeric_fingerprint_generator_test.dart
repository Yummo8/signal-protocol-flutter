import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/ecc/curve.dart';
import 'package:libsignal_protocol_dart/src/fingerprint/numeric_fingerprint_generator.dart';
import 'package:libsignal_protocol_dart/src/identity_key.dart';
import 'package:test/test.dart';

Uint8List aliceIdentity = Uint8List.fromList([
  0x05,
  0x06,
  0x86,
  0x3b,
  0xc6,
  0x6d,
  0x02,
  0xb4,
  0x0d,
  0x27,
  0xb8,
  0xd4,
  0x9c,
  0xa7,
  0xc0,
  0x9e,
  0x92,
  0x39,
  0x23,
  0x6f,
  0x9d,
  0x7d,
  0x25,
  0xd6,
  0xfc,
  0xca,
  0x5c,
  0xe1,
  0x3c,
  0x70,
  0x64,
  0xd8,
  0x68
]);
Uint8List bobIdentity = Uint8List.fromList([
  0x05,
  0xf7,
  0x81,
  0xb6,
  0xfb,
  0x32,
  0xfe,
  0xd9,
  0xba,
  0x1c,
  0xf2,
  0xde,
  0x97,
  0x8d,
  0x4d,
  0x5d,
  0xa2,
  0x8d,
  0xc3,
  0x40,
  0x46,
  0xae,
  0x81,
  0x44,
  0x02,
  0xb5,
  0xc0,
  0xdb,
  0xd9,
  0x6f,
  0xda,
  0x90,
  0x7b
]);

int version1 = 1;
String displayableFingerprintV1 =
    '300354477692869396892869876765458257569162576843440918079131';
Uint8List aliceScannableFingerprintV1 = Uint8List.fromList([
  0x08,
  0x01,
  0x12,
  0x22,
  0x0a,
  0x20,
  0x1e,
  0x30,
  0x1a,
  0x03,
  0x53,
  0xdc,
  0xe3,
  0xdb,
  0xe7,
  0x68,
  0x4c,
  0xb8,
  0x33,
  0x6e,
  0x85,
  0x13,
  0x6c,
  0xdc,
  0x0e,
  0xe9,
  0x62,
  0x19,
  0x49,
  0x4a,
  0xda,
  0x30,
  0x5d,
  0x62,
  0xa7,
  0xbd,
  0x61,
  0xdf,
  0x1a,
  0x22,
  0x0a,
  0x20,
  0xd6,
  0x2c,
  0xbf,
  0x73,
  0xa1,
  0x15,
  0x92,
  0x01,
  0x5b,
  0x6b,
  0x9f,
  0x16,
  0x82,
  0xac,
  0x30,
  0x6f,
  0xea,
  0x3a,
  0xaf,
  0x38,
  0x85,
  0xb8,
  0x4d,
  0x12,
  0xbc,
  0xa6,
  0x31,
  0xe9,
  0xd4,
  0xfb,
  0x3a,
  0x4d
]);
Uint8List bobScannableFingerprintV1 = Uint8List.fromList([
  0x08,
  0x01,
  0x12,
  0x22,
  0x0a,
  0x20,
  0xd6,
  0x2c,
  0xbf,
  0x73,
  0xa1,
  0x15,
  0x92,
  0x01,
  0x5b,
  0x6b,
  0x9f,
  0x16,
  0x82,
  0xac,
  0x30,
  0x6f,
  0xea,
  0x3a,
  0xaf,
  0x38,
  0x85,
  0xb8,
  0x4d,
  0x12,
  0xbc,
  0xa6,
  0x31,
  0xe9,
  0xd4,
  0xfb,
  0x3a,
  0x4d,
  0x1a,
  0x22,
  0x0a,
  0x20,
  0x1e,
  0x30,
  0x1a,
  0x03,
  0x53,
  0xdc,
  0xe3,
  0xdb,
  0xe7,
  0x68,
  0x4c,
  0xb8,
  0x33,
  0x6e,
  0x85,
  0x13,
  0x6c,
  0xdc,
  0x0e,
  0xe9,
  0x62,
  0x19,
  0x49,
  0x4a,
  0xda,
  0x30,
  0x5d,
  0x62,
  0xa7,
  0xbd,
  0x61,
  0xdf
]);

int version2 = 2;
String displayableFingerprintV2 = displayableFingerprintV1;
Uint8List aliceScannableFingerprintV2 = Uint8List.fromList([
  0x08,
  0x02,
  0x12,
  0x22,
  0x0a,
  0x20,
  0x1e,
  0x30,
  0x1a,
  0x03,
  0x53,
  0xdc,
  0xe3,
  0xdb,
  0xe7,
  0x68,
  0x4c,
  0xb8,
  0x33,
  0x6e,
  0x85,
  0x13,
  0x6c,
  0xdc,
  0x0e,
  0xe9,
  0x62,
  0x19,
  0x49,
  0x4a,
  0xda,
  0x30,
  0x5d,
  0x62,
  0xa7,
  0xbd,
  0x61,
  0xdf,
  0x1a,
  0x22,
  0x0a,
  0x20,
  0xd6,
  0x2c,
  0xbf,
  0x73,
  0xa1,
  0x15,
  0x92,
  0x01,
  0x5b,
  0x6b,
  0x9f,
  0x16,
  0x82,
  0xac,
  0x30,
  0x6f,
  0xea,
  0x3a,
  0xaf,
  0x38,
  0x85,
  0xb8,
  0x4d,
  0x12,
  0xbc,
  0xa6,
  0x31,
  0xe9,
  0xd4,
  0xfb,
  0x3a,
  0x4d
]);
Uint8List bobScannableFingerprintV2 = Uint8List.fromList([
  0x08,
  0x02,
  0x12,
  0x22,
  0x0a,
  0x20,
  0xd6,
  0x2c,
  0xbf,
  0x73,
  0xa1,
  0x15,
  0x92,
  0x01,
  0x5b,
  0x6b,
  0x9f,
  0x16,
  0x82,
  0xac,
  0x30,
  0x6f,
  0xea,
  0x3a,
  0xaf,
  0x38,
  0x85,
  0xb8,
  0x4d,
  0x12,
  0xbc,
  0xa6,
  0x31,
  0xe9,
  0xd4,
  0xfb,
  0x3a,
  0x4d,
  0x1a,
  0x22,
  0x0a,
  0x20,
  0x1e,
  0x30,
  0x1a,
  0x03,
  0x53,
  0xdc,
  0xe3,
  0xdb,
  0xe7,
  0x68,
  0x4c,
  0xb8,
  0x33,
  0x6e,
  0x85,
  0x13,
  0x6c,
  0xdc,
  0x0e,
  0xe9,
  0x62,
  0x19,
  0x49,
  0x4a,
  0xda,
  0x30,
  0x5d,
  0x62,
  0xa7,
  0xbd,
  0x61,
  0xdf
]);

void main() {
  test('testVectorsVersion1', () {
    final aliceIdentityKey = IdentityKey.fromBytes(aliceIdentity, 0);
    final bobIdentityKey = IdentityKey.fromBytes(bobIdentity, 0);
    final aliceStableId = Uint8List.fromList(utf8.encode('+14152222222'));
    final bobStableId = Uint8List.fromList(utf8.encode('+14153333333'));

    final generator = NumericFingerprintGenerator(5200);

    final aliceFingerprint = generator.createFor(
        version1, aliceStableId, aliceIdentityKey, bobStableId, bobIdentityKey);

    final bobFingerprint = generator.createFor(
        version1, bobStableId, bobIdentityKey, aliceStableId, aliceIdentityKey);

    expect(aliceFingerprint.displayableFingerprint.getDisplayText(),
        displayableFingerprintV1);
    expect(bobFingerprint.displayableFingerprint.getDisplayText(),
        displayableFingerprintV1);

    expect(aliceFingerprint.scannableFingerprint.fingerprints,
        aliceScannableFingerprintV1);
    expect(bobFingerprint.scannableFingerprint.fingerprints,
        bobScannableFingerprintV1);
  });

  test('testMatchingFingerprints', () {
    final aliceKeyPair = Curve.generateKeyPair();
    final bobKeyPair = Curve.generateKeyPair();

    final aliceIdentityKey = IdentityKey(aliceKeyPair.publicKey);
    final bobIdentityKey = IdentityKey(bobKeyPair.publicKey);

    final generator = NumericFingerprintGenerator(1024);
    final aliceFingerprint = generator.createFor(
        version1,
        Uint8List.fromList(utf8.encode('+14152222222')),
        aliceIdentityKey,
        Uint8List.fromList(utf8.encode('+14153333333')),
        bobIdentityKey);

    final bobFingerprint = generator.createFor(
        version1,
        Uint8List.fromList(utf8.encode('+14153333333')),
        bobIdentityKey,
        Uint8List.fromList(utf8.encode('+14152222222')),
        aliceIdentityKey);

    expect(aliceFingerprint.displayableFingerprint.getDisplayText(),
        bobFingerprint.displayableFingerprint.getDisplayText());

    expect(
        aliceFingerprint.scannableFingerprint
            .compareTo(bobFingerprint.scannableFingerprint.fingerprints),
        true);
    expect(
        bobFingerprint.scannableFingerprint
            .compareTo(aliceFingerprint.scannableFingerprint.fingerprints),
        true);

    expect(aliceFingerprint.displayableFingerprint.getDisplayText().length, 60);
  });

  test('testMismatchingFingerprints', () {
    final aliceKeyPair = Curve.generateKeyPair();
    final bobKeyPair = Curve.generateKeyPair();
    final mitmKeyPair = Curve.generateKeyPair();

    final aliceIdentityKey = IdentityKey(aliceKeyPair.publicKey);
    final bobIdentityKey = IdentityKey(bobKeyPair.publicKey);
    final mitmIdentityKey = IdentityKey(mitmKeyPair.publicKey);

    final generator = NumericFingerprintGenerator(1024);
    final aliceFingerprint = generator.createFor(
        version1,
        Uint8List.fromList(utf8.encode('+14152222222')),
        aliceIdentityKey,
        Uint8List.fromList(utf8.encode('+14153333333')),
        mitmIdentityKey);

    final bobFingerprint = generator.createFor(
        version1,
        Uint8List.fromList(utf8.encode('+14153333333')),
        bobIdentityKey,
        Uint8List.fromList(utf8.encode('+14152222222')),
        aliceIdentityKey);

    expect(
        aliceFingerprint.displayableFingerprint.getDisplayText() ==
            bobFingerprint.displayableFingerprint.getDisplayText(),
        false);

    expect(
        aliceFingerprint.scannableFingerprint
            .compareTo(bobFingerprint.scannableFingerprint.fingerprints),
        false);
    expect(
        bobFingerprint.scannableFingerprint
            .compareTo(aliceFingerprint.scannableFingerprint.fingerprints),
        false);
  });

  test('testMismatchingIdentifiers', () {
    final aliceKeyPair = Curve.generateKeyPair();
    final bobKeyPair = Curve.generateKeyPair();

    final aliceIdentityKey = IdentityKey(aliceKeyPair.publicKey);
    final bobIdentityKey = IdentityKey(bobKeyPair.publicKey);

    final generator = NumericFingerprintGenerator(1024);
    final aliceFingerprint = generator.createFor(
        version1,
        Uint8List.fromList(utf8.encode('+141512222222')),
        aliceIdentityKey,
        Uint8List.fromList(utf8.encode('+14153333333')),
        bobIdentityKey);
    final bobFingerprint = generator.createFor(
        version1,
        Uint8List.fromList(utf8.encode('+14153333333')),
        bobIdentityKey,
        Uint8List.fromList(utf8.encode('+14152222222')),
        aliceIdentityKey);

    expect(
        aliceFingerprint.displayableFingerprint.getDisplayText() ==
            bobFingerprint.displayableFingerprint.getDisplayText(),
        false);

    expect(
        aliceFingerprint.scannableFingerprint
            .compareTo(bobFingerprint.scannableFingerprint.fingerprints),
        false);
    expect(
        bobFingerprint.scannableFingerprint
            .compareTo(aliceFingerprint.scannableFingerprint.fingerprints),
        false);
  });

  test('testDifferentVersionsMakeSameFingerPrintsButDifferentScannable', () {
    final aliceIdentityKey = IdentityKey.fromBytes(aliceIdentity, 0);
    final bobIdentityKey = IdentityKey.fromBytes(bobIdentity, 0);
    final aliceStableId = Uint8List.fromList(utf8.encode('+14152222222'));
    final bobStableId = Uint8List.fromList(utf8.encode('+14153333333'));

    final generator = NumericFingerprintGenerator(5200);

    final aliceFingerprintV1 = generator.createFor(
        version1, aliceStableId, aliceIdentityKey, bobStableId, bobIdentityKey);

    final aliceFingerprintV2 = generator.createFor(
        version2, aliceStableId, aliceIdentityKey, bobStableId, bobIdentityKey);

    expect(
        aliceFingerprintV1.displayableFingerprint.getDisplayText() ==
            aliceFingerprintV2.displayableFingerprint.getDisplayText(),
        true);

    expect(
        aliceFingerprintV1.scannableFingerprint.fingerprints ==
            aliceFingerprintV2.scannableFingerprint.fingerprints,
        false);
  });
}
