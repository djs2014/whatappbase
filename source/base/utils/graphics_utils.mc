import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Math;
module WhatAppBase {
  ( : Utils) module Utils {
    //! Get correct y position based on a percentage
    function percentageToYpostion(percentage, marginTop, columnHeight) {
      return marginTop + columnHeight - (columnHeight * (percentage / 100.0));
    }

    function getPercentageTrianglePts(top as Point, left as Point,
                                      right as Point, percentage) {
      if (percentage >= 100) {
        return
            [ top.asArray(), right.asArray(), left.asArray(), top.asArray() ];
      }

      var columnHeight = left.y - top.y;
      var y = percentageToYpostion(percentage, top.y, columnHeight);

      var slopeLeft = Utils.slopeOfLine(left.x, left.y, top.x, top.y);
      var slopeRight = Utils.slopeOfLine(right.x, right.y, top.x, top.y);

      // System.println("top" + top + "left" + left + " right" + right +
      //                " slopeLeft:" + slopeLeft + " slopeRight:" +
      //                slopeRight);
      if (slopeLeft != 0.0 and slopeRight != 0.0) {
        var x1 = (y - left.y) / slopeLeft;
        x1 = x1 + left.x;
        var x2 = (y - right.y) / slopeRight;
        x2 = x2 + right.x;

        // System.println("slopeLeft:" + slopeLeft + " slopeRight:" + slopeRight
        // +
        //                " y:" + y + " x1:" + x1 + " x2:" + x2);

        return [[x1, y], [x2, y], right.asArray(), left.asArray(), [x1, y]];
      }
      return [];
    }

    function fillPercentageCircle(dc as Dc, x, y, radius, perc) {
      if (perc == null || perc == 0) {
        return;
      }

      if (perc >= 100.0) {
        dc.fillCircle(x, y, radius);
        return;
      }
      var degrees = 3.6 * perc;

      var degreeStart = 180;                  // 180deg == 9 o-clock
      var degreeEnd = degreeStart - degrees;  // 90deg == 12 o-clock

      dc.setPenWidth(radius);
      dc.drawArc(x, y, radius / 2, Graphics.ARC_CLOCKWISE, degreeStart,
                 degreeEnd);
      dc.setPenWidth(1.0);
    }

    function drawPercentageCircle(dc as Dc, x, y, radius, perc, penWidth) {
      if (perc == null || perc == 0) {
        return;
      }

      if (perc > 100.0) {
        perc = 100;
      }
      var degrees = 3.6 * perc;

      var degreeStart = 180;                  // 180deg == 9 o-clock
      var degreeEnd = degreeStart - degrees;  // 90deg == 12 o-clock

      dc.setPenWidth(penWidth);
      dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, degreeStart, degreeEnd);
      dc.setPenWidth(1.0);
    }

    function drawPercentageLine(dc as Dc, x, y, maxwidth, percentage, height,
                                color) {
      var wPercentage = maxwidth / 100.0 * percentage;
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);

      dc.fillRectangle(x, y, wPercentage, height);
      dc.drawPoint(x + maxwidth, y);
    }

    // x, y center of text
    function drawPercentageText(dc as Dc, x, y, font, text, percentage,
                                initialTextColor, percentageColor, backColor) {
      var textDimensions =
          dc.getTextDimensions(text, font) as Lang.Array<Lang.Number>;  // [w,h]
      var width = textDimensions[0];
      var height = textDimensions[1];

      // Calculate upper corner of Rectangle
      var xRect = x - (width / 2.0);
      var yRect = y - (height / 2.0);

      // NB: filling is from top to bottom
      // draw percentage part (100%): 0% -> all white
      dc.setColor(percentageColor, Graphics.COLOR_BLACK);
      dc.fillRectangle(xRect + 1, yRect + 1, width - 1, height - 1);

      // And fill what is not reached with the initial color
      var heightPerc =
          Utils.min(height, Utils.valueOfPercentage(100 - percentage, height));
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
      Utils.drawPercentageLine(dc, xRect, yRect + height, width, percentage, 2,
                               initialTextColor);
    }

    function pointOnCircle(radius, angleInDegrees, center as Point) as Point {
      // Convert from degrees to radians
      var x = (radius * Math.cos(deg2rad(angleInDegrees))) + center.x;
      var y = (radius * Math.sin(deg2rad(angleInDegrees))) + center.y;

      return new Point(x, y);
    }

    function getMatchingFont(dc as Dc, fontList as Lang.Array<Graphics.FontType>,
                             maxwidth, text, startIndex) {
      var index = startIndex;
      var font = fontList[index];
      var widthValue = dc.getTextWidthInPixels(text, font);

      while (widthValue > maxwidth && index > 0) {
        index = index - 1;
        font = fontList[index];
        widthValue = dc.getTextWidthInPixels(text, font);
      }
      // System.println("font index: " + index);
      return font;
    }
  }
}