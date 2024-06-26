import 'dart:math';

/// This is a utility class for generating DHIS2 unique identifiers (UIDs).
class D2UID {
  /// Generates a unique identifier (UID).
  ///
  /// Returns a [String] representing the generated UID.
  static String generate() {
    Random rnd = Random();
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const allowedChars = '0123456789$letters';
    const numberOfCodePoints = allowedChars.length;
    const codeSize = 11;
    String uid;
    int charIndex = (rnd.nextInt(10) / 10 * letters.length).round();
    uid = letters.substring(charIndex, charIndex + 1);
    for (int i = 1; i < codeSize; ++i) {
      charIndex = (rnd.nextInt(10) / 10 * numberOfCodePoints).round();
      uid += allowedChars.substring(charIndex, charIndex + 1);
    }
    return uid;
  }
}
