import 'package:flutter/material.dart';

class SecondaryButtton extends StatelessWidget {
  const SecondaryButtton(
      {super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final void Function() onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    const paddingVertical = 16.0;
    const iconSpacing = 12.0;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black))),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: paddingVertical),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon!,
                const SizedBox(
                  width: iconSpacing,
                ),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ));
  }
}
