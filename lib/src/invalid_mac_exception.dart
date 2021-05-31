class InvalidMacException implements Exception {
  InvalidMacException(this.detailMessage);
  final String detailMessage;

  @override
  String toString() => '$runtimeType - $detailMessage';
}
