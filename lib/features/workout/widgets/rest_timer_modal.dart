// lib/features/workout/widgets/rest_timer_modal.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef AudioCueCallback = void Function(String cueId);

class RestTimerModal extends StatefulWidget {
  /// initialSeconds default to 60
  final int initialSeconds;

  /// Called whenever the UI determines an audio cue should be played.
  /// Examples: 'countdown_10' (10 seconds remaining), 'tick', 'finished'
  final AudioCueCallback? onAudioCueRequested;

  const RestTimerModal({
    Key? key,
    this.initialSeconds = 60,
    this.onAudioCueRequested,
  }) : super(key: key);

  @override
  State<RestTimerModal> createState() => _RestTimerModalState();
}

class _RestTimerModalState extends State<RestTimerModal> with TickerProviderStateMixin {
  late int _totalSeconds;
  late int _remaining;
  Timer? _ticker;
  bool _running = false;
  bool _audioEnabled = true; // UI toggle — does not play sound by itself
  bool _hapticsEnabled = true;
  late AnimationController _animController; // drives the circular progress
  double _sliderValue = 60;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.initialSeconds;
    _remaining = _totalSeconds;
    _sliderValue = _totalSeconds.toDouble();
    _animController = AnimationController(vsync: this, duration: Duration(seconds: _totalSeconds), value: 1.0);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _start() {
    if (_running) return;
    if (_remaining <= 0) {
      // reset if finished
      setState(() {
        _remaining = _totalSeconds;
        _animController.duration = Duration(seconds: _totalSeconds);
        _animController.value = 1.0;
      });
    }

    // start animation and ticker
    setState(() => _running = true);
    final start = DateTime.now();
    final end = start.add(Duration(seconds: _remaining));
    _animController.duration = Duration(seconds: _remaining);
    _animController.reverse(from: 1.0);

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final secsLeft = end.difference(DateTime.now()).inSeconds;
      setState(() {
        _remaining = secsLeft > 0 ? secsLeft : 0;
      });

      // Cue when 10 seconds left (UI trigger only)
      if (_audioEnabled && _remaining == 10) {
        widget.onAudioCueRequested?.call('countdown_10');
      }

      // Optional tick cue - every second near end (disabled by default)
      // if (_audioEnabled && _remaining <= 5) widget.onAudioCueRequested?.call('tick');

      if (_remaining <= 0) {
        _stopTimer(playCompletedCue: true);
      }
    });
  }

  void _pause() {
    if (!_running) return;
    _ticker?.cancel();
    _animController.stop();
    setState(() => _running = false);
  }

  void _reset() {
    _ticker?.cancel();
    setState(() {
      _remaining = _totalSeconds;
      _running = false;
      _animController.duration = Duration(seconds: _totalSeconds);
      _animController.value = 1.0;
    });
  }

  void _stopTimer({bool playCompletedCue = false}) {
    _ticker?.cancel();
    _animController.stop();
    setState(() {
      _running = false;
      _remaining = 0;
    });

    if (playCompletedCue && _audioEnabled) {
      widget.onAudioCueRequested?.call('finished');
    }
    if (playCompletedCue && _hapticsEnabled) {
      HapticFeedback.vibrate();
    }
  }

  String _formatSeconds(int s) {
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: Icon(_running ? Icons.pause : Icons.play_arrow),
          label: Text(_running ? 'Pause' : 'Start'),
          onPressed: _running ? _pause : _start,
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.replay),
          label: const Text('Reset'),
          onPressed: _reset,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.check),
          label: const Text('Done'),
          onPressed: () {
            // Return selected settings to caller if needed
            Navigator.of(context).pop({
              'seconds': _totalSeconds,
              'audioEnabled': _audioEnabled,
              'hapticsEnabled': _hapticsEnabled,
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final size = MediaQuery.of(context).size.width * 0.36;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text('Rest Timer', style: Theme.of(context).textTheme.titleLarge)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Central circular countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size,
                    height: size,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _animController.value,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.shade200,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_formatSeconds(_remaining), style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 70),
                            Text('${_totalSeconds ~/ 60} sec', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Presets & slider
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in [30, 45, 60, 90, 120])
                    ChoiceChip(
                      label: Text('${s}s'),
                      selected: _totalSeconds == s,
                      onSelected: (sel) {
                        if (!sel) return;
                        setState(() {
                          _totalSeconds = s;
                          _sliderValue = s.toDouble();
                          _remaining = s;
                          _animController.duration = Duration(seconds: s);
                          _animController.value = 1.0;
                          _running = false;
                          _ticker?.cancel();
                        });
                      },
                    ),
                ],
              ),

              const SizedBox(height: 10),

              // Slider for fine control
              Row(children: [
                const SizedBox(width: 6),
                Expanded(
                  child: Slider(
                    min: 5,
                    max: 300,
                    divisions: 59,
                    label: '${_sliderValue.round()}s',
                    value: _sliderValue,
                    onChanged: (v) {
                      setState(() {
                        _sliderValue = v;
                        _totalSeconds = _sliderValue.round();
                        if (!_running) {
                          _remaining = _totalSeconds;
                          _animController.duration = Duration(seconds: _totalSeconds);
                          _animController.value = 1.0;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text('${_totalSeconds}s'),
                const SizedBox(width: 6),
              ]),

              const SizedBox(height: 8),

              // Toggles for audio / haptics (UI only)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Switch(
                      value: _audioEnabled,
                      onChanged: (v) => setState(() => _audioEnabled = v),
                    ),
                    const SizedBox(width: 6),
                    const Text('Audio cues'),
                  ]),
                  Row(children: [
                    Switch(
                      value: _hapticsEnabled,
                      onChanged: (v) => setState(() => _hapticsEnabled = v),
                    ),
                    const SizedBox(width: 6),
                    const Text('Haptics'),
                  ]),
                ],
              ),

              const SizedBox(height: 8),

              // Small preview buttons to trigger cue callbacks (UI-only test)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => widget.onAudioCueRequested?.call('countdown_10'),
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Preview 10s cue'),
                  ),
                  TextButton.icon(
                    onPressed: () => widget.onAudioCueRequested?.call('finished'),
                    icon: const Icon(Icons.celebration),
                    label: const Text('Preview finish'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              _buildControls(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
