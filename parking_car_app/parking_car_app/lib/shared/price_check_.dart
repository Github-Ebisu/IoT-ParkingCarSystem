import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking_car_app/shared/colors.dart';

class PriceCheckbox extends StatefulWidget {
  final double width;
  final double height;
  final double iconSize;
  final String label;
  final bool isChecked;
  final int value;
  final int? groupValue;
  final ValueChanged<int?> onChanged;

  const PriceCheckbox({
    Key? key,
    required this.width,
    required this.height,
    required this.iconSize,
    required this.label,
    required this.isChecked,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PriceCheckbox> createState() => _PriceCheckboxState();
}

class _PriceCheckboxState extends State<PriceCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(widget.value);
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: widget.groupValue == widget.value ? flexSchemeLight.primary : SecondaryHeader,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            if (widget.groupValue == widget.value)
              Positioned(
                right: 4.0,
                top: 4.0,
                child: Container(
                  width: widget.iconSize,
                  height: widget.iconSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: widget.iconSize * 0.75,
                  ),
                ),
              ),
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.groupValue == widget.value ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
