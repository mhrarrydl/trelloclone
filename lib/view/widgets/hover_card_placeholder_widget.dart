import 'package:flutter/material.dart';

class HoveringCardPlaceHolder extends StatelessWidget {
  final Color color;
  const HoveringCardPlaceHolder({
    super.key,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: double.maxFinite,
      height: 70,
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
