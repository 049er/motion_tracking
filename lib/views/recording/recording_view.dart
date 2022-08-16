import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../analysis/analysis_view.dart';

class RecordingView extends StatefulWidget {
  const RecordingView({Key? key}) : super(key: key);

  @override
  State<RecordingView> createState() => _RecordingViewState();
}

class _RecordingViewState extends State<RecordingView> {
  //Stream Subscriptions.
  late StreamSubscription<UserAccelerometerEvent> _userAccelerometerEvents;
  late StreamSubscription<GyroscopeEvent> _gyroscopeEvents;

  bool isRecoding = false;

  final List<UserAccelerometerEvent> _recordedUserAccelerometerEvents = [];
  final List<GyroscopeEvent> _recordedGyroscopeEvents = [];

  final TextEditingController _filterContoller = TextEditingController();

  double? startTime;
  double filter = 0.0;

  @override
  void initState() {
    _startStreams();
    _filterContoller.text = filter.toString();
    super.initState();
  }

  @override
  void dispose() {
    //Cancel StreamSubscriptions.

    _userAccelerometerEvents.cancel();
    _gyroscopeEvents.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      resizeToAvoidBottomInset: true,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Motion Recording',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _startRecordingButton(),
            _lineChart(),
            _stopRecordingButton(),
            _filter(),
            _analyseButton(),
          ],
        ),
      ),
    );
  }

  Widget _startRecordingButton() {
    return Visibility(
      visible: !isRecoding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                isRecoding = true;
              });
            },
            child: Text(
              'Start Recording',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _recordedGyroscopeEvents.clear();
                _recordedUserAccelerometerEvents.clear();
                startTime = null;
              });
            },
            child: Text(
              'Clear',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stopRecordingButton() {
    return Visibility(
      visible: isRecoding,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isRecoding = false;
          });
        },
        child: Text(
          'Stop Recording',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _analyseButton() {
    return Visibility(
      visible: !isRecoding &&
          _recordedGyroscopeEvents.isNotEmpty &&
          _recordedUserAccelerometerEvents.isNotEmpty,
      child: ElevatedButton(
        onPressed: () {
          List<UserAccelerometerEvent> cleanedUserAccelerometerData =
              _recordedUserAccelerometerEvents;

          List<GyroscopeEvent> cleanedGyroscopeEvents =
              _recordedGyroscopeEvents;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnalysisView(
                recordedUserAccelerometerEvents: cleanedUserAccelerometerData,
                recordedGyroscopeEvents: cleanedGyroscopeEvents,
                filter: filter,
              ),
            ),
          );
        },
        child: Text(
          'Analise',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _filter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              'Filter Value: ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Flexible(
              child: TextFormField(
                controller: _filterContoller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onFieldSubmitted: (value) {
                  setState(() {
                    filter = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lineChart() {
    return Card(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'Accelerometer'),
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

  void _startStreams() {
    setState(() {
      //Start GyroscopeEvents.
      _gyroscopeEvents = gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          if (isRecoding) {
            setState(() {
              _recordedGyroscopeEvents.add(event);
            });
          }
        },
      );
      //Start userAccelemoterEvents.
      _userAccelerometerEvents = userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          if (isRecoding) {
            setState(() {
              startTime ??= event.timestamp;
              _recordedUserAccelerometerEvents.add(event);
            });
          }
        },
      );
    });
  }
}
