


import 'package:flutter/material.dart';

class CountdownOverlay extends StatelessWidget {
  final int timerValue;

  const CountdownOverlay({Key? key, required this.timerValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Text(
          timerValue.toString(),
          style: theme.headline1!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
