// ignore_for_file: depend_on_referenced_packages

import 'package:motion_tracking/classes/classes_export.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

///Calculate and Interoplate the phones orientation at every millisecond***.
List<InterpolatedGyroscopeEvent> interpolateGyroscopeEvents(
  List<GyroscopeEvent> recordedGyroscopeEvents,
) {
  List<InterpolatedGyroscopeEvent> interpolatedGyroscopeEvents = [];
  // log('Gyroscope Events: ${recordedGyroscopeEvents.length}');
  // log('Start: ${recordedGyroscopeEvents.first.timestamp}');
  // log('End: ${recordedGyroscopeEvents.last.timestamp}');

  //Sort recordedGyroscopeEvents in acending order.
  recordedGyroscopeEvents.sort((a, b) => a.timestamp.compareTo(b.timestamp));

  for (int i = 1; i < recordedGyroscopeEvents.length; i++) {
    GyroscopeEvent currentGyroscopeEvent = recordedGyroscopeEvents[i];
    GyroscopeEvent previousGyroscopeEvent = recordedGyroscopeEvents[i - 1];

    //Change in time from the previous event to this one.
    double timeDelta =
        currentGyroscopeEvent.timestamp - previousGyroscopeEvent.timestamp;

    //m = change in y / change in x
    vm.Vector3 gradient = vm.Vector3(
      (currentGyroscopeEvent.x - previousGyroscopeEvent.x) /
          (currentGyroscopeEvent.timestamp - previousGyroscopeEvent.timestamp),
      (currentGyroscopeEvent.y - previousGyroscopeEvent.y) /
          (currentGyroscopeEvent.timestamp - previousGyroscopeEvent.timestamp),
      (currentGyroscopeEvent.z - previousGyroscopeEvent.z) /
          (currentGyroscopeEvent.timestamp - previousGyroscopeEvent.timestamp),
    );

    //c = y - m*x
    vm.Vector3 constant = vm.Vector3(
      currentGyroscopeEvent.x - gradient.x * currentGyroscopeEvent.timestamp,
      currentGyroscopeEvent.y - gradient.y * currentGyroscopeEvent.timestamp,
      currentGyroscopeEvent.z - gradient.z * currentGyroscopeEvent.timestamp,
    );

    for (int k = 0; k < timeDelta.toInt(); k++) {
      double interpolatedTimestamp = previousGyroscopeEvent.timestamp + k;
      //y = mx + c

      InterpolatedGyroscopeEvent orientationEvent = InterpolatedGyroscopeEvent(
        rotationRate: vm.Vector3(
          gradient.x * interpolatedTimestamp + constant.x,
          gradient.y * interpolatedTimestamp + constant.y,
          gradient.z * interpolatedTimestamp + constant.z,
        ),
        timestamp: interpolatedTimestamp,
      );
      interpolatedGyroscopeEvents.add(orientationEvent);
    }
  }

  // log(orientationEvents.toString());
  // log(orientationEvents.length.toString());
  return interpolatedGyroscopeEvents;
}

///Calculates the orientation of the phone at every orientationEvent.
List<CalculatedOrientation> calculateOrientation(
  List<InterpolatedGyroscopeEvent> orientationEvents,
) {
  List<CalculatedOrientation> orientations = [];

  vm.Vector3 currentOrientation = vm.Vector3(0, 0, 0);
  for (InterpolatedGyroscopeEvent orientationEvent in orientationEvents) {
    currentOrientation.add(orientationEvent.rotationRate.scaled(0.001));

    CalculatedOrientation orientation = CalculatedOrientation(
      orientation: currentOrientation.clone(),
      timestamp: orientationEvent.timestamp,
    );

    orientations.add(orientation);
  }

  return orientations;
}

List<InterpolatedUserAccelerometerEvent> interpolateUserAccelerometerEvents(
  List<UserAccelerometerEvent> recordedUserAccelerometerEvents,
  double lowPassFilter,
) {
  List<InterpolatedUserAccelerometerEvent> interpolatedUserAccelerometerEvents =
      [];

  //Sort recordedUserAccelerometerEvents in acending order.
  recordedUserAccelerometerEvents
      .sort((a, b) => a.timestamp.compareTo(b.timestamp));

  for (int i = 1; i < recordedUserAccelerometerEvents.length; i++) {
    UserAccelerometerEvent currentUserAccelerometerEvent =
        recordedUserAccelerometerEvents[i];

    UserAccelerometerEvent previousUserAccelerometerEvent =
        recordedUserAccelerometerEvents[i - 1];

    double timeDelta = currentUserAccelerometerEvent.timestamp -
        previousUserAccelerometerEvent.timestamp;

    //m = change in y / change in x
    vm.Vector3 gradient = vm.Vector3(
      (currentUserAccelerometerEvent.x - previousUserAccelerometerEvent.x) /
          (currentUserAccelerometerEvent.timestamp -
              previousUserAccelerometerEvent.timestamp),
      (currentUserAccelerometerEvent.y - previousUserAccelerometerEvent.y) /
          (currentUserAccelerometerEvent.timestamp -
              previousUserAccelerometerEvent.timestamp),
      (currentUserAccelerometerEvent.z - previousUserAccelerometerEvent.z) /
          (currentUserAccelerometerEvent.timestamp -
              previousUserAccelerometerEvent.timestamp),
    );

    //c = y - m * x
    vm.Vector3 constant = vm.Vector3(
      currentUserAccelerometerEvent.x -
          gradient.x * currentUserAccelerometerEvent.timestamp,
      currentUserAccelerometerEvent.y -
          gradient.y * currentUserAccelerometerEvent.timestamp,
      currentUserAccelerometerEvent.z -
          gradient.z * currentUserAccelerometerEvent.timestamp,
    );

    for (int k = 0; k < timeDelta.toInt(); k++) {
      double interpolatedTimestamp =
          previousUserAccelerometerEvent.timestamp + k;
      //y = mx + c

      double xAcceleration = gradient.x * interpolatedTimestamp + constant.x;
      double yAcceleration = gradient.y * interpolatedTimestamp + constant.y;
      double zAcceleration = gradient.z * interpolatedTimestamp + constant.z;

      InterpolatedUserAccelerometerEvent interpolatedUserAccelerometerEvent =
          InterpolatedUserAccelerometerEvent(
        acceleration: vm.Vector3(
          xAcceleration > lowPassFilter || xAcceleration < -lowPassFilter
              ? xAcceleration
              : 0,
          yAcceleration > lowPassFilter || yAcceleration < -lowPassFilter
              ? yAcceleration
              : 0,
          zAcceleration > lowPassFilter || zAcceleration < -lowPassFilter
              ? zAcceleration
              : 0,
        ),
        timestamp: interpolatedTimestamp,
      );

      // log(interpolatedUserAccelerometerEvent.toString());

      // log(interpolatedUserAccelerometerEvent.toString());
      interpolatedUserAccelerometerEvents
          .add(interpolatedUserAccelerometerEvent);
    }
  }

  return interpolatedUserAccelerometerEvents;
}

List<RotatedUserAccelerometerEvent> rotateInterpolatedUserAccelerometerEvents({
  required List<InterpolatedUserAccelerometerEvent>
      interpolatedUserAccelerometerEvents,
  required List<CalculatedOrientation> calculatedOrientations,
}) {
  List<RotatedUserAccelerometerEvent> rotatedUserAccelerometerEvents = [];

  //Sort caluclatedOrientations in acending order.
  calculatedOrientations.sort((a, b) => b.timestamp.compareTo(a.timestamp));

  //Sort interpolatedUserAccelerometerEvents in acending order.
  interpolatedUserAccelerometerEvents
      .sort((a, b) => a.timestamp.compareTo(b.timestamp));

  for (InterpolatedUserAccelerometerEvent interpolatedUserAccelerometerEvent
      in interpolatedUserAccelerometerEvents) {
    //Find the first calculatedOrientation which timestamp is == the interpolatedUserAccelerometerEvent's timestamp

    int index = calculatedOrientations.indexWhere((element) =>
        element.timestamp == interpolatedUserAccelerometerEvent.timestamp);

    CalculatedOrientation calculatedOrientation;
    if (index == -1) {
      calculatedOrientation = CalculatedOrientation(
          orientation: vm.Vector3(0, 0, 0),
          timestamp: interpolatedUserAccelerometerEvent.timestamp);
    } else {
      calculatedOrientation = calculatedOrientations[index];
    }

    //Rotation Matrix.
    vm.Matrix4 rotationMatrix = vm.Matrix4.identity()
      ..rotateX(calculatedOrientation.orientation.x)
      ..rotateY(calculatedOrientation.orientation.y)
      ..rotateZ(calculatedOrientation.orientation.z);

    //Acceleration Vector.
    vm.Vector3 accelerationVector =
        interpolatedUserAccelerometerEvent.acceleration.clone();

    //Create RotatedUserAccelerometerEvent.
    RotatedUserAccelerometerEvent rotatedUserAccelerometerEvent =
        RotatedUserAccelerometerEvent(
      acceleration: rotationMatrix.transform3(accelerationVector),
      orientation: calculatedOrientation.orientation.clone(),
      timestamp: interpolatedUserAccelerometerEvent.timestamp,
    );
    // log(calculatedOrientation.orientation.toString());

    //Add to list.
    rotatedUserAccelerometerEvents.add(rotatedUserAccelerometerEvent);
  }

  return rotatedUserAccelerometerEvents;
}

List<Velocity> calculateVelocities(
  List<RotatedUserAccelerometerEvent> rotatedUserAccelerometerEvents,
) {
  List<Velocity> calculatedVelocities = [];

  vm.Vector3 currentVelocity = vm.Vector3(0, 0, 0);
  for (RotatedUserAccelerometerEvent rotatedUserAccelerometerEvent
      in rotatedUserAccelerometerEvents) {
    //Calculate the change in velocity.
    vm.Vector3 velocityDelta = vm.Vector3(
      rotatedUserAccelerometerEvent.acceleration.x * 0.001,
      rotatedUserAccelerometerEvent.acceleration.y * 0.001,
      rotatedUserAccelerometerEvent.acceleration.z * 0.001,
    );

    //Add to currentVelocity.
    currentVelocity.add(velocityDelta);
    // log(currentVelocity.toString());

    Velocity calculatedVelocity = Velocity(
      velocity: currentVelocity.clone(),
      timestamp: rotatedUserAccelerometerEvent.timestamp,
    );

    //add to list.
    calculatedVelocities.add(calculatedVelocity);
  }

  return calculatedVelocities;
}

List<Position> calculatePositions(
  List<Velocity> velocities,
) {
  List<Position> positions = [];
  vm.Vector3 currentPosition = vm.Vector3(0, 0, 0);

  for (int i = 1; i < velocities.length; i++) {
    Velocity currentVelocity = velocities[i];
    Velocity previousVelocity = velocities[i - 1];

    //Calculate the change in position.
    vm.Vector3 positionDelta = vm.Vector3(
      ((currentVelocity.velocity.x + previousVelocity.velocity.x) / 2) * 0.001,
      ((currentVelocity.velocity.y + previousVelocity.velocity.y) / 2) * 0.001,
      ((currentVelocity.velocity.z + previousVelocity.velocity.z) / 2) * 0.001,
    );

    //Add to list.
    currentPosition.add(positionDelta);

    // ignore: todo
    //TODO: confirm timestamp
    Position position = Position(
      position: currentPosition.clone(),
      timestamp: currentVelocity.timestamp,
    );

    positions.add(position);
  }

  return positions;
}

List<MotionEvent> findMotionEvents({
  required List<CalculatedOrientation> orientations,
  required List<InterpolatedUserAccelerometerEvent> accelerometerEvents,
  required List<RotatedUserAccelerometerEvent> rotatedAccelerometerEvents,
  required List<Velocity> velocities,
  required List<Position> positions,
}) {
  List<MotionEvent> motionEvents = [];
  for (Position position in positions) {
    int orientationIndex = orientations
        .indexWhere((element) => element.timestamp == position.timestamp);

    CalculatedOrientation calculatedOrientation;

    if (orientationIndex == -1) {
      calculatedOrientation = CalculatedOrientation(
          orientation: vm.Vector3(0, 0, 0), timestamp: position.timestamp);
    } else {
      calculatedOrientation = orientations[orientationIndex];
    }

    motionEvents.add(MotionEvent(
      orientation: calculatedOrientation.orientation,
      interpolatedAcceleration: accelerometerEvents
          .firstWhere((element) => element.timestamp == position.timestamp)
          .acceleration,
      acceleration: rotatedAccelerometerEvents
          .firstWhere((element) => element.timestamp == position.timestamp)
          .acceleration,
      velocity: velocities
          .firstWhere((element) => element.timestamp == position.timestamp)
          .velocity,
      position: position.position,
      timestamp: position.timestamp,
    ));
  }
  return motionEvents;
}
