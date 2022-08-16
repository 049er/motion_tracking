import 'package:motion_tracking/classes/classes_export.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../functions/functions.dart';

class Analysis {
  Analysis({
    required this.recordedGyroscopeEvents,
    required this.recordedUserAccelerometerEvents,
    required this.filter,
  }) {
    interpolatedGyroscopeEvents =
        interpolateGyroscopeEvents(recordedGyroscopeEvents);

    calculatedOrientations = calculateOrientation(interpolatedGyroscopeEvents);

    interpolatedUserAccelerometerEvents = interpolateUserAccelerometerEvents(
        recordedUserAccelerometerEvents, filter);

    rotatedUserAccelerometerEvents = rotateInterpolatedUserAccelerometerEvents(
      interpolatedUserAccelerometerEvents: interpolatedUserAccelerometerEvents,
      calculatedOrientations: calculatedOrientations,
    );

    velocities = calculateVelocities(rotatedUserAccelerometerEvents);

    positions = calculatePositions(velocities);

    motionEvents = findMotionEvents(
        orientations: calculatedOrientations,
        accelerometerEvents: interpolatedUserAccelerometerEvents,
        rotatedAccelerometerEvents: rotatedUserAccelerometerEvents,
        velocities: velocities,
        positions: positions);
  }

  final double filter;

  ///List of the recorded UserAccelerometerEvents.
  final List<UserAccelerometerEvent> recordedUserAccelerometerEvents;

  ///List of the recorded RecordedGyroscopeEvents.
  final List<GyroscopeEvent> recordedGyroscopeEvents;

  ///List of calculated OrientationEvents.
  late List<InterpolatedGyroscopeEvent> interpolatedGyroscopeEvents;

  ///List of calculated Orientations.
  late List<CalculatedOrientation> calculatedOrientations;

  ///List of InterpolatedUserAccelerometerEvent.
  late List<InterpolatedUserAccelerometerEvent>
      interpolatedUserAccelerometerEvents;

  ///List of RotatedInterpolatedUserAccelerometerEvents.
  late List<RotatedUserAccelerometerEvent> rotatedUserAccelerometerEvents;

  ///List of Velocity.
  late List<Velocity> velocities;

  ///List of Position.
  late List<Position> positions;

  ///List of Position.
  late List<MotionEvent> motionEvents;
}
