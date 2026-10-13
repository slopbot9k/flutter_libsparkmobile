import 'dart:async';
import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;
import 'package:coinlib_flutter/coinlib_flutter.dart' as coinlib;
import 'package:flutter_libsparkmobile/flutter_libsparkmobile.dart';

String _bytesToHex(List<int> bytes) =>
    bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

Uint8List _hexToBytes(String hex) {
  final padded = hex.padLeft(64, '0');
  return Uint8List.fromList([
    for (int i = 0; i < padded.length; i += 2)
      int.parse(padded.substring(i, i + 2), radix: 16),
  ]);
}

abstract class SparkAddressGenerator {
  /// Generate key data from a mnemonic.
  static Future<String> generateKeyData(
      String mnemonic, String derivePath) async {
    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: '');
    final root = coinlib.HDPrivateKey.fromSeed(seed);

    // TODO validate derivePath.
    final keys = root.derivePath(derivePath);

    return _bytesToHex(keys.privateKey.data);
  }

  /// Derive an address from the keyData (mnemonic).
  static Future<String> getAddress(
      String keyDataHex, int index, int diversifier, bool isTestnet) async {
    return await LibSpark.getAddress(
      privateKey: _hexToBytes(keyDataHex),
      index: index,
      diversifier: diversifier,
      isTestNet: isTestnet,
    );
  }
}
