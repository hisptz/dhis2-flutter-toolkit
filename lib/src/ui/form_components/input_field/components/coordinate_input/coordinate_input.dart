import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/coordinate_field.dart';
import '../../utils/location.dart';
import '../base_input.dart';
import '../input_field_icon.dart';
import 'components/map_view.dart';

class CoordinateInput
    extends BaseStatefulInput<D2GeometryInputConfig, D2GeometryValue> {
  const CoordinateInput(
      {super.key,
      required super.input,
      required super.onChange,
      required super.color,
      super.disabled,
      super.value,
      required super.decoration});

  @override
  State<StatefulWidget> createState() {
    return CoordinateInputState();
  }
}

class CoordinateInputState extends BaseStatefulInputState<CoordinateInput> {
  late final TextEditingController controller;
  bool _loadingLocation = false;
  String? error;

  void onGetCurrentLocation() async {
    setState(() {
      _loadingLocation = true;
    });
    try {
      Position position = await determinePosition();
      onChange(D2GeometryValue(position.latitude, position.longitude));
      setState(() {
        _loadingLocation = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        _loadingLocation = false;
      });
    }
  }

  @override
  void initState() {
    controller = TextEditingController(text: widget.value?.toString());
    super.initState();
    if(widget.input.enableAutoLocation && widget.value == null) {
      onGetCurrentLocation();
    }
  }

  onChange(D2GeometryValue value) {
    widget.onChange(value);
    controller.text = value.toString();
  }

  void onMapOpen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CoordinateInputMapView(
              onChange: onChange,
              color: widget.color,
              value: widget.value,
            )));
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.color;
    bool disabled = widget.disabled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
            cursorColor: color,
            enabled: !disabled,
            showCursor: false,
            controller: controller,
            keyboardType: TextInputType.none,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIconConstraints:
                  iconConstraints.copyWith(minWidth: 96, maxWidth: 96),
              suffixIcon: Row(
                mainAxisAlignment: widget.input.disableMap
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    color: color,
                    padding: EdgeInsets.zero,
                    constraints: iconConstraints,
                    onPressed: disabled || _loadingLocation
                        ? null
                        : () {
                            onGetCurrentLocation();
                          },
                    icon: _loadingLocation
                        ? Container(
                            padding: const EdgeInsets.only(right: 5, top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(7))),
                              child: Center(
                                child: SizedBox(
                                  height: 16.0,
                                  width: 16.0,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 4,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : InputFieldIcon(
                            backgroundColor: color,
                            iconColor: color,
                            iconData: Icons.location_on),
                  ),
                  Visibility(
                    maintainSize: false,
                    visible: !widget.input.disableMap,
                    child: IconButton(
                      color: color,
                      padding: EdgeInsets.zero,
                      constraints: iconConstraints,
                      onPressed: disabled
                          ? null
                          : () {
                              onMapOpen(context);
                            },
                      icon: InputFieldIcon(
                          backgroundColor: color,
                          iconColor: color,
                          iconData: Icons.map_sharp),
                    ),
                  ),
                ],
              ),
            ),
            onTap: disabled
                ? null
                : () {
                    onMapOpen(context);
                  }),
        error != null
            ? Text(
                error!,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              )
            : Container()
      ],
    );
  }
}
