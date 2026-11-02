import 'package:flutter/widgets.dart';

/// The kit's side view of a car, a stand-in for the driver's own vehicle. Decoration only: hidden from screen readers, so the make, model and plate beside it carry the meaning.
class VehicleImage extends StatelessWidget {
  const VehicleImage({super.key, this.height = 72, this.width});

  final double? height;

  /// Give a width instead of a height to fill a space, keeping the picture's shape.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Image.asset('assets/images/car-side.png', package: 'turbo_ui', height: height, width: width, fit: BoxFit.contain),
    );
  }
}
