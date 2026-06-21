/// Severity of a log entry. Ordered from least to most severe.
enum LogLevel {
  info('INFO'),
  warning('WARNING'),
  error('ERROR');

  const LogLevel(this.label);

  /// Upper-case label written into the log file (`INFO` / `WARNING` / `ERROR`).
  final String label;
}
