import 'dart:io';

/// Contract for persisting log lines and exposing them for export/sharing.
///
/// Implementations own *where* and *how* logs live on disk (directory, file
/// naming, rotation, retention). The logger only hands them formatted strings.
abstract class LogStorage {
  /// Prepares the storage (creates the directory, picks the active file).
  /// Safe to call once at startup.
  Future<void> init();

  /// Appends a single formatted entry, rotating files when needed.
  Future<void> append(String line);

  /// All retained log files, newest first.
  Future<List<File>> logFiles();

  /// The file currently being written to (null before [init]).
  Future<File?> currentFile();
}
