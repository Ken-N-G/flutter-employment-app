import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBottomModalSheet extends StatelessWidget {
  const MapBottomModalSheet({
    super.key,
    required this.initialPosition,
    required this.address,
  });

  final LatLng initialPosition;
  final String address;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 15
                    ),
                  ),
                ),
                Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),

            const SizedBox(height: 30,),

            Text(
              address,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}