import 'package:flutter/material.dart';

// Used in login, signup, home pages
class ConcentricCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, i * 18.0, paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class ShapeData {
  final double? left, right, top, bottom;
  final String type;
  final Color color;
  final double size;
  const ShapeData({
    this.left, this.right, this.top, this.bottom,
    required this.type, required this.color, required this.size,
  });
}

class ShapePainter extends CustomPainter {
  final String type;
  final Color color;
  const ShapePainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = color..style = PaintingStyle.stroke
      ..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    final w = size.width;
    final h = size.height;

    switch (type) {
      case 'triangle_up':
        canvas.drawPath(
            Path()..moveTo(w / 2, 0)..lineTo(w, h)..lineTo(0, h)..close(), paint);
        break;
      case 'triangle_down':
        canvas.drawPath(
            Path()..moveTo(0, 0)..lineTo(w, 0)..lineTo(w / 2, h)..close(), paint);
        break;
      case 'circle':
      case 'dot':
        canvas.drawCircle(Offset(w / 2, h / 2), w / 2, paint);
        break;
      case 'plus':
        canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, h), strokePaint);
        canvas.drawLine(Offset(0, h / 2), Offset(w, h / 2), strokePaint);
        break;
      case 'x':
        canvas.drawLine(Offset(0, 0), Offset(w, h), strokePaint);
        canvas.drawLine(Offset(w, 0), Offset(0, h), strokePaint);
        break;
      case 'lines':
        for (int i = 0; i < 4; i++) {
          final y = i * (h / 4) + h / 8;
          canvas.drawLine(Offset(0, y), Offset(w, y), strokePaint);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

TextFormField buildPinkField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscureText = false,
  Widget? suffixIcon,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    validator: validator,
    style: const TextStyle(color: Colors.white, fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.white70, size: 18),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFd63384),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.white38, width: 1)),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 10),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.redAccent)),
    ),
  );
}