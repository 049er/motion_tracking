import 'package:motion_tracking/classes/classes_export.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../functions/functions.dart';

class GyroscopeAnalysis {
  GyroscopeAnalysis({
    required this.recordedGyroscopeEvents,
  }) {
    interpolatedGyroscopeEvents =
        interpolateGyroscopeEvents(recordedGyroscopeEvents);

    calculatedOrientations = calculateOrientation(interpolatedGyroscopeEvents);
  }

  ///List of the recorded RecordedGyroscopeEvents.
  final List<GyroscopeEvent> recordedGyroscopeEvents;

  ///List of calculated OrientationEvents.
  late List<InterpolatedGyroscopeEvent> interpolatedGyroscopeEvents;

  ///List of calculated Orientations.
  late List<CalculatedOrientation> calculatedOrientations;
}
