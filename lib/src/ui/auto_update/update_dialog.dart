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
    this.title = 'Update Available',
    this.accentColor = Colors.deepPurple,
    this.icon = Icons.system_update_alt,
    this.updateButtonLabel = 'Update',
    this.skipButtonLabel = 'Skip',
    this.borderRadius = 16,
  });

  final String version;
  final String releaseNote;
  final Stream<double> progressStream;
  final Future<void> Function() onUpdate;
  final VoidCallback? onSkip;

  /// Dialog title text, e.g. "New Update Available".
  final String title;

  /// Drives the title icon, progress bar and update button color.
  final Color accentColor;

  /// Icon shown next to the title. Pass `null` to hide it.
  final IconData? icon;

  final String updateButtonLabel;
  final String skipButtonLabel;
  final double borderRadius;

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
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius)),
      title: Row(
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: widget.accentColor),
            const SizedBox(width: 8),
          ],
          Text(widget.title, style: theme.textTheme.titleLarge),
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
                  valueColor: AlwaysStoppedAnimation(widget.accentColor),
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
                child: Text(widget.skipButtonLabel),
              ),
              FilledButton.icon(
                onPressed: _startUpdate,
                style: FilledButton.styleFrom(backgroundColor: widget.accentColor),
                icon: const Icon(Icons.download),
                label: Text(widget.updateButtonLabel),
              ),
            ],
    );
  }
}
