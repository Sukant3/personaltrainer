import 'dart:async';
import 'package:flutter/material.dart';

class RestTimer extends StatefulWidget {
  final int initialSeconds;
  const RestTimer({Key? key, this.initialSeconds = 60}) : super(key: key);

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> {
  late int _remaining;
  Timer? _timer;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.initialSeconds;
  }

  void _toggle() {
    if (_running) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_remaining <= 1) {
          t.cancel();
          setState(() {
            _running = false;
            _remaining = 0;
          });
        } else {
          setState(() => _remaining--);
        }
      });
    }
    setState(() => _running = !_running);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _remaining = widget.initialSeconds;
      _running = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remaining / widget.initialSeconds;
    return Column(
      children: [
        GestureDetector(
          onTap: _toggle,
          onLongPress: _reset,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              Text('$_remaining', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(_running ? 'Pause' : 'Start', style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
