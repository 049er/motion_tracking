// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

/// This is an interpolated UserAccelerometerEvent.
class InterpolatedUserAccelerometerEvent {
  InterpolatedUserAccelerometerEvent({
    required this.acceleration,
    required this.timestamp,
  });

  ///The interpolated acceleration (m/s^2).
  vm.Vector3 acceleration;

  ///The timestamp of this event. (ms)
  double timestamp;

  @override
  String toString() {
    return 'timestamp: $timestamp, acceleration (m/s^2): $acceleration \n';
  }
}
