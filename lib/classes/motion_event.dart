// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

class MotionEvent {
  MotionEvent({
    required this.orientation,
    required this.interpolatedAcceleration,
    required this.acceleration,
    required this.velocity,
    required this.position,
    required this.timestamp,
  });

  ///The orientation of the phone in 3 axes X Y Z (radians).
  vm.Vector3 orientation;

  ///The interpolated acceleration (m/s^2).
  vm.Vector3 interpolatedAcceleration;

  ///The rotated acceleration (m/s^2).
  vm.Vector3 acceleration;

  ///The velocity (m/s).
  vm.Vector3 velocity;

  ///The rotated acceleration (m).
  vm.Vector3 position;

  ///The timestamp of this event. (ms)
  double timestamp;
}
