// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

///This is an interpolated GyroscopeEvent.
class InterpolatedGyroscopeEvent {
  InterpolatedGyroscopeEvent({
    required this.rotationRate,
    required this.timestamp,
  });

  ///The interpolated rate of rotation of the phone in 3 axes X Y Z (rad/s).
  vm.Vector3 rotationRate;

  ///The timestamp of this event. (ms)
  double timestamp;

  @override
  String toString() {
    return 'timestamp: $timestamp, rotationRate (rad/s): $rotationRate \n';
  }
}
