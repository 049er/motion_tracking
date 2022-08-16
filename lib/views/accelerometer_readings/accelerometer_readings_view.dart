import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AccelerometerReadingsView extends StatefulWidget {
  const AccelerometerReadingsView({Key? key}) : super(key: key);

  @override
  State<AccelerometerReadingsView> createState() =>
      _AccelerometerReadingsViewState();
}

class _AccelerometerReadingsViewState extends State<AccelerometerReadingsView> {
  //Stream Subscriptions.
  late StreamSubscription<UserAccelerometerEvent> _userAccelerometerEvents;

  final List<UserAccelerometerEvent> _recordedUserAccelerometerEvents = [];

  double? startTime;

  @override
  void initState() {
    //Start userAccelemoterEvents.
    _userAccelerometerEvents = userAccelerometerEvents.listen(
      (UserAccelerometerEvent event) {
        setState(() {
          startTime ??= event.timestamp;
          _recordedUserAccelerometerEvents.add(event);
          if (_recordedUserAccelerometerEvents.length > 300) {
            _recordedUserAccelerometerEvents.removeAt(0);
          }
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _userAccelerometerEvents.cancel();
    super.dispose();
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
        'Sensor Readings',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        children: [
          _lineChart(),
        ],
      ),
    );
  }

  Widget _lineChart() {
    return Card(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          title: AxisTitle(
            text: 's',
          ),
        ),
        title: ChartTitle(text: 'Accelerometer (m/s^2)'),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<UserAccelerometerEvent, double>>[
          LineSeries<UserAccelerometerEvent, double>(
            dataSource: _recordedUserAccelerometerEvents,
            xValueMapper: (UserAccelerometerEvent userAccelerometerEvent, _) =>
                (userAccelerometerEvent.timestamp - startTime!) / 1000,
            yValueMapper: (UserAccelerometerEvent userAccelerometerEvent, _) =>
                userAccelerometerEvent.x,
            name: 'X',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            color: Colors.blue,
          ),
          LineSeries<UserAccelerometerEvent, double>(
            dataSource: _recordedUserAccelerometerEvents,
            xValueMapper: (UserAccelerometerEvent userAccelerometerEvent, _) =>
                (userAccelerometerEvent.timestamp - startTime!) / 1000,
            yValueMapper: (UserAccelerometerEvent userAccelerometerEvent, _) =>
                userAccelerometerEvent.y,
            name: 'Y',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            color: Colors.green,
          ),
          LineSeries<UserAccelerometerEvent, double>(
            dataSource: _recordedUserAccelerometerEvents,
            xValueMapper: (UserAccelerometerEvent userAccelerometerEvent, _) =>
                (userAccelerometerEvent.timestamp - startTime!) / 1000,
            yValueMapper: (UserAccelerometerEvent userAccelerometerEvent, _) =>
                userAccelerometerEvent.z,
            name: 'Z',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
