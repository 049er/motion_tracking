// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

class Position {
  Position({
    required this.position,
    required this.timestamp,
  });

  ///The rotated acceleration (m).
  vm.Vector3 position;

  ///The timestamp of this event. (ms)
  double timestamp;

  @override
  String toString() {
    return 'timestamp: $timestamp, position (m): $position \n';
  }
}
