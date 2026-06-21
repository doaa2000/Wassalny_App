import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/log_storage.dart';

/// File-backed [LogStorage] living in the app's documents directory.
///
/// Layout: `<app-documents>/logs/wassalny_<utc-timestamp>.log`
///
/// Rotation: when the active file would exceed [maxFileBytes] a fresh
/// timestamped file is started. Retention: only the newest [maxFiles] files are
/// kept; older ones are deleted automatically.
///
/// Writes are serialized through an internal queue so concurrent log calls
/// never interleave or corrupt a line.
class FileLogStorage implements LogStorage {
  FileLogStorage({
    this.maxFileBytes = 5 * 1024 * 1024, // 5 MB
    this.maxFiles = 10,
  });

  final int maxFileBytes;
  final int maxFiles;

  static const String _dirName = 'logs';
  static const String _filePrefix = 'wassalny_';
  static const String _fileExt = '.log';

  Directory? _dir;
  File? _current;
  int _currentSize = 0;

  /// Serializes all disk writes; each append chains onto the previous one.
  Future<void> _queue = Future<void>.value();

  @override
  Future<void> init() async {
    final Directory docs = await getApplicationDocumentsDirectory();
    final Directory dir = Directory('${docs.path}/$_dirName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _dir = dir;

    final List<File> existing = await _sortedFiles();
    if (existing.isNotEmpty) {
      _current = existing.first; // newest
      _currentSize = await _current!.length();
    } else {
      _current = await _newFile();
      _currentSize = 0;
    }
  }

  @override
  Future<void> append(String line) {
    // Chain onto the queue and swallow IO errors so logging never crashes the
    // app (the console sink in the logger still shows the entry).
    _queue = _queue.then((_) => _write(line)).catchError((_) {});
    return _queue;
  }

  Future<void> _write(String line) async {
    if (_dir == null) return; // not initialized yet — drop to disk silently.
    final String payload = '$line\n';
    final int size = utf8.encode(payload).length;

    if (_current == null || _currentSize + size > maxFileBytes) {
      await _rotate();
    }
    await _current!.writeAsString(payload, mode: FileMode.append, flush: true);
    _currentSize += size;
  }

  /// Starts a new active file and prunes old ones.
  Future<void> _rotate() async {
    _current = await _newFile();
    _currentSize = 0;
    await _prune();
  }

  Future<File> _newFile() async {
    // ISO-8601 with `:`/`.` replaced so the name is filesystem-safe AND sorts
    // chronologically as a plain string.
    final String ts =
        DateTime.now().toUtc().toIso8601String().replaceAll(RegExp(r'[:.]'), '-');
    final File file = File('${_dir!.path}/$_filePrefix$ts$_fileExt');
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    return file;
  }

  /// Log files newest-first (filenames embed a sortable UTC timestamp).
  Future<List<File>> _sortedFiles() async {
    final Directory? dir = _dir;
    if (dir == null || !await dir.exists()) return <File>[];
    final List<File> files = await dir
        .list()
        .where((e) =>
            e is File &&
            e.uri.pathSegments.last.startsWith(_filePrefix) &&
            e.path.endsWith(_fileExt))
        .cast<File>()
        .toList();
    files.sort((a, b) => b.path.compareTo(a.path)); // newest first
    return files;
  }

  /// Deletes everything beyond the newest [maxFiles] files.
  Future<void> _prune() async {
    final List<File> files = await _sortedFiles();
    if (files.length <= maxFiles) return;
    for (final File old in files.sublist(maxFiles)) {
      try {
        await old.delete();
      } catch (_) {
        // Ignore — a stale file we couldn't remove must not break logging.
      }
    }
  }

  @override
  Future<List<File>> logFiles() => _sortedFiles();

  @override
  Future<File?> currentFile() async => _current;
}
