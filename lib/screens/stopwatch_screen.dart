import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;
  Duration? _limit;

  void _startStopwatch() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
        if (_limit != null && _elapsed >= _limit!) {
          _stopStopwatch();
        }
      });
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _stopStopwatch() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
    });
  }

  void _resetStopwatch() {
    _stopStopwatch();
    setState(() {
      _elapsed = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _elapsed.toString().split('.').first.padLeft(8, '0'),
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRunning ? _stopStopwatch : _startStopwatch,
                child: Text(_isRunning ? 'Stop' : 'Start'), 
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _resetStopwatch,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
