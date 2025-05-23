class ConnectionException implements Exception {
  final String message;

  ConnectionException({this.message = 'No internet connection available'});

  @override
  String toString() => 'ConnectionException: $message';
}
