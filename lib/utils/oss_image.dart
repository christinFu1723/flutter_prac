import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:demo7_pro/utils/string.dart';

/// 阿里云 OSS 图片处理
class OSSImageProcess {
  /// 文件地址
  String src;

  /// 修饰参数
  OSSImageProcessPartResize resize;

  /// 水印参数
  OSSImageProcessPartWatermark watermark;

  /// 裁剪
  OSSImageProcessPartCrop crop;

  /// 构造方法
  OSSImageProcess(
    src, {
    this.resize,
    this.watermark,
    this.crop,
  });

  /// 获取地址
  String get url {
    List<String> parts = [];

    if (resize != null) {
      parts.add(resize.part);
    }

    if (watermark != null) {
      parts.add(watermark.part);
    }

    if (crop != null) {
      parts.add(crop.part);
    }

    if (parts.isEmpty) return src;
    return '$src?x-oss-process=${parts.join(',')}';
  }
}

/// 阿里云 OSS 尺寸处理参数
/// 参考文档：<https://help.aliyun.com/document_detail/44688.html?spm=a2c4g.11186623.6.747.3007663czOgHmo>
class OSSImageProcessPartResize {
  /// 缩放模式
  OSSImageProcessPartResizeMode mode;

  int width;

  int height;

  /// 指定当目标缩放图大于原图时是否进行缩放。
  bool limit;

  /// 当缩放模式选择为pad（缩放填充）时，可以设置填充的颜色
  Color color;

  /// 构造方法
  OSSImageProcessPartResize({
    this.mode,
    this.width,
    this.height,
    this.limit,
    this.color,
  });

  /// 是否存在有效数据
  bool get enable {
    return width != null || height != null;
  }

  /// 构建输出
  String get part {
    if (!enable) return '';

    List<String> output = ['image/resize'];

    if (mode != null) {
      final Map<OSSImageProcessPartResizeMode, String> modeMap = {
        OSSImageProcessPartResizeMode.lfit: 'lfit',
        OSSImageProcessPartResizeMode.mfit: 'mfit',
        OSSImageProcessPartResizeMode.fill: 'lfit',
        OSSImageProcessPartResizeMode.pad: 'pad',
        OSSImageProcessPartResizeMode.fixed: 'fixed',
      };
      output.add('m_${modeMap[mode]}');
    }

    if (width != null) output.add('w_$width');
    if (height != null) output.add('h_$height');
    if (limit != null) output.add('limit_$limit');
    if (color != null) output.add('c_${color.computeLuminance()}');

    return output.join(',');
  }
}

/// 图片缩放模式
enum OSSImageProcessPartResizeMode {
  lfit, //（默认值）等比缩放，缩放图限制为指定w与h的矩形内的最大图片。
  mfit, //等比缩放，缩放图为延伸出指定w与h的矩形框外的最小图片。
  fill, // 将原图等比缩放为延伸出指定w与h的矩形框外的最小图片，之后将超出的部分进行居中裁剪。
  pad, // 将原图缩放为指定w与h的矩形内的最大图片，之后使用指定颜色居中填充空白部分。
  fixed, //  固定宽高，强制缩放。
}

/// 阿里云 OSS 裁剪处理参数
/// 参考文档：<https://help.aliyun.com/document_detail/44693.html?spm=a2c4g.11186623.6.750.1bf56730sqDjGG>
class OSSImageProcessPartCrop {
  int width;
  int height;
  int x;
  int y;
  OSSImageProcessCropOrigin offset;

  /// 构造方法
  OSSImageProcessPartCrop({
    this.x,
    this.y,
    this.width,
    this.height,
    this.offset: OSSImageProcessCropOrigin.center,
  });

  /// 是否存在有效数据
  bool get enable {
    return width != null || height != null;
  }

  /// 构建输出
  String get part {
    if (!enable) return '';

    List<String> output = ['image/crop'];

    if (width != null) output.add('w_$width');
    if (height != null) output.add('h_$height');
    if (x != null) output.add('x_$x');
    if (y != null) output.add('y_$y');
    if (offset != null) {
      final Map<OSSImageProcessCropOrigin, String> offsetMap = {
        OSSImageProcessCropOrigin.nw: 'nw',
        OSSImageProcessCropOrigin.north: 'north',
        OSSImageProcessCropOrigin.ne: 'ne',
        OSSImageProcessCropOrigin.west: 'west',
        OSSImageProcessCropOrigin.center: 'center',
        OSSImageProcessCropOrigin.east: 'east',
        OSSImageProcessCropOrigin.sw: 'sw',
        OSSImageProcessCropOrigin.south: 'south',
        OSSImageProcessCropOrigin.se: 'se',
      };
      output.add('g_${offsetMap[offset]}');
    }

    return output.join(',');
  }
}

/// 裁剪的原点位置
enum OSSImageProcessCropOrigin {
  nw, // 左上
  north, // 中上
  ne, // 右上
  west, // 左中
  center, // 中部
  east, // 右中
  sw, // 左下
  south, // 中下
  se, // 右下
}

/// 阿里云 OSS 水印处理参数
/// 参考文档：<https://help.aliyun.com/document_detail/44957.html?spm=a2c4g.11186623.6.748.c16f66a3XYt4rl>
class OSSImageProcessPartWatermark {
  /// 水印文本
  String text;

  /// 水印颜色
  Color color;

  int x;

  int y;

  /// 图片水印的不透明度
  int opacity;

  /// 水印文字大小
  int size;

  /// 水印文字字体
  OSSImageProcessWatermarkType type;

  /// 顺时针旋转角度
  int rotate;

  /// 是否填满画面
  bool fill;

  /// 对齐方式
  OSSImageProcessWatermarkAlignment align;

  /// 构造方法
  OSSImageProcessPartWatermark({
    this.text,
    this.x,
    this.y,
    this.opacity: 20,
    this.color: Colors.blueGrey,
    this.fill: true,
    this.rotate: 330,
    this.size,
    this.type: OSSImageProcessWatermarkType.WenQuanYiZhengHei,
    this.align: OSSImageProcessWatermarkAlignment.center,
  });

  /// 是否存在有效数据
  bool get enable {
    return !StringUtil.isEmpty(this.text);
  }

  /// 构建输出
  String get part {
    if (!enable) return '';

    List<String> output = ['image/watermark'];

    if (x != null) {
      output.add('x_$x');
    }

    if (y != null) {
      output.add('y_$y');
    }

    if (text != null) {
      String waterText = Base64Encoder.urlSafe().convert(utf8.encode(text));
      output.add('text_$waterText');
    }

    if (opacity != null) {
      output.add('t_$opacity');
    }

    if (color != null) {
      String value = color.value.toRadixString(16);
      value = value.replaceRange(0, 2, '');
      output.add('color_$value');
    }

    if (rotate != null) {
      output.add('rotate_$rotate');
    }

    if (fill != null) {
      output.add('fill_${fill ? 1 : 0}');
    }

    if (size != null) {
      output.add('size_$size');
    }

    if (type != null) {
      final Map<OSSImageProcessWatermarkType, String> typeMap = {
        OSSImageProcessWatermarkType.WenQuanYiZhengHei: 'wqy-zenhei',
        OSSImageProcessWatermarkType.WenQuanYiWeiMiHei: 'wqy-microhei',
        OSSImageProcessWatermarkType.FangZhengShuSong: 'fangzhengshusong',
        OSSImageProcessWatermarkType.FangZhengKaiTi: 'fangzhengkaiti',
        OSSImageProcessWatermarkType.FangZhengHeiTi: 'fangzhengheiti',
        OSSImageProcessWatermarkType.FangZhengFangSong: 'fangzhengfangsong',
        OSSImageProcessWatermarkType.DroidSansFallback: 'droidsansfallback',
      };
      String typeName =
          Base64Encoder.urlSafe().convert(utf8.encode(typeMap[type]));
      output.add('type_$typeName');
    }

    if (align != null) {
      final Map<OSSImageProcessWatermarkAlignment, String> alignMap = {
        OSSImageProcessWatermarkAlignment.nw: 'nw',
        OSSImageProcessWatermarkAlignment.north: 'north',
        OSSImageProcessWatermarkAlignment.ne: 'ne',
        OSSImageProcessWatermarkAlignment.west: 'west',
        OSSImageProcessWatermarkAlignment.center: 'center',
        OSSImageProcessWatermarkAlignment.east: 'east',
        OSSImageProcessWatermarkAlignment.sw: 'sw',
        OSSImageProcessWatermarkAlignment.south: 'south',
        OSSImageProcessWatermarkAlignment.se: 'se',
      };
      output.add('g_${alignMap[align]}');
    }

    return output.join(',');
  }
}

/// 水印对齐方式
enum OSSImageProcessWatermarkAlignment {
  nw,
  north,
  ne,
  west,
  center,
  east,
  sw,
  south,
  se,
}

/// 水印文字字体
enum OSSImageProcessWatermarkType {
  WenQuanYiZhengHei, // wqy-zenhei 文泉驿正黑
  WenQuanYiWeiMiHei, // wqy-microhei 文泉微米黑
  FangZhengShuSong, // fangzhengshusong 方正书宋
  FangZhengKaiTi, // fangzhengkaiti 方正楷体
  FangZhengHeiTi, // fangzhengheiti 方正黑体
  FangZhengFangSong, // fangzhengfangsong 方正仿宋
  DroidSansFallback, // droidsansfallback DroidSansFallback
}
