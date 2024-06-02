


import 'package:game/exports.dart';
import 'package:nice_buttons/nice_buttons.dart';

class HomeFancyButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onPressed;
  final Widget? child;
  final double width;

  const HomeFancyButton(
      {Key? key,
      required this.text,
      required this.color,
      required this.onPressed,
      this.child,
      this.width = 220})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    NiceButtons(
      stretch: true,
      gradientOrientation: GradientOrientation.Horizontal,
      child: SizedBox(
        width: width,
        child: Text(text),
      ),
      startColor: color,
      endColor: color,
      onTap: onPressed,
    );
  }
}