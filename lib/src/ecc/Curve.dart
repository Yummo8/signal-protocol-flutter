import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:libsignalprotocoldart/src/ecc/DjbECPrivateKey.dart';
import 'package:libsignalprotocoldart/src/ecc/DjbECPublicKey.dart';
import 'package:libsignalprotocoldart/src/ecc/ECKeyPair.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPrivateKey.dart';
import 'package:libsignalprotocoldart/src/ecc/ECPublicKey.dart';

class Curve {
  static const int djbType = 0x05;

  static ECKeyPair generateKeyPair() {
    final keyPair = x25519.newKeyPairSync();
    return new ECKeyPair(
        new DjbECPublicKey(Uint8List.fromList(keyPair.publicKey.bytes)),
        new DjbECPrivateKey(
            Uint8List.fromList(keyPair.privateKey.extractSync())));
  }

  static ECPublicKey decodePoint(Uint8List bytes, int offset) {
    if (bytes == null || bytes.length - offset < 1) {
      throw new Exception("No key type identifier");
    }

    int type = bytes[offset] & 0xFF;

    switch (type) {
      case Curve.djbType:
        if (bytes.length - offset < 33) {
          throw new Exception("Bad key length: " + bytes.length.toString());
        }

        Uint8List keyBytes = new Uint8List(32);
        keyBytes.insertAll(0, bytes.sublist(offset + 1));
        return new DjbECPublicKey(keyBytes);
      default:
        throw new Exception("Bad key type: " + type.toString());
    }
  }

  static ECPrivateKey decodePrivatePoint(Uint8List bytes) {
    return new DjbECPrivateKey(bytes);
  }

  static Uint8List calculateAgreement(
      ECPublicKey publicKey, ECPrivateKey privateKey) {
    if (publicKey == null) {
      throw new Exception("publicKey value is null");
    }

    if (privateKey == null) {
      throw new Exception("privateKey value is null");
    }
    if (publicKey.getType() != privateKey.getType()) {
      throw new Exception("Public and private keys must be of the same type!");
    }

    if (publicKey.getType() == djbType) {
      var secretKey = x25519.sharedSecretSync(
        localPrivateKey:
            PrivateKey((privateKey as DjbECPrivateKey).getPrivateKey()),
        remotePublicKey:
            PublicKey((publicKey as DjbECPublicKey).getPublicKey()),
      );
      return Uint8List.fromList(secretKey.extractSync());
    } else {
      throw new Exception("Unknown type: " + publicKey.getType().toString());
    }
  }

  static bool verifySignature(
      ECPublicKey signingKey, Uint8List message, Uint8List signature) {
    if (signingKey == null || message == null || signature == null) {
      throw new Exception("Values must not be null");
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw new Exception(
          "Unknown Signing Key type" + signingKey.getType().toString());
    }
  }

  static Uint8List calculateSignature(
      ECPrivateKey signingKey, Uint8List message) {
    if (signingKey == null || message == null) {
      throw new Exception("Values must not be null");
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw new Exception(
          "Unknown Signing Key type" + signingKey.getType().toString());
    }
  }

  static Uint8List calculateVrfSignature(
      ECPrivateKey signingKey, Uint8List message) {
    if (signingKey == null || message == null) {
      throw new Exception("Values must not be null");
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw new Exception(
          "Unknown Signing Key type" + signingKey.getType().toString());
    }
  }

  static Uint8List verifyVrfSignature(
      ECPublicKey signingKey, Uint8List message, Uint8List signature) {
    if (signingKey == null || message == null || signature == null) {
      throw new Exception("Values must not be null");
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw new Exception(
          "Unknown Signing Key type" + signingKey.getType().toString());
    }
  }
}
