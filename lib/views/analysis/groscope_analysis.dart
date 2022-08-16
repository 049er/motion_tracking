import 'package:flutter/material.dart';
import 'package:motion_tracking/classes/classes_export.dart';
import 'package:motion_tracking/classes/gyroscope_analysis.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'dart:math' as m;

class GyroscopeAnalysisView extends StatefulWidget {
  const GyroscopeAnalysisView({
    Key? key,
    required this.recordedGyroscopeEvents,
  }) : super(key: key);

  final List<GyroscopeEvent> recordedGyroscopeEvents;

  @override
  State<GyroscopeAnalysisView> createState() => _GyroscopeAnalysisViewState();
}

class _GyroscopeAnalysisViewState extends State<GyroscopeAnalysisView> {
  // late final TimeLine _timeLine = TimeLine(
  //   recordedGyroscopeEvents: widget.recordedGyroscopeEvents,
  //   recordedUserAccelerometerEvents: widget.recordedUserAccelerometerEvents,
  //   filter: widget.filter,
  // );

  late final GyroscopeAnalysis _timeLine = GyroscopeAnalysis(
    recordedGyroscopeEvents: widget.recordedGyroscopeEvents,
  );

  late final double _startTime =
      _timeLine.calculatedOrientations.first.timestamp;

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
    return SingleChildScrollView(
      child: Column(
        children: [
          _dataDisplayWidget(),
          _slider(),
        ],
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
                '${(_timeLine.calculatedOrientations[sliderValue.toInt()].timestamp - _startTime) / 1000} s'),
            Slider(
              max: _timeLine.calculatedOrientations.length.toDouble() - 1,
              min: 1,
              value: sliderValue,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataDisplayWidget() {
    return Card(
      child: Builder(builder: (context) {
        CalculatedOrientation motionEvent =
            _timeLine.calculatedOrientations.elementAt(sliderValue.toInt());
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
          ],
        );
      }),
    );
  }
}
