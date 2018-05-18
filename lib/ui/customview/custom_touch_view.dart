import 'package:cleanflutter/ui/utils/uxhelper/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';


class CustomTouchView extends StatefulWidget {
  final double xPos;
  final double yPos;
  final ValueChanged<Offset> onChanged;

  const CustomTouchView({Key key,
    this.onChanged,
    this.xPos: 0.0,
    this.yPos: 0.0}) : super(key: key);

  @override
  _CustomTouchViewState createState() => new _CustomTouchViewState();
}

class _CustomTouchViewState extends State<CustomTouchView> {
  double xPos = 0.0;
  double yPos = 0.0;

  void onChanged(Offset offset) {
    final RenderBox referenceBox = context.findRenderObject();
    Offset position = referenceBox.globalToLocal(offset);
    if (widget.onChanged != null)
      widget.onChanged(position);
    setState(() {
      xPos = position.dx;
      yPos = position.dy;
    });
  }

  void _handlePanStart(DragStartDetails details) {
    onChanged(details.globalPosition);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    onChanged(details.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints.expand(),
      child: new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        child: new CustomPaint(
          size: new Size(xPos, yPos),
          painter: new CustomTouchPainter(xPos, yPos),
        ),
      ),
    );
  }
}

/**
 *
 * Painter class
 *
 */
class CustomTouchPainter extends CustomPainter {
  static const markerRadius = 10.0;
  final double xPos;
  final double yPos;

  CustomTouchPainter(this.xPos, this.yPos);

  @override
  void paint(Canvas canvas, Size size) {
    var path = new Path();

    path.addPolygon(
      [
        new Offset(xPos - 20, yPos),
        new Offset(xPos + 20, yPos),
        new Offset(xPos, yPos + 20),
        new Offset(xPos, yPos - 20),
      ],
      true,
    );
    path.close();

    canvas.drawPath(
        path,
        new Paint()
          ..color = AppColors.blue_bubble
          ..style = PaintingStyle.fill
    );
  }


  @override
  bool shouldRepaint(CustomTouchPainter old) =>
      xPos != old.xPos && yPos != old.yPos;
}