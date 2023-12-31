import 'dart:typed_data';

import '../util/byte_util.dart';

class DisplayableFingerprint {
  DisplayableFingerprint(
      Uint8List localFingerprint, Uint8List remoteFingerprint) {
    localFingerprintNumbers = _getDisplayStringFor(localFingerprint);
    remoteFingerprintNumbers = _getDisplayStringFor(remoteFingerprint);
  }

  late String localFingerprintNumbers;
  late String remoteFingerprintNumbers;

  String getDisplayText() {
    if (localFingerprintNumbers.compareTo(remoteFingerprintNumbers) <= 0) {
      return localFingerprintNumbers + remoteFingerprintNumbers;
    } else {
      return remoteFingerprintNumbers + localFingerprintNumbers;
    }
  }

  String _getDisplayStringFor(Uint8List fingerprint) =>
      _getEncodedChunk(fingerprint, 0) +
      _getEncodedChunk(fingerprint, 5) +
      _getEncodedChunk(fingerprint, 10) +
      _getEncodedChunk(fingerprint, 15) +
      _getEncodedChunk(fingerprint, 20) +
      _getEncodedChunk(fingerprint, 25);

  String _getEncodedChunk(Uint8List hash, int offset) {
    final chunk = ByteUtil.byteArray5ToLong(hash, offset).remainder(100000);
    return chunk.toString().padLeft(5, '0');
  }
}
