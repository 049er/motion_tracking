import 'package:flutter/material.dart';
import 'package:motion_tracking/classes/classes_export.dart';
import 'package:motion_tracking/classes/analysis.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'dart:math' as m;

class AnalysisView extends StatefulWidget {
  const AnalysisView({
    Key? key,
    required this.recordedGyroscopeEvents,
    required this.recordedUserAccelerometerEvents,
    required this.filter,
  }) : super(key: key);

  final List<UserAccelerometerEvent> recordedUserAccelerometerEvents;
  final List<GyroscopeEvent> recordedGyroscopeEvents;
  final double filter;

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  late final Analysis _timeLine = Analysis(
    recordedGyroscopeEvents: widget.recordedGyroscopeEvents,
    recordedUserAccelerometerEvents: widget.recordedUserAccelerometerEvents,
    filter: widget.filter,
  );

  double sliderValue = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Analysis',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _dataDisplayWidget(),
            _slider(),
            // _testButton(),
          ],
        ),
      ),
    );
  }

  // Widget _testButton() {
  //   return ElevatedButton(
  //     onPressed: () {
  //       log(
  //         name: 'Interpolated Gyroscope Events',
  //         _timeLine.interpolatedGyroscopeEvents.length.toString(),
  //       );
  //       log(
  //         name: 'Interpolated UserAccelerometer Events',
  //         _timeLine.interpolatedUserAccelerometerEvents.length.toString(),
  //       );
  //       log(
  //         name: 'Rotated UserAccelerometer Events',
  //         _timeLine.rotatedUserAccelerometerEvents.length.toString(),
  //       );
  //       log(
  //         name: 'Calculated Velocity',
  //         _timeLine.velocities.length.toString(),
  //       );
  //       log(
  //         name: 'Calculated Positions',
  //         _timeLine.positions.length.toString(),
  //       );
  //       log(
  //         name: 'Last Calculated Position',
  //         _timeLine.positions.last.toString(),
  //       );
  //     },
  //     child: const Text('test'),
  //   );
  // }

  Widget _slider() {
    return Card(
      child: Slider(
        max: _timeLine.motionEvents.length.toDouble() - 1,
        min: 1,
        value: sliderValue,
        onChanged: (value) {
          setState(() {
            sliderValue = value;
          });
        },
      ),
    );
  }

  Widget _dataDisplayWidget() {
    return Card(
      child: Builder(builder: (context) {
        MotionEvent motionEvent =
            _timeLine.motionEvents.elementAt(sliderValue.toInt());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Orientation',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${(motionEvent.orientation.x * (180 / m.pi)).toStringAsFixed(2)}° , ${(motionEvent.orientation.y * (180 / m.pi)).toStringAsFixed(2)}°, ${(motionEvent.orientation.z * (180 / m.pi)).toStringAsFixed(2)}°',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Transform(
                origin: Offset(MediaQuery.of(context).size.width / 2,
                    MediaQuery.of(context).size.height / 6),
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(motionEvent.orientation.x)
                  ..rotateY(motionEvent.orientation.y)
                  ..rotateZ(motionEvent.orientation.z),
                child: const Center(
                  child: Card(
                    color: Colors.blue,
                    child: SizedBox(
                      width: 100,
                      height: 150,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            Text(
              'Acceleration (m/s^2)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${(motionEvent.interpolatedAcceleration.x).toStringAsFixed(2)} , ${(motionEvent.interpolatedAcceleration.y).toStringAsFixed(2)}, ${(motionEvent.interpolatedAcceleration.z).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(),
            Text(
              'Rotated Acceleration (m/s^2)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${(motionEvent.acceleration.x).toStringAsFixed(2)} , ${(motionEvent.acceleration.y).toStringAsFixed(2)}, ${(motionEvent.acceleration.z).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(),
            Text(
              'Velocity (m/s)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${(motionEvent.velocity.x).toStringAsFixed(2)} , ${(motionEvent.velocity.y).toStringAsFixed(2)}, ${(motionEvent.velocity.z).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(),
            Text(
              'Position (m)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${(motionEvent.position.x).toStringAsFixed(2)} , ${(motionEvent.position.y).toStringAsFixed(2)}, ${(motionEvent.position.z).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(),
          ],
        );
      }),
    );
  }
}
