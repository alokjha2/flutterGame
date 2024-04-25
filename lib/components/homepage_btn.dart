


import 'package:game/exports.dart';

class RectangleButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;

  const RectangleButton({
    required this.color,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 90,
      child: ElevatedButton(
  onPressed: onPressed,
  style: ElevatedButton.styleFrom(
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 5, // Adjust the elevation value as needed
    shadowColor: Colors.black, // Specify the shadow color
  ),
  child: Text(
    text,
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  ),
),

    );
  }
}

