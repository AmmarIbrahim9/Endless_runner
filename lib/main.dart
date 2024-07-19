import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'candygame.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: GameWidget(),
    ),
  ));
}

class GameWidget extends StatelessWidget {
  final CandyGame game = CandyGame(); // Instantiate your CandyGame

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        // Pass the tap position to the game's onTapDown method
        game.onTapDown(details.localPosition);
      },
      child: Center(
        child: Container(
          width: 480, // Adjust dimensions as needed
          height: 800, // Adjust dimensions as needed
          child: CustomPaint(
            size: Size(480, 800),
            painter: GameWidgetOverlay(game: game),
          ),
        ),
      ),
    );
  }
}

class GameWidgetOverlay extends CustomPainter {
  final CandyGame game;

  GameWidgetOverlay({required this.game});

  @override
  void paint(Canvas canvas, Size size) {
    // Implement your game rendering logic using the provided canvas and size
    game.render(canvas); // Use CandyGame's render method to draw on the canvas
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for simplicity, adjust as needed
  }
}
