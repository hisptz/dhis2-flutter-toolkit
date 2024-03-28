import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/coordinate_field.dart';
import '../../../utils/location.dart';

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
  bool _loading = false;
  LatLng? currentLocation;
  LatLng? selectedLocation;

  void getCurrentLocation() async {
    setState(() {
      _loading = true;
    });
    try {
      Position location = await determinePosition();
      setState(() {
        currentLocation = LatLng(location.latitude, location.longitude);
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Could not get current position");
      }
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    if (widget.value != null) {
      selectedLocation =
          LatLng(widget.value!.latitude, widget.value!.longitude);
    }
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
