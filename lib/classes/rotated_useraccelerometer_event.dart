// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

///This is a rotated UserAccelerometerEvent.
class RotatedUserAccelerometerEvent {
  RotatedUserAccelerometerEvent({
    required this.acceleration,
    required this.orientation,
    required this.timestamp,
  });

  ///The rotated acceleration (m/s^2).
  vm.Vector3 acceleration;

  ///The orientation of the phone at this position (rad).
  vm.Vector3 orientation;

  ///The timestamp of this event. (ms)
  double timestamp;

  @override
  String toString() {
    return 'timestamp: $timestamp, acceleration (m/s^2): $acceleration \n';
  }
}
