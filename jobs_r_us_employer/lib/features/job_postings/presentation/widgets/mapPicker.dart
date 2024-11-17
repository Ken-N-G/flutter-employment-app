import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobs_r_us_employer/general_widgets/customSearchField.dart';
import 'package:jobs_r_us_employer/general_widgets/primaryButton.dart';
import 'package:jobs_r_us_employer/general_widgets/secondaryButton.dart';

class MapPicker extends StatefulWidget {
  const MapPicker({
    super.key,
    required this.onLocationSave,
    required this.jobCoordinates
  });

  final Function(String, LatLng) onLocationSave;
  final LatLng? jobCoordinates;

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  String address = "";

  late TextEditingController locationSearchController;
  List<Location> locations = [];
  Completer<GoogleMapController> _controller = Completer();
  late LatLng currentCameraPosition;

  @override
  void initState() {
    // TODO: implement initState
    locationSearchController = TextEditingController();
    currentCameraPosition = const LatLng(-6.1934095, 106.8228579);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    locationSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        child: Stack(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 10,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: CustomSearchField(
                        hintText: "Search Location",
                        controller: locationSearchController,
                      ),
                    ),
                                      
                    const SizedBox(
                      width: 10,
                    ),
                    SecondaryButton(
                      child: Icon(
                        Icons.search_rounded,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        locations = await GeocodingPlatform.instance!.locationFromAddress(locationSearchController.text);
                        print(locations.length);
                        final coordinates = LatLng(locations.first.latitude, locations.first.longitude);
                        final searchedPosition = CameraPosition(
                          target: coordinates,
                          zoom: 15
                        );
                        _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(searchedPosition)));
                      }
                    )
                  ],
                ),
                                      
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: GoogleMap(
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                          target: widget.jobCoordinates ?? currentCameraPosition,
                          zoom: 15
                        ),
                        onMapCreated: (controller) {
                          _controller = Completer<GoogleMapController>();
                          address = "";
                          if (!_controller.isCompleted) {
                            _controller.complete(controller);
                          }
                        },
                        onCameraMove: (position) {
                          currentCameraPosition = position.target;
                        },
                        onCameraIdle: () async {
                          currentCameraPosition;
                          final placemarks = await GeocodingPlatform.instance!.placemarkFromCoordinates(currentCameraPosition.latitude, currentCameraPosition.longitude);
                          setState(() {
                            address = "${placemarks.first.name}, ${placemarks.first.street}, ${placemarks.first.locality} ${placemarks.first.administrativeArea}, ${placemarks.first.postalCode}";   
                          });
                        },
                      ),
                    ),
                    Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
            
                Text(
                  address,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                children: [
                  PrimaryButton(
                    label: "Save Location", 
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final placemarks = await GeocodingPlatform.instance!.placemarkFromCoordinates(currentCameraPosition.latitude, currentCameraPosition.longitude);
                      address = "${placemarks.first.name}, ${placemarks.first.street}, ${placemarks.first.locality} ${placemarks.first.administrativeArea}, ${placemarks.first.postalCode}";
                      if (context.mounted) {
                        widget.onLocationSave(address, currentCameraPosition);
                        Navigator.pop(context);
                      }
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}