import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/coordinate_field.dart';

class CoordinateInputMapView extends StatefulWidget {
  final Color color;
  final D2CoordinateValue? value;
  final OnChange<D2CoordinateValue> onChange;

  const CoordinateInputMapView(
      {super.key, required this.color, this.value, required this.onChange});

  @override
  State<CoordinateInputMapView> createState() => _CoordinateInputMapViewState();
}

class _CoordinateInputMapViewState extends State<CoordinateInputMapView> {
  bool _loading = true;
  LatLng? currentLocation;

  LatLng? selectedLocation;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    setState(() {
      _loading = true;
    });
    try {
      Position location = await _determinePosition();
      setState(() {
        currentLocation = LatLng(location.latitude, location.longitude);
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Could not get current position");
      }
      Position? location = await Geolocator.getLastKnownPosition();
      if (location != null) {
        setState(() {
          currentLocation = LatLng(location.latitude, location.longitude);
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: getTextColor(widget.color),
        backgroundColor: widget.color,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: getTextColor(widget.color),
            fontSize: 24),
        title: const Text('Select Location'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: widget.color,
              ),
            )
          : FlutterMap(
              options: MapOptions(
                  initialRotation: 0,
                  onTap: (TapPosition pos, LatLng position) {
                    setState(() {
                      selectedLocation = position;
                    });
                  },
                  initialCameraFit: currentLocation != null
                      ? CameraFit.coordinates(coordinates: [currentLocation!])
                      : null,
                  initialCenter: LatLng(currentLocation?.latitude ?? 30,
                      currentLocation?.longitude ?? 32)),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.hisptanzania.dhis2_flutter_toolkit',
                  // Plenty of other options available!
                ),
                selectedLocation == null
                    ? Container()
                    : MarkerLayer(markers: [
                        Marker(
                            point: selectedLocation!,
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Icons.location_on,
                              color: widget.color,
                              size: 64,
                            ))
                      ]),
              ],
            ),
      floatingActionButton: selectedLocation == null
          ? null
          : FloatingActionButton(
              focusColor: widget.color,
              backgroundColor: Colors.white,
              onPressed: () {
                final selectedLocation = this.selectedLocation;
                if (selectedLocation != null) {
                  widget.onChange(D2CoordinateValue(
                      selectedLocation.latitude, selectedLocation.longitude));
                  Navigator.of(context).pop();
                }
              },
              child: Icon(Icons.check, color: widget.color),
            ),
    );
  }
}
