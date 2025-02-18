/// HSV(HSB)/HSL Color Picker example
///
/// You can create your own layout by importing `picker.dart`.

library hsv_picker;

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorBlockPicker extends StatefulWidget {
  const ColorBlockPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.pickerHsvColor,
    this.onHsvColorChanged,
    this.paletteType = PaletteType.hsvWithHue,
    this.colorPickerWidth = 300.0,
    this.pickerAreaBorderRadius = const BorderRadius.all(Radius.zero),
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final HSVColor? pickerHsvColor;
  final ValueChanged<HSVColor>? onHsvColorChanged;
  final PaletteType paletteType;
  final double colorPickerWidth;
  final BorderRadius pickerAreaBorderRadius;

  @override
  State<ColorBlockPicker> createState() => _ColorBlockPickerState();
}

class _ColorBlockPickerState extends State<ColorBlockPicker> {
  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);

  @override
  void initState() {
    currentHsvColor = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColor
        : HSVColor.fromColor(widget.pickerColor);
    super.initState();
  }

  @override
  void didUpdateWidget(ColorBlockPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentHsvColor = (widget.pickerHsvColor != null)
        ? widget.pickerHsvColor as HSVColor
        : HSVColor.fromColor(widget.pickerColor);
  }

  Widget colorPickerSlider(TrackType trackType) {
    return ColorPickerSlider(
      trackType,
      currentHsvColor,
      (HSVColor color) {
        setState(() => currentHsvColor = color);
        widget.onColorChanged(currentHsvColor.toColor());
        if (widget.onHsvColorChanged != null) {
          widget.onHsvColorChanged!(currentHsvColor);
        }
      },
      displayThumbColor: false,
    );
  }

  void onColorChanging(HSVColor color) {
    setState(() => currentHsvColor = color);
    widget.onColorChanged(currentHsvColor.toColor());
    if (widget.onHsvColorChanged != null) {
      widget.onHsvColorChanged!(currentHsvColor);
    }
  }

  Widget colorPicker() {
    return ClipRRect(
      borderRadius: widget.pickerAreaBorderRadius,
      child: ColorPickerArea(
        currentHsvColor,
        onColorChanging,
        widget.paletteType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 180,
          height: 180,
          child: colorPicker(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 32.0,
              width: widget.colorPickerWidth - 75.0,
              child: colorPickerSlider(TrackType.hue),
            ),
            SizedBox(
              height: 32.0,
              width: widget.colorPickerWidth - 75.0,
              child: colorPickerSlider(TrackType.alpha),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: widget.colorPickerWidth - 75.0,
                child: BlockPicker(
                  pickerColor: widget.pickerColor,
                  layoutBuilder: (context, colors, child) => Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: colors
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              widget.onColorChanged(e);
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: e,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  onColorChanged: widget.onColorChanged,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
