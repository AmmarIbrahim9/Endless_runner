import 'dart:math';
import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

const numRows = 8;
const numCols = 8;
const candySize = 60.0;

enum SwapDirection { horizontal, vertical }

class Candy {
  int type;
  Rect rect;
  bool isBeingRemoved;
  Candy(this.type, this.rect) : isBeingRemoved = false;

  void render(Canvas canvas, Paint paint) {
    paint.color = _getCandyColor(type);
    canvas.drawRect(rect, paint);
  }

  Color _getCandyColor(int type) {
    switch (type) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.green;
      case 5:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}

class CandyGame extends Game {
  List<List<Candy>> candies = [];
  Point<int>? selectedPoint;
  bool isDragging = false;
  SwapDirection? swapDirection;

  CandyGame() {
    initializeBoard();
  }

  void initializeBoard() {
    candies.clear();
    for (int row = 0; row < numRows; row++) {
      List<Candy> rowCandies = [];
      for (int col = 0; col < numCols; col++) {
        final candy = Candy(Random().nextInt(5) + 1, Rect.fromLTWH(col * candySize, row * candySize, candySize, candySize));
        rowCandies.add(candy);
      }
      candies.add(rowCandies);
    }
  }

  void swapCandies(Point<int> p1, Point<int> p2) {
    final temp = candies[p1.y][p1.x];
    candies[p1.y][p1.x] = candies[p2.y][p2.x];
    candies[p2.y][p2.x] = temp;
  }

  bool isValidSwap(Point<int> p1, Point<int> p2) {
    return ((p1.x == p2.x && (p1.y - p2.y).abs() == 1) || (p1.y == p2.y && (p1.x - p2.x).abs() == 1)) &&
        candies[p1.y][p1.x].type != 0 &&
        candies[p2.y][p2.x].type != 0;
  }

  bool hasMatches() {
    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
        if (col < numCols - 2 &&
            candies[row][col].type == candies[row][col + 1].type &&
            candies[row][col].type == candies[row][col + 2].type) {
          return true;
        }
        if (row < numRows - 2 &&
            candies[row][col].type == candies[row + 1][col].type &&
            candies[row][col].type == candies[row + 2][col].type) {
          return true;
        }
      }
    }
    return false;
  }

  void removeMatches() {
    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
        // Check horizontal matches
        if (col < numCols - 2 &&
            candies[row][col].type == candies[row][col + 1].type &&
            candies[row][col].type == candies[row][col + 2].type) {
          candies[row][col].isBeingRemoved = true;
          candies[row][col + 1].isBeingRemoved = true;
          candies[row][col + 2].isBeingRemoved = true;
        }
        // Check vertical matches
        if (row < numRows - 2 &&
            candies[row][col].type == candies[row + 1][col].type &&
            candies[row][col].type == candies[row + 2][col].type) {
          candies[row][col].isBeingRemoved = true;
          candies[row + 1][col].isBeingRemoved = true;
          candies[row + 2][col].isBeingRemoved = true;
        }
      }
    }
  }

  void refillBoard() {
    for (int col = 0; col < numCols; col++) {
      List<Candy> candiesToRemove = [];
      for (int row = numRows - 1; row >= 0; row--) {
        if (candies[row][col].isBeingRemoved) {
          candiesToRemove.add(candies[row][col]);
          candies[row][col] = Candy(Random().nextInt(5) + 1, Rect.fromLTWH(col * candySize, -1 * candySize, candySize, candySize));
        }
      }
      for (Candy candyToRemove in candiesToRemove) {
        candies[candyToRemove.rect.top ~/ candySize][candyToRemove.rect.left ~/ candySize] = Candy(0, Rect.zero); // Replace removed candy with empty candy
      }
    }
  }

  void onTapDown(Offset tapPosition) {
    if (!isDragging) {
      selectedPoint = Point((tapPosition.dx / candySize).floor(), (tapPosition.dy / candySize).floor());
      isDragging = true;
    } else {
      Point<int> secondPoint = Point((tapPosition.dx / candySize).floor(), (tapPosition.dy / candySize).floor());
      if (isValidSwap(selectedPoint!, secondPoint)) {
        swapCandies(selectedPoint!, secondPoint);
        if (hasMatches()) {
          removeMatches();
          refillBoard();
        } else {
          swapCandies(selectedPoint!, secondPoint); // Revert swap if no matches
        }
      }
      isDragging = false;
      selectedPoint = null;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
        if (candies[row][col].type != 0) {
          candies[row][col].render(canvas, paint);
        }
      }
    }
  }

  @override
  void update(double t) {}

  @override
  void resize(Size size) {
    // Implement resize logic if needed
  }
}
