import 'package:flutter/material.dart';
import 'screens/alarm_screen.dart';
import 'screens/stopwatch_screen.dart';
import 'screens/timer_screen.dart';

enum AppScreen { alarm, stopwatch, timer }

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/alarm': (_) => AlarmScreen(),
        '/stopwatch': (_) => StopwatchScreen(),
        '/timer': (_) => TimerScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppScreen _currentScreen = AppScreen.alarm;

  Widget _getScreen(AppScreen screen) {
    switch (screen) {
      case AppScreen.alarm:
        return AlarmScreen();
      case AppScreen.stopwatch:
        return StopwatchScreen();
      case AppScreen.timer:
        return TimerScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock Alarm App'),
      ),
      body: _getScreen(_currentScreen),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentScreen.index,
        onTap: (index) {
          setState(() {
            _currentScreen = AppScreen.values[index];
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Alarm'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Stopwatch'),
          BottomNavigationBarItem(
              icon: Icon(Icons.hourglass_empty), label: 'Timer'),
        ],
      ),
    );
  }
}


