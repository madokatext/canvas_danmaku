import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract base class BaseDanmakuPainter extends CustomPainter {
  final int length;
  final double fontSize;
  final int fontWeight;
  final String fontFamily;
  final List<String> fontFamilyFallback;
  final double strokeWidth;
  final double shadowRadius;
  final bool running;
  final int batchThreshold;
  final int tick;

  static final Paint _paint = Paint()
    ..filterQuality = FilterQuality.low;

  const BaseDanmakuPainter({
    required this.length,
    required this.fontSize,
    required this.fontWeight,
    required this.fontFamily,
    required this.fontFamilyFallback,
    required this.strokeWidth,
    this.shadowRadius = 0,
    required this.running,
    required this.tick,
    this.batchThreshold = 10, // 默认值为10，可以自行调整
  });

  static void paintImg(
  Canvas canvas,
  DanmakuItem item,
  double dx,
  double dy,
) {
  final img = item.image!;
  final overflow = item.effectOverflow;

  // 实际图片包含逻辑包围盒之外的阴影空间。
  final drawWidth = item.width + overflow * 2;
  final drawHeight = item.height + overflow * 2;

  // 将图片向左、向上移动 overflow，
  // 保证文字和描边仍处于原来的逻辑位置。
  final drawOffset = Offset(
    dx - overflow,
    dy - overflow,
  );

  if (img.width == drawWidth.ceil() &&
      img.height == drawHeight.ceil()) {
    canvas.drawImage(
      img,
      drawOffset,
      _paint,
    );
  } else {
    final src = Rect.fromLTWH(
      0,
      0,
      img.width.toDouble(),
      img.height.toDouble(),
    );

    final dst = Rect.fromLTWH(
      drawOffset.dx,
      drawOffset.dy,
      drawWidth,
      drawHeight,
    );

    canvas.drawImageRect(
      img,
      src,
      dst,
      _paint,
    );
  }
}

  @override
  bool shouldRepaint(covariant BaseDanmakuPainter oldDelegate) {
    return (running && length != 0) ||
        oldDelegate.length != length ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.fontWeight != fontWeight ||
        oldDelegate.fontFamily != fontFamily ||
        !listEquals(oldDelegate.fontFamilyFallback, fontFamilyFallback) ||
        oldDelegate.strokeWidth != strokeWidth ||
oldDelegate.shadowRadius != shadowRadius;
  }
}
