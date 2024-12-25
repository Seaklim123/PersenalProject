import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _userInputSeconds = 0; // Stores user-entered duration in seconds
  Duration _remaining = const Duration(
      hours: 0, minutes: 0, seconds: 0); // Initial remaining time
  Timer? _timer;
  bool _isTimerFinished = false;

  void _startCountdown() {
    if (_timer != null || _userInputSeconds == 0) return;
    _remaining = Duration(seconds: _userInputSeconds);
    _isTimerFinished = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      } else {
        _stopCountdown();
        setState(() {
          _isTimerFinished = true;
        });
      }
    });
  }

  void _stopCountdown() {
    _timer?.cancel();
    _timer = null;
  }

  void _setUserInput(String value) {
    final int? parsedValue = int.tryParse(value);
    if (parsedValue != null && parsedValue >= 0) {
      setState(() {
        _userInputSeconds = parsedValue;
      });
    }
  }

  @override
  void dispose() {
    _stopCountdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter duration (seconds)',
              ),
              keyboardType: TextInputType.number,
              onChanged: _setUserInput,
            ),
            const SizedBox(height: 16),
            Text(
              _remaining.toString().split('.').first.padLeft(8, '0'),
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            if (_isTimerFinished)
              const Text(
                'Timer Finished!',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startCountdown,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _stopCountdown,
                  child: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
