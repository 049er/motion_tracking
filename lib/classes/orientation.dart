// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;
import 'dart:math' as m;

///This is the orientation of the phone at a given instant.
class CalculatedOrientation {
  CalculatedOrientation({
    required this.orientation,
    required this.timestamp,
  });

  ///The orientation of the phone in 3 axes X Y Z (radians).
  vm.Vector3 orientation;

  ///The timestamp of this event. (ms)
  double timestamp;

  @override
  String toString() {
    return 'timestamp: $timestamp, orientation(°): ${orientation.x * (180 / m.pi)}, ${orientation.y * (180 / m.pi)}, ${orientation.z * (180 / m.pi)} \n';
  }
}
