import 'dart:async';

import 'package:flutter/material.dart';
import 'package:motion_tracking/views/analysis/groscope_analysis.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GyroscopeReadingsView extends StatefulWidget {
  const GyroscopeReadingsView({Key? key}) : super(key: key);

  @override
  State<GyroscopeReadingsView> createState() => _GyroscopeReadingsViewState();
}

class _GyroscopeReadingsViewState extends State<GyroscopeReadingsView> {
  //Stream Subscriptions.
  StreamSubscription<GyroscopeEvent>? _gyroscopeEvents;

  final List<GyroscopeEvent> _recordedGyroscopeEvents = [];

  double? _startTime;

  bool isRecording = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _gyroscopeEvents?.cancel();
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
          isRecording ? _stop() : _start(),
          _recordedGyroscopeEvents.isEmpty
              ? const SizedBox.shrink()
              : _analise(),
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
        title: ChartTitle(text: 'Gyroscope (rad/s)'),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<GyroscopeEvent, double>>[
          LineSeries<GyroscopeEvent, double>(
            dataSource: _recordedGyroscopeEvents,
            xValueMapper: (GyroscopeEvent gyroscopeEvent, _) =>
                (gyroscopeEvent.timestamp - _startTime!) / 1000,
            yValueMapper: (GyroscopeEvent gyroscopeEvent, _) =>
                gyroscopeEvent.x,
            name: 'X',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            color: Colors.blue,
          ),
          LineSeries<GyroscopeEvent, double>(
            dataSource: _recordedGyroscopeEvents,
            xValueMapper: (GyroscopeEvent gyroscopeEvent, _) =>
                (gyroscopeEvent.timestamp - _startTime!) / 1000,
            yValueMapper: (GyroscopeEvent gyroscopeEvent, _) =>
                gyroscopeEvent.y,
            name: 'Y',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            color: Colors.green,
          ),
          LineSeries<GyroscopeEvent, double>(
            dataSource: _recordedGyroscopeEvents,
            xValueMapper: (GyroscopeEvent gyroscopeEvent, _) =>
                (gyroscopeEvent.timestamp - _startTime!) / 1000,
            yValueMapper: (GyroscopeEvent gyroscopeEvent, _) =>
                gyroscopeEvent.z,
            name: 'Z',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _start() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _gyroscopeEvents = gyroscopeEvents.listen(
            (GyroscopeEvent event) {
              if (isRecording) {
                setState(() {
                  _startTime ??= event.timestamp;
                  _recordedGyroscopeEvents.add(event);
                });
              }
            },
          );
        });

        await Future.delayed(const Duration(milliseconds: 200));

        setState(() {
          _startTime = null;
          _recordedGyroscopeEvents.clear();

          isRecording = true;
        });
      },
      child: Text(
        'Start',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _stop() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _gyroscopeEvents!.cancel();
          _gyroscopeEvents = null;
          isRecording = false;
        });
      },
      child: Text(
        'Stop',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _analise() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GyroscopeAnalysisView(
              recordedGyroscopeEvents: _recordedGyroscopeEvents,
            ),
          ),
        );
      },
      child: Text(
        'Analise',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
