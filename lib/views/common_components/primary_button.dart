import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key, required this.label, required this.onPressed});

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    const foregroundColor = Colors.white;
    const paddingVertical = 16.0;
    const paddingHorizontal = 16.0;



    
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: foregroundColor,
            backgroundColor: Theme.of(context).primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Center(
            child: Text(label),
          ),
        ));
  }
}
