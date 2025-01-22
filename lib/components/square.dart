import 'package:flutter/material.dart';
import 'package:myapp/config/theme.dart';

class Square extends StatelessWidget {
  final String? value;
  final void Function()? onTap;
  const Square({super.key, this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 4, color: foregroundColorLight),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            value.toString(),
            style: textStyleDarkLarge,
          ),
        ),
      ),
    );
  }
}
