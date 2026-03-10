import 'dart:async';

import 'package:flutter/material.dart';


class D2UpdateDialog extends StatefulWidget {
  const D2UpdateDialog({
    super.key,
    required this.version,
    required this.releaseNote,
    required this.progressStream,
    required this.onUpdate,
    this.onSkip,
  });

  final String version;
  final String releaseNote;
  final Stream<double> progressStream;
  final Future<void> Function() onUpdate;
  final VoidCallback? onSkip;

  @override
  State<D2UpdateDialog> createState() => _D2UpdateDialogState();
}

class _D2UpdateDialogState extends State<D2UpdateDialog> {
  bool _isDownloading = false;
  double _progress = 0.0;
  late final StreamSubscription<double> _progressSub;

  @override
  void initState() {
    super.initState();
    _progressSub = widget.progressStream.listen((value) {
      if (mounted) setState(() => _progress = value);
    });
  }

  @override
  void dispose() {
    _progressSub.cancel();
    super.dispose();
  }

  Future<void> _startUpdate() async {
    setState(() => _isDownloading = true);
    await widget.onUpdate();
    if (mounted) setState(() => _isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.system_update_alt, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Text('Update Available', style: theme.textTheme.titleLarge),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version ${widget.version}',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (widget.releaseNote.isNotEmpty) ...[
              Text(
                'What\'s new:',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 160),
                child: SingleChildScrollView(
                  child: Text(
                    widget.releaseNote,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (_isDownloading) ...[
              Text(
                'Downloading… ${(_progress * 100).toStringAsFixed(0)}%',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress > 0 ? _progress : null,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation(Colors.deepPurple),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: _isDownloading
          ? null
          : [
              TextButton(
                onPressed: widget.onSkip ??
                    () => Navigator.of(context).pop(),
                child: const Text('Skip'),
              ),
              FilledButton.icon(
                onPressed: _startUpdate,
                icon: const Icon(Icons.download),
                label: const Text('Update'),
              ),
            ],
    );
  }
}
