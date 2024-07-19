import 'dart:ui';

class Candy {
  final int type; // Type of candy (1-5 for different colors)
  final Rect rect; // Position and size of the candy
  bool isBeingRemoved; // Whether the candy is in the process of being removed

  Candy(this.type, this.rect, {this.isBeingRemoved = false});

  void render(Canvas canvas, Paint paint) {
    canvas.drawRect(rect, paint);
  }
}
