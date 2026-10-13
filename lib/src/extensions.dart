import 'dart:typed_data';

extension Uint8ListExt on Uint8List {
  String toHexString() {
    const digits = '0123456789abcdef';
    final chars = Uint8List(length * 2);
    for (int i = 0; i < length; i++) {
      chars[i * 2] = digits.codeUnitAt(this[i] >> 4);
      chars[i * 2 + 1] = digits.codeUnitAt(this[i] & 15);
    }
    return String.fromCharCodes(chars);
  }
}

/// Convert a hex string to a list of bytes, padded to 32 bytes if necessary.
extension StringExt on String {
  Uint8List to32BytesFromHex() {
    if (length > 64) {
      throw Exception("$this is too long for 32 bytes");
    }

    return to32OrMoreBytesFromHex();
  }

  Uint8List to32OrMoreBytesFromHex() {
    // Pad the string to 64 characters with zeros if it's shorter.
    final hexString = padLeft(64, '0');

    final bytes = Uint8List(hexString.length ~/ 2);
    for (int i = 0; i < hexString.length; i += 2) {
      bytes[i ~/ 2] = int.parse(hexString.substring(i, i + 2), radix: 16);
    }
    return bytes;
  }
}
