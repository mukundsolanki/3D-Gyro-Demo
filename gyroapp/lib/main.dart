import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GyroscopeApp(),
    );
  }
}

class GyroscopeApp extends StatefulWidget {
  @override
  _GyroscopeAppState createState() => _GyroscopeAppState();
}

class _GyroscopeAppState extends State<GyroscopeApp> {
  String gyroscopeData = 'X: 0.0\nY: 0.0\nZ: 0.0';
  
  final String serverUrl = 'http://192.168.29.192:8000';
  late io.Socket socket;

  @override
  void initState() {
    super.initState();

    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('Connected to server');
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      socket.emit('gyroscopeData', {
        'x': event.x,
        'y': event.y,
        'z': event.z,
      });

      setState(() {
        gyroscopeData =
            'X: ${event.x.toStringAsFixed(2)}\nY: ${event.y.toStringAsFixed(2)}\nZ: ${event.z.toStringAsFixed(2)}';
      });
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gyroscope App'),
      ),
      body: Center(
        child: Text(gyroscopeData),
      ),
    );
  }
}
