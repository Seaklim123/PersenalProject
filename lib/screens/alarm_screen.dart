import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final List<Map<String, dynamic>> _alarms = [];
  bool _isAlarmTriggered = false;
  String? _triggeredAlarmId; // Store ID of the triggered alarm

  Future<void> _addAlarm() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        final uuid = const Uuid().v4();
        _alarms.add({'id': uuid, 'time': pickedTime, 'repeat': false});
      });
    }
  }

  Future<void> _editAlarm(int index) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _alarms[index]['time'],
    );

    if (pickedTime != null) {
      setState(() {
        _alarms[index]['time'] = pickedTime;
      });
    }
  }

  void _deleteAlarm(String alarmId) {
    setState(() {
      _alarms.removeWhere((alarm) => alarm['id'] == alarmId);
     
      if (alarmId == _triggeredAlarmId) {
        _isAlarmTriggered = false;
        _triggeredAlarmId = null;
      }
    });
  }

  void _checkAlarms() {
    final now = TimeOfDay.now();
    for (var i = 0; i < _alarms.length; i++) {
      if (_alarms[i]['time'] == now) {
        setState(() {
          _isAlarmTriggered = true;
          _triggeredAlarmId = _alarms[i]['id'];
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alarm Triggered!'),
            duration: Duration(seconds: 3), 
          ),
        );
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) => _checkAlarms());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAlarm,
            color: Colors.red,
            iconSize: 40,
          ),
        ],
      ),
      body: _alarms.isEmpty
          ? const Center(
              child: Text('No alarms set. Tap the "+" to add one.'),
            )
          : Column(
              children: [
                if (_isAlarmTriggered)
                  Container(
                    color: Colors.red.withOpacity(0.2),
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Alarm Triggered!',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _alarms.length,
                    itemBuilder: (context, index) {
                      final alarm = _alarms[index];
                      return Dismissible(
                        key: ValueKey(alarm['id']),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) => _deleteAlarm(alarm['id']),
                        child: ListTile(
                          title:
                              Text('Alarm: ${alarm['time'].format(context)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editAlarm(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteAlarm(alarm['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
