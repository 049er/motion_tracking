import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_tracking/globals/theme.dart';
import 'package:motion_tracking/views/gyroscope_readings/gyroscope_readings_view.dart';
import 'package:motion_tracking/views/recording/recording_view.dart';
import 'package:motion_tracking/views/accelerometer_readings/accelerometer_readings_view.dart';
import 'navigator_card.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motion Tracking',
      theme: themeData(),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Motion Tracking',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Center(
        child: GridView.count(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 100, left: 8, right: 8),
          crossAxisCount: 2,
          children: const [
            NavigatorCard(
              label: 'Sensor Recording',
              icon: Icons.track_changes_sharp,
              viewPage: RecordingView(),
            ),
            NavigatorCard(
              label: 'Accelerometer',
              icon: Icons.line_axis_sharp,
              viewPage: AccelerometerReadingsView(),
            ),
            NavigatorCard(
              label: 'Gyroscope',
              icon: Icons.line_axis_sharp,
              viewPage: GyroscopeReadingsView(),
            ),
          ],
        ),
      ),
    );
  }
}
