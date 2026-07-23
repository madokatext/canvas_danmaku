import 'dart:ui' as ui;

import 'package:canvas_danmaku/models/danmaku_content_item.dart';
import 'package:canvas_danmaku/utils/utils.dart';

class DanmakuItem<T> {
  /// 弹幕内容
  final DanmakuContentItem<T> content;

  /// 弹幕宽度
  double width;

  /// 弹幕高度
  double height;
  /// 绘制图片相对逻辑包围盒额外向四周扩出的空间。
  ///
  /// 只用于容纳阴影，不参与轨道、碰撞和滚动距离计算。
  double effectOverflow;
  /// 弹幕水平方向位置
  double xPosition;

  /// 上次绘制时间
  int? drawTick;

  /// 弹幕布局缓存
  ui.Image? image;

  bool expired = false;

  bool suspend = false;

  @pragma("vm:prefer-inline")
  bool needRemove(bool needRemove) {
    if (needRemove) {
      dispose();
    }
    return needRemove;
  }

  void dispose() {
    image?.dispose();
    image = null;
  }

  DanmakuItem({
    required this.content,
    required this.height,
    required this.width,
    this.effectOverflow = 0,
    this.xPosition = 0,
    this.image,
    this.drawTick,
  });

  void drawParagraphIfNeeded(
    double fontSize,
    int fontWeight,
    double strokeWidth,
    double shadowRadius,
    String fontFamily,
    List<String> fontFamilyFallback,
  ) {
    if (image == null) {
      final paragraph = DmUtils.generateParagraph(
        content: content,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadowRadius: shadowRadius,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      );
      image = DmUtils.recordDanmakuImage(
        contentParagraph: paragraph,
        content: content,
        fontSize: fontSize,
        fontWeight: fontWeight,
        strokeWidth: strokeWidth,
        shadowRadius: shadowRadius,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      );
      final effectPadding = DmUtils.effectPadding(
  strokeWidth,
  shadowRadius,
);

// 图片需要的总留白，减去描边原本已经占用的半宽。
// 这一部分只允许向逻辑包围盒之外扩展。
effectOverflow =
    effectPadding - strokeWidth / 2.0;

// 逻辑尺寸保持阴影功能加入前的语义：
// 文字尺寸 + 两侧描边。
width = paragraph.maxIntrinsicWidth +
    strokeWidth +
    (content.selfSend ? 4.0 : 0.0);

height = paragraph.height + strokeWidth;
      paragraph.dispose();
    }
  }

  @override
  String toString() {
    return 'DanmakuItem(content=$content, xPos=$xPosition, size=${ui.Size(width, height)}, drawTick=$drawTick)';
  }
}
