// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vm;

class Velocity {
  Velocity({
    required this.velocity,
    required this.timestamp,
  });

  ///The velocity (m/s).
  vm.Vector3 velocity;

  ///The timestamp of this event. (ms)
  double timestamp;

  @override
  String toString() {
    return 'timestamp: $timestamp, velocity (m/s): $velocity \n';
  }
}
