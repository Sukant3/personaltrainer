// lib/features/workout/widgets/mini_rest_timer.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef MiniTimerFinishCallback = void Function();

/// MiniRestTimer: overlay floating widget with simple start/pause/reset
/// Use MiniRestTimer.show(context, ...) to display and MiniRestTimer.hide() to remove.
///
/// Note: this widget keeps running while app is foregrounded. For true background
/// notifications and timer persistence you must integrate flutter_local_notifications
/// and a native background task (see notes below).
class MiniRestTimer {
  static OverlayEntry? _entry;
  static _MiniTimerState? _state;

  /// Show the mini timer overlay. If already shown, updates duration.
  static void show(BuildContext context, {required int seconds, MiniTimerFinishCallback? onFinish, bool startImmediately = true}) {
    if (_entry != null) {
      // Update existing
      _state?._setTotal(seconds);
      if (startImmediately) _state?._start();
      return;
    }

    _entry = OverlayEntry(
      builder: (ctx) => _MiniTimerWidget(
        key: UniqueKey(),
        seconds: seconds,
        onFinish: () => onFinish?.call(),
      ),
    );

    Overlay.of(context)!.insert(_entry!);
  }

  /// Hide the overlay (stop timer and remove).
  static void hide() {
    try {
      _state?._stopAndDispose();
      _entry?.remove();
    } catch (_) {}
    _entry = null;
    _state = null;
  }

  /// Pause the mini timer (if visible)
  static void pause() => _state?._pause();

  /// Resume the mini timer (if visible)
  static void resume() => _state?._start();
}

/// Internal stateful widget displayed in OverlayEntry
class _MiniTimerWidget extends StatefulWidget {
  final int seconds;
  final VoidCallback? onFinish;
  const _MiniTimerWidget({Key? key, required this.seconds, this.onFinish}) : super(key: key);

  @override
  State<_MiniTimerWidget> createState() => _MiniTimerState();
}

class _MiniTimerState extends State<_MiniTimerWidget> with SingleTickerProviderStateMixin {
  late int _total;
  late int _remaining;
  Timer? _ticker;
  bool _running = false;
  Offset _offset = const Offset(16, 200); // initial position
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _total = widget.seconds;
    _remaining = _total;
    _controller = AnimationController(vsync: this, duration: Duration(seconds: _total), value: 1.0);
    // register state to static accessor
    MiniRestTimer._state = this;
    if (mounted) setState(() {});
    // start automatically
    _start();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _controller.dispose();
    MiniRestTimer._state = null;
    super.dispose();
  }

  void _setTotal(int seconds) {
    setState(() {
      _total = seconds;
      _remaining = seconds;
      _controller.duration = Duration(seconds: seconds);
      _controller.value = 1.0;
    });
  }

  void _start() {
    if (_running) return;
    if (_remaining <= 0) {
      _setTotal(_total);
    }
    _running = true;
    final end = DateTime.now().add(Duration(seconds: _remaining));
    _controller.duration = Duration(seconds: _remaining);
    _controller.reverse(from: 1.0);

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final secsLeft = end.difference(DateTime.now()).inSeconds;
      if (!mounted) return;
      setState(() {
        _remaining = secsLeft > 0 ? secsLeft : 0;
      });
      // UI-only haptic cue near end
      if (_remaining == 3) HapticFeedback.mediumImpact();
      if (_remaining <= 0) {
        _stopAndDispose();
        widget.onFinish?.call();
        // Optional: show a debug print; production: trigger local notification / sound
        // debugPrint('Mini timer finished');
      }
    });
  }

  void _pause() {
    if (!_running) return;
    _ticker?.cancel();
    _controller.stop();
    setState(() => _running = false);
  }

  void _stopAndDispose() {
    _ticker?.cancel();
    _controller.stop();
    setState(() {
      _running = false;
      _remaining = 0;
    });
  }

  // Exposed to MiniRestTimer
  void _stopAndDisposeExternal() => _stopAndDispose();

  @override
  Widget build(BuildContext context) {
    final radius = 46.0;
    final progress = (_controller.value.clamp(0.0, 1.0));
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Draggable(
        feedback: _buildButton(radius, progress),
        childWhenDragging: Opacity(opacity: 0.6, child: _buildButton(radius, progress)),
        onDragEnd: (d) {
          // Keep it within screen bounds
          final size = MediaQuery.of(context).size;
          final dx = d.offset.dx.clamp(8.0, size.width - radius * 2 - 8.0);
          final dy = d.offset.dy.clamp(80.0, size.height - radius * 2 - 24.0);
          setState(() => _offset = Offset(dx, dy));
        },
        child: GestureDetector(
          onTap: () {
            // tap to toggle start/pause
            if (_running) {
              _pause();
            } else {
              _start();
            }
          },
          onLongPress: () {
            // long press to hide
            MiniRestTimer.hide();
          },
          child: _buildButton(radius, progress),
        ),
      ),
    );
  }

  Widget _buildButton(double radius, double progress) {
    return Material(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      color: Colors.transparent,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: CircularProgressIndicator(value: progress, strokeWidth: 4, backgroundColor: Colors.grey.shade200),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_running ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 20, color: Colors.blue),
                const SizedBox(height: 4),
                Text(_formatTime(_remaining), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int s) {
    if (s <= 0) return '0:00';
    final m = s ~/ 60;
    final sec = s % 60;
    return '$m:${sec.toString().padLeft(2, '0')}';
  }
}
