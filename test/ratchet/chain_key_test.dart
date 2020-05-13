import 'dart:typed_data';

import 'package:libsignal_protocol_dart/src/kdf/HKDF.dart';
import 'package:libsignal_protocol_dart/src/ratchet/ChainKey.dart';
import 'package:test/test.dart';

void main() {
  test('testChainKeyDerivationV2', () {
    var seed = Uint8List.fromList([
      0x8a,
      0xb7,
      0x2d,
      0x6f,
      0x4c,
      0xc5,
      0xac,
      0x0d,
      0x38,
      0x7e,
      0xaf,
      0x46,
      0x33,
      0x78,
      0xdd,
      0xb2,
      0x8e,
      0xdd,
      0x07,
      0x38,
      0x5b,
      0x1c,
      0xb0,
      0x12,
      0x50,
      0xc7,
      0x15,
      0x98,
      0x2e,
      0x7a,
      0xd4,
      0x8f
    ]);

    var messageKey = Uint8List.fromList([
      0x02,
      0xa9,
      0xaa,
      0x6c,
      0x7d,
      0xbd,
      0x64,
      0xf9,
      0xd3,
      0xaa,
      0x92,
      0xf9,
      0x2a,
      0x27,
      0x7b,
      0xf5,
      0x46,
      0x09,
      0xda,
      0xdf,
      0x0b,
      0x00,
      0x82,
      0x8a,
      0xcf,
      0xc6,
      0x1e,
      0x3c,
      0x72,
      0x4b,
      0x84,
      0xa7
    ]);

    var macKey = Uint8List.fromList([
      0xbf,
      0xbe,
      0x5e,
      0xfb,
      0x60,
      0x30,
      0x30,
      0x52,
      0x67,
      0x42,
      0xe3,
      0xee,
      0x89,
      0xc7,
      0x02,
      0x4e,
      0x88,
      0x4e,
      0x44,
      0x0f,
      0x1f,
      0xf3,
      0x76,
      0xbb,
      0x23,
      0x17,
      0xb2,
      0xd6,
      0x4d,
      0xeb,
      0x7c,
      0x83
    ]);

    var nextChainKey = Uint8List.fromList([
      0x28,
      0xe8,
      0xf8,
      0xfe,
      0xe5,
      0x4b,
      0x80,
      0x1e,
      0xef,
      0x7c,
      0x5c,
      0xfb,
      0x2f,
      0x17,
      0xf3,
      0x2c,
      0x7b,
      0x33,
      0x44,
      0x85,
      0xbb,
      0xb7,
      0x0f,
      0xac,
      0x6e,
      0xc1,
      0x03,
      0x42,
      0xa2,
      0x46,
      0xd1,
      0x5d
    ]);

    var chainKey = ChainKey(HKDF.createFor(2), seed, 0);

    expect(chainKey.getKey(), seed);
    expect(chainKey.getMessageKeys().getCipherKey(), messageKey);
    expect(chainKey.getMessageKeys().getMacKey(), macKey);
    expect(chainKey.getNextChainKey().getKey(), nextChainKey);
    expect(chainKey.getIndex(), 0);
    expect(chainKey.getMessageKeys().getCounter(), 0);
    expect(chainKey.getNextChainKey().getIndex(), 1);
    expect(chainKey.getNextChainKey().getMessageKeys().getCounter(), 1);
  });

  test('testChainKeyDerivationV3()', () {
    var seed = Uint8List.fromList([
      0x8a,
      0xb7,
      0x2d,
      0x6f,
      0x4c,
      0xc5,
      0xac,
      0x0d,
      0x38,
      0x7e,
      0xaf,
      0x46,
      0x33,
      0x78,
      0xdd,
      0xb2,
      0x8e,
      0xdd,
      0x07,
      0x38,
      0x5b,
      0x1c,
      0xb0,
      0x12,
      0x50,
      0xc7,
      0x15,
      0x98,
      0x2e,
      0x7a,
      0xd4,
      0x8f
    ]);

    var messageKey = Uint8List.fromList([
      /*  0x02*/
      0xbf,
      0x51,
      0xe9,
      0xd7,
      0x5e,
      0x0e,
      0x31,
      0x03,
      0x10,
      0x51,
      0xf8,
      0x2a,
      0x24,
      0x91,
      0xff,
      0xc0,
      0x84,
      0xfa,
      0x29,
      0x8b,
      0x77,
      0x93,
      0xbd,
      0x9d,
      0xb6,
      0x20,
      0x05,
      0x6f,
      0xeb,
      0xf4,
      0x52,
      0x17
    ]);

    var macKey = Uint8List.fromList([
      0xc6,
      0xc7,
      0x7d,
      0x6a,
      0x73,
      0xa3,
      0x54,
      0x33,
      0x7a,
      0x56,
      0x43,
      0x5e,
      0x34,
      0x60,
      0x7d,
      0xfe,
      0x48,
      0xe3,
      0xac,
      0xe1,
      0x4e,
      0x77,
      0x31,
      0x4d,
      0xc6,
      0xab,
      0xc1,
      0x72,
      0xe7,
      0xa7,
      0x03,
      0x0b
    ]);

    var nextChainKey = Uint8List.fromList([
      0x28,
      0xe8,
      0xf8,
      0xfe,
      0xe5,
      0x4b,
      0x80,
      0x1e,
      0xef,
      0x7c,
      0x5c,
      0xfb,
      0x2f,
      0x17,
      0xf3,
      0x2c,
      0x7b,
      0x33,
      0x44,
      0x85,
      0xbb,
      0xb7,
      0x0f,
      0xac,
      0x6e,
      0xc1,
      0x03,
      0x42,
      0xa2,
      0x46,
      0xd1,
      0x5d
    ]);

    var chainKey = ChainKey(HKDF.createFor(3), seed, 0);

    expect(chainKey.getKey(), seed);
    expect(chainKey.getMessageKeys().getCipherKey(), messageKey);
    expect(chainKey.getMessageKeys().getMacKey(), macKey);
    expect(chainKey.getNextChainKey().getKey(), nextChainKey);
    expect(chainKey.getIndex(), 0);
    expect(chainKey.getMessageKeys().getCounter(), 0);
    expect(chainKey.getNextChainKey().getIndex(), 1);
    expect(chainKey.getNextChainKey().getMessageKeys().getCounter(), 1);
  });
}
