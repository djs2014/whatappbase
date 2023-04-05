import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Math;

module WhatAppBase {
  (:Utils)
  module Utils {
    function isHiddenField(dc as Dc) as Boolean {
      return getFieldType(dc) == Types.HiddenField;
    }
    function isSmallField(dc as Dc) as Boolean {
      return getFieldType(dc) == Types.SmallField;
    }
    function isWideField(dc as Dc) as Boolean {
      return getFieldType(dc) == Types.WideField;
    }
    function isLargeField(dc as Dc) as Boolean {
      return getFieldType(dc) == Types.LargeField;
    }
    function isOneField(dc as Dc) as Boolean {
      return getFieldType(dc) == Types.OneField;
    }

    // 1 large field: w[246] h[322]
    // 2 fields: w[246] h[160]
    // 3 fields: w[246] h[106]
    function getFieldType(dc as Dc) as Types.FieldType {
      var width = dc.getWidth();
      var height = dc.getHeight();
      var fieldType = Types.SmallField;

      if (width == 0) {
        fieldType = Types.HiddenField;
      } else if (width >= 246) {
        fieldType = Types.WideField;
        if (height >= 322) {
          fieldType = Types.OneField;
        } else if (height >= 100) {
          fieldType = Types.LargeField;
        }
      }
      return fieldType;
    }

    //! Get correct y position based on a percentage
    function percentageToYpostion(
      percentage as Numeric,
      marginTop as Number,
      columnHeight as Number
    ) as Number {
      return (
        marginTop +
        columnHeight -
        columnHeight * (percentage / 100.0)
      ).toNumber();
    }

    function getPercentageTrianglePts(
      top as Utils.Point,
      left as Utils.Point,
      right as Utils.Point,
      percentage as Numeric
    ) as Array<Coordinate> {
      if (percentage >= 100) {
        return (
          [
            top.asCoordinate(),
            right.asCoordinate(),
            left.asCoordinate(),
            top.asCoordinate(),
          ] as Array<Coordinate>
        );
      }

      var columnHeight = left.y - top.y;
      var y = percentageToYpostion(percentage, top.y, columnHeight);

      var slopeLeft = Utils.slopeOfLine(left.x, left.y, top.x, top.y);
      var slopeRight = Utils.slopeOfLine(right.x, right.y, top.x, top.y);

      if (slopeLeft != 0.0 and slopeRight != 0.0) {
        var x1 = (y - left.y) / slopeLeft;
        x1 = x1 + left.x;
        var x2 = (y - right.y) / slopeRight;
        x2 = x2 + right.x;

        var t1 = [x1, y] as Coordinate;
        var t2 = [x2, y] as Coordinate;
        return (
          [t1, t2, right.asCoordinate(), left.asCoordinate(), t1] as
          Array<Coordinate>
        );
      }
      return [] as Array<Coordinate>;
    }

    function fillPercentageCircle(
      dc as Dc,
      x as Number,
      y as Number,
      radius as Number,
      perc as Numeric
    ) as Void {
      if (perc == null || perc == 0) {
        return;
      }

      if (perc >= 100.0) {
        dc.fillCircle(x, y, radius);
        return;
      }
      var degrees = 3.6 * perc;

      var degreeStart = 180; // 180deg == 9 o-clock
      var degreeEnd = degreeStart - degrees; // 90deg == 12 o-clock

      dc.setPenWidth(radius);
      dc.drawArc(
        x,
        y,
        radius / 2,
        Graphics.ARC_CLOCKWISE,
        degreeStart,
        degreeEnd
      );
      dc.setPenWidth(1.0);
    }

    function drawPercentageCircle(
      dc as Dc,
      x as Number,
      y as Number,
      radius as Number,
      perc as Numeric,
      penWidth as Number
    ) as Void {
      if (perc == null || perc == 0) {
        return;
      }

      if (perc > 100) {
        perc = 100;
      }
      var degrees = 3.6 * perc;

      var degreeStart = 180; // 180deg == 9 o-clock
      var degreeEnd = degreeStart - degrees; // 90deg == 12 o-clock

      dc.setPenWidth(penWidth);
      dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, degreeStart, degreeEnd);
      dc.setPenWidth(1.0);
    }

    function drawPercentagePointerOnCircle(
      dc as Dc,
      x as Number,
      y as Number,
      radius as Number,
      perc as Numeric,
      penWidth as Number,
      indicatorOffset as Float
    ) as Void {
      if (perc == null || perc == 0) {
        return;
      }
      var normPerc = perc.toNumber() % 100;
      var loops = perc.toNumber() / 100; // integer division!
      var degrees = 3.6 * normPerc;

      var degreeStart = 180 - degrees + 1; // 180deg == 9 o-clock
      var degreeEnd = 180 - degrees - 1; // 90deg == 12 o-clock

      dc.setPenWidth(penWidth);
      dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, degreeStart, degreeEnd);

      if (loops > 0) {
        // lines
        dc.setPenWidth(1.0);
        var x1 = x + indicatorOffset;
        var y1 = y - 2;
        var x2 = x1;
        var y2 = y + 2;
        while (loops > 0) {
          if (indicatorOffset > 0) {
            // draw next left
            x1 = x1 - 2;
          } else {
            // draw next right
            x1 = x1 + 2;
          }
          x2 = x1;
          dc.drawLine(x1, y1, x2, y2);
          loops = loops - 1;
        }
      }
      dc.setPenWidth(1.0);
    }

    function drawPercentageLine(
      dc as Dc,
      x as Number,
      y as Number,
      maxwidth as Number,
      percentage as Numeric,
      height as Number,
      color as ColorType
    ) as Void {
      var wPercentage = (maxwidth / 100.0) * percentage;
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);

      dc.fillRectangle(x, y, wPercentage, height);
      dc.drawPoint(x + maxwidth, y);
    }

    // x, y : top left coord
    function drawPercentageRectangle(
      dc as Dc,
      x as Number,
      y as Number,
      width as Number,
      height as Number,
      percentage as Numeric,
      color as ColorType,
      lineWidth as Number
    ) as Void {
      if (percentage <= 0) {
        return;
      }
      if (percentage >= 100) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(lineWidth);
        dc.drawRectangle(x, y, width, height);
        dc.setPenWidth(1.0);
        return;
      }
      var maxLength = 2 * width + 2 * height;
      var wPercentage = ((maxLength / 100.0) * percentage).toNumber();
      if (wPercentage <= 0) {
        return;
      }
      // @@ check for width/height -> should not exceed due to rounding
      var xStart = x;
      var yStart = y + height / 2;
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      dc.setPenWidth(lineWidth);
      // Line up toward (x,y)
      var wRemaining = _drawPercentageLine2(
        dc,
        xStart,
        yStart,
        xStart,
        y,
        wPercentage
      );
      // Line right
      wRemaining = _drawPercentageLine2(
        dc,
        xStart,
        y,
        xStart + width,
        y,
        wRemaining
      );
      // Line down
      wRemaining = _drawPercentageLine2(
        dc,
        xStart + width,
        y,
        xStart + width,
        y + height,
        wRemaining
      );
      // Line left
      // Should not exceed height of field
      // @@ var yCorr = Utils.max(dc.getHeight(), y + height);
      wRemaining = _drawPercentageLine2(
        dc,
        xStart + width,
        y + height,
        xStart,
        y + height,
        wRemaining
      );
      // Line up towards starting point (half way)
      _drawPercentageLine2(dc, xStart, y + height, xStart, yStart, wRemaining);

      dc.setPenWidth(1.0);
    }

    function _drawPercentageLine2(
      dc as Dc,
      x1 as Number,
      y1 as Number,
      x2 as Number,
      y2 as Number,
      maxLength as Number
    ) as Number {
      if (maxLength <= 0) {
        return 0;
      }
      var distance = Math.sqrt(
        Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2)
      ).toNumber();
      if (distance <= maxLength) {
        dc.drawLine(x1, y1, x2, y2);
        return maxLength - distance;
      }
      // (0,0) is upper left corner
      if (x1 == x2 && y1 > y2) {
        // to up
        dc.drawLine(x1, y1, x2, y1 - maxLength);
        return 0;
      } else if (x1 < x2 && y1 == y2) {
        // to right
        dc.drawLine(x1, y1, x1 + maxLength, y2);
        return 0;
      } else if (x1 == x2 && y1 < y2) {
        // to down
        dc.drawLine(x1, y1, x2, y1 + maxLength);
        return 0;
      } else if (x1 > x2 && y1 == y2) {
        // to left
        dc.drawLine(x1, y1, x1 - maxLength, y2);
        return 0;
      }
      return 0;
    }

    // x, y center of text
    function drawPercentageText(
      dc as Dc,
      x as Number,
      y as Number,
      font as FontType,
      text as String,
      percentage as Numeric,
      initialTextColor as Number,
      percentageColor as Number,
      backColor as ColorType
    ) as Void {
      var textDimensions = dc.getTextDimensions(text, font) as Array<Number>; // [w,h]
      var width = textDimensions[0];
      var height = textDimensions[1];

      // Calculate upper corner of Rectangle
      var xRect = x - width / 2.0;
      var yRect = y - height / 2.0;

      // NB: filling is from top to bottom
      // draw percentage part (100%): 0% -> all white
      dc.setColor(percentageColor, Graphics.COLOR_BLACK);
      dc.fillRectangle(xRect + 1, yRect + 1, width - 1, height - 1);

      // And fill what is not reached with the initial color
      var heightPerc = Utils.min(
        height,
        Utils.valueOfPercentage(100 - percentage, height)
      );
      // System.println("percentage: " + percentage + " text: " + textDimensions
      // +
      //                " x: " + x + "y: " + y + " heightPerc: " + heightPerc);

      dc.setColor(initialTextColor, Graphics.COLOR_BLACK);
      dc.fillRectangle(xRect + 1, yRect + 1, width - 1, heightPerc);

      // draw text, but only the outline
      // @@ on edge 830 frontcolor is white, not transparent - BUG
      dc.setColor(Graphics.COLOR_TRANSPARENT, backColor);
      // dc.setColor(Graphics.COLOR_TRANSPARENT, backColor);
      dc.drawText(xRect, yRect, font, text, Graphics.TEXT_JUSTIFY_LEFT);
      // @@ for now draw line under text
      // Utils.drawPercentageLine(dc, xRect, yRect + height, width, percentage, 2,
      //                          initialTextColor);
    }

    function pointOnCircle(
      radius as Number,
      angleInDegrees as Number,
      center as Utils.Point
    ) as Utils.Point {
      // Convert from degrees to radians
      var x = (radius * Math.cos(deg2rad(angleInDegrees)) + center.x).toNumber();
      var y = (radius * Math.sin(deg2rad(angleInDegrees)) + center.y).toNumber();

      return new Utils.Point(x, y);
    }

    function getMatchingFont(
      dc as Dc,
      fontList as Array,
      maxwidth as Number,
      text as String,
      startIndex as Number
    ) as FontType {
      var index = startIndex;
      var font = fontList[index] as FontType;
      var widthValue = dc.getTextWidthInPixels(text, font);

      while (widthValue > maxwidth && index > 0) {
        index = index - 1;
        font = fontList[index] as FontType;
        widthValue = dc.getTextWidthInPixels(text, font);
      }
      // System.println(
      //   Lang.format("text[$1$] maxWidth[$2$] startidx[$3$] idx[$4$]", [
      //     text,
      //     maxwidth,
      //     startIndex,
      //     index,
      //   ])
      // );
      return font;
    }

    function percentageToColor(percentage as Numeric?) as ColorType {
      if (percentage == null || percentage == 0) {
        return Graphics.COLOR_WHITE;
      }
      if (percentage < 45) {
        return Colors.COLOR_WHITE_GRAY_2;
      }
      if (percentage < 55) {
        return Colors.COLOR_WHITE_GRAY_3;
      }
      if (percentage < 65) {
        return Colors.COLOR_WHITE_BLUE_3;
      }
      if (percentage < 70) {
        return Colors.COLOR_WHITE_DK_BLUE_3;
      }
      if (percentage < 75) {
        return Colors.COLOR_WHITE_LT_GREEN_3;
      }
      if (percentage < 80) {
        return Colors.COLOR_WHITE_GREEN_3;
      }
      if (percentage < 85) {
        return Colors.COLOR_WHITE_YELLOW_3;
      }
      if (percentage < 95) {
        return Colors.COLOR_WHITE_ORANGE_3;
      }
      if (percentage == 100) {
        return Colors.COLOR_WHITE_ORANGERED_2;
      }
      if (percentage < 105) {
        return Colors.COLOR_WHITE_ORANGERED_3;
      }
      if (percentage < 115) {
        return Colors.COLOR_WHITE_ORANGERED2_3;
      }
      if (percentage < 125) {
        return Colors.COLOR_WHITE_RED_3;
      }

      if (percentage < 135) {
        return Colors.COLOR_WHITE_DK_RED_3;
      }

      if (percentage < 145) {
        return Colors.COLOR_WHITE_PURPLE_3;
      }

      if (percentage < 155) {
        return Colors.COLOR_WHITE_DK_PURPLE_3;
      }
      return Colors.COLOR_WHITE_DK_PURPLE_4;
    }
  }
}
