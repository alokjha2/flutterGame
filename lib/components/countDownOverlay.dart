


import 'package:flutter/material.dart';

class CountdownOverlay extends StatelessWidget {
  final int? timerValue;
  final String? text;

  const CountdownOverlay({Key? key, this.timerValue, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Text(
          timerValue == null ? text! :
          timerValue.toString(),
          style: theme.headline1!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
