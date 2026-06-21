import 'dart:io';

import 'package:flutter/material.dart';

import '../app_logger_impl.dart';

/// Simple debug screen to read and share the on-device logs.
///
/// Reach it from a debug menu or `Navigator.pushNamed(context, AppRoutes.logs)`.
class LogViewerPage extends StatefulWidget {
  const LogViewerPage({super.key});

  @override
  State<LogViewerPage> createState() => _LogViewerPageState();
}

class _LogViewerPageState extends State<LogViewerPage> {
  late Future<String> _content = _load();

  Future<String> _load() async {
    if (!AppLoggerImpl.isReady) return 'Logger not initialised.';
    final File? file = await AppLoggerImpl.instance.currentLogFile();
    if (file == null || !await file.exists()) return 'No logs yet.';
    final String text = await file.readAsString();
    return text.isEmpty ? 'Log file is empty.' : text;
  }

  void _refresh() => setState(() => _content = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App logs'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refresh,
          ),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => AppLoggerImpl.instance.shareLogs(),
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _content,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              snapshot.data ?? '',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.4,
              ),
            ),
          );
        },
      ),
    );
  }
}
