import 'package:flutter/material.dart';

import '../../models/coordinate_field.dart';
import '../base_input.dart';
import '../input_field_icon.dart';
import 'components/map_view.dart';

class CoordinateInput
    extends BaseStatefulInput<D2CoordinateInputConfig, D2CoordinateValue> {
  const CoordinateInput(
      {super.key,
      required super.input,
      required super.onChange,
      required super.color,
      super.disabled,
      super.value});

  @override
  State<StatefulWidget> createState() {
    return CoordinateInputState();
  }
}

class CoordinateInputState extends BaseStatefulInputState<CoordinateInput> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  void onMapOpen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CoordinateInputMapView(
              onChange: widget.onChange,
              color: widget.color,
              value: widget.value,
            )));
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.color;
    bool disabled = widget.disabled;
    return TextFormField(
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
            suffixIcon: IconButton(
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
                  iconData: Icons.location_on),
            )),
        onTap: disabled
            ? null
            : () {
                onMapOpen(context);
              });
  }
}
