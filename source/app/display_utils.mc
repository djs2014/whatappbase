import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
module WhatAppBase {

  class WhatDisplay {
    hidden var dc;
    hidden var margin = 1;  // y @@ -> convert to marginTop/marginBottom
    hidden var marginTop = 1;
    hidden var marginLeft = 1;
    hidden var marginRight = 1;
    hidden var heightPercentageLineBottomBar = 2;
    hidden var backgroundColor = Graphics.COLOR_WHITE;
    hidden var nightMode = false;
    hidden var showTopInfo = true;
    hidden var showLeftInfo = true;
    hidden var showRightInfo = true;
    hidden var showBottomInfo = true;
    hidden var middleLayout = LayoutMiddleTriangle;

    hidden var mFontLabel = Graphics.FONT_TINY;
    hidden var mFontValue = Graphics.FONT_LARGE;
    hidden var mFontValueSmall = Graphics.FONT_MEDIUM;
    hidden var mFontValueWideField = Graphics.FONT_NUMBER_MILD;
    hidden var mFontBottomLabel = Graphics.FONT_TINY;
    hidden var mFontBottomValue = Graphics.FONT_TINY;
    hidden var mFontUnits = Graphics.FONT_XTINY;

    hidden var mFontLabelAdditional = Graphics.FONT_XTINY;
    hidden var mFontValueAdditionalIndex = 1;
    hidden var mFontValueAdditional = [
      Graphics.FONT_SYSTEM_SMALL, Graphics.FONT_SYSTEM_MEDIUM,
      Graphics.FONT_SYSTEM_LARGE, Graphics.FONT_NUMBER_MILD,
      Graphics.FONT_NUMBER_HOT
    ] as Lang.Array<Lang.Number>;
    hidden var _widthAdditionalInfo = 15;

    var width = 0;
    var height = 0;
    var fieldType = Types.SmallField;

    function initialize() {}

    function isSmallField() { return fieldType == Types.SmallField; }
    function isWideField() { return fieldType == Types.WideField; }
    function isOneField() { return fieldType == Types.OneField; }
    function isNightMode() { return nightMode; }
    function setNightMode(nightMode) { self.nightMode = nightMode; }
    function setMiddleLayout(middleLayout) { self.middleLayout = middleLayout; }
    function setShowTopInfo(showTopInfo) { self.showTopInfo = showTopInfo; }
    function setShowLeftInfo(showLeftInfo) { self.showLeftInfo = showLeftInfo; }

    function setShowRightInfo(showRightInfo) {
      self.showRightInfo = showRightInfo;
    }
    function setShowBottomInfo(showBottomInfo) {
      self.showBottomInfo = showBottomInfo;
    }

    function onLayout(dc as Dc) {
      self.dc = dc;

      self.width = dc.getWidth();
      self.height = dc.getHeight();
      self.fieldType = Types.SmallField;

      if (self.width >= 246) {
        self.fieldType = Types.WideField;
        if (self.height >= 322) {
          self.fieldType = Types.OneField;
        }
      }

      // if (self.height < 80) {
      //   self.fieldType= SmallField;
      // }

      // 1 large field: w[246] h[322]
      // 2 fields: w[246] h[160]
      // 3 fields: w[246] h[106]

      // @@ function to set fonts + some dimensions
      _widthAdditionalInfo = Utils.min(dc.getWidth() / 4, dc.getHeight() / 2 + 10);
      mFontValueAdditionalIndex = 4;
      if (isSmallField()) {
        _widthAdditionalInfo = 29.0f;
        mFontValueAdditionalIndex = 1;
      } else {
        mFontLabelAdditional = Graphics.FONT_TINY;  // @@ test
      }
    }
    function onUpdate(dc as Dc) {
      if (dc has : setAntiAlias) {
        dc.setAntiAlias(true);
      }
      onLayout(dc);
    }

    function clearDisplay(color, backColor) {
      dc.setColor(color, backColor);
      dc.clear();
    }

    function drawPercentageCircle(x, y, radius, perc) {
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
    function drawPercentageLine(x, y, maxwidth, percentage, height, color) {
      var wPercentage = maxwidth / 100.0 * percentage;
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      // dc.drawLine(x, y, x + wPercentage, y);
      dc.fillRectangle(x, y, wPercentage, height);
      dc.drawPoint(x + maxwidth, y);
    }

    hidden function getPercentageTrianglePts(top as Point, left as Point,
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
    // @@TODO drawPercentageText
    function drawPercentageText(x, y, text, percentage, color, percentageColor,
                                backColor) {}
    // function drawTopInfoCircle(radius, outlineColor, inlineColor, percentage,
    //                            color100perc) {
    //   var x = dc.getWidth() / 2;
    //   var y = dc.getHeight() / 2;

    //   dc.setColor(outlineColor, Graphics.COLOR_TRANSPARENT);
    //   dc.fillCircle(x, y, radius + 2);

    //   dc.setColor(inlineColor, Graphics.COLOR_TRANSPARENT);
    //   dc.fillCircle(x, y, radius);

    //   dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

    //   dc.fillCircle(x, y, radius - 4);

    //   dc.setColor(WhatColor.COLOR_WHITE_GRAY_2, Graphics.COLOR_TRANSPARENT);
    //   drawPercentageCircle(x, y, radius - 4, percentage);
    // }

    // function drawTopInfoXXX(color, label, value, units) {
    //   dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

    //   var fontValue = mFontValueWideField;
    //   if (isSmallField()) {
    //     fontValue = mFontValue;
    //   }
    //   var widthValue = dc.getTextWidthInPixels(value, fontValue);
    //   if (widthValue >= (dc.getWidth() - (4 * _widthAdditionalInfo))) {
    //     fontValue = mFontValueSmall;
    //     widthValue = dc.getTextWidthInPixels(value, fontValue);
    //   }

    //   var hl = dc.getFontHeight(mFontLabel);
    //   var hv = dc.getFontHeight(fontValue);
    //   var yl = dc.getHeight() / 2 - hv + margin;
    //   var widthUnits = dc.getTextWidthInPixels(units, mFontUnits);
    //   var xv =
    //       dc.getWidth() / 2 -
    //       (widthValue) / 2;  // dc.getWidth() / 2 - (widthValue + widthUnits)
    //       / 2;

    //   if (isSmallField()) {
    //     // label
    //     yl = dc.getHeight() / 2 - hl - 2;
    //     dc.drawText(dc.getWidth() / 2, yl, mFontLabel, label,
    //                 Graphics.TEXT_JUSTIFY_CENTER |
    //                 Graphics.TEXT_JUSTIFY_VCENTER);
    //     // value
    //     dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, fontValue, value,
    //                 Graphics.TEXT_JUSTIFY_CENTER |
    //                 Graphics.TEXT_JUSTIFY_VCENTER);
    //     // units
    //     dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + (hv / 2),
    //     mFontUnits,
    //                 units,
    //                 Graphics.TEXT_JUSTIFY_CENTER |
    //                 Graphics.TEXT_JUSTIFY_VCENTER);
    //   } else {
    //     // label
    //     // var widthLabel = dc.getTextWidthInPixels(label, mFontLabel);
    //     // drawPercentageCircle(dc.getWidth() / 2 - widthLabel / 2 - 7, yl +
    //     hl/2,
    //     // 5, perc);

    //     dc.drawText(dc.getWidth() / 2, yl, mFontLabel, label,
    //                 Graphics.TEXT_JUSTIFY_CENTER);
    //     // value
    //     dc.drawText(xv, dc.getHeight() / 2, fontValue, value,
    //                 Graphics.TEXT_JUSTIFY_LEFT |
    //                 Graphics.TEXT_JUSTIFY_VCENTER);

    //     dc.drawText(xv + widthValue + 1, dc.getHeight() / 2, mFontUnits,
    //     units,
    //                 Graphics.TEXT_JUSTIFY_LEFT);
    //   }
    // }

    function drawInfoTriangleThingy(color, label, value, units, backColor,
                                    percentage, color100perc) {
      // polygon
      var wBottomBar = 2 * _widthAdditionalInfo;  // @@ TEST -> 1/3 width always
                                                  // better? if no Top.
      //     dc.getWidth() - (4 * _widthAdditionalInfo) + marginLeft +
      //     marginRight;
      // if (isSmallField()) {
      //   wBottomBar = dc.getWidth() / 2;
      // }
      var top = new Point(dc.getWidth() / 2, margin);
      var left = new Point(dc.getWidth() / 2 - wBottomBar / 2,
                           dc.getHeight() - margin);
      var right = new Point(dc.getWidth() / 2 + wBottomBar / 2,
                            dc.getHeight() - margin);
      var topInner = top.move(0, 2);
      var leftInner = left.move(2, -2);
      var rightInner = right.move(-2, -2);

      var pts = getPercentageTrianglePts(top, left, right, 100);
      dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
      if (!isSmallField()) {
        // @@ Draw outline, there is no drawPolygon, so fill inner with
        // white/background
        pts = getPercentageTrianglePts(topInner, leftInner, rightInner, 100);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(pts);
      }
      if (percentage > 100 && color100perc != null) {
        pts = getPercentageTrianglePts(topInner, leftInner, rightInner, 100);
        dc.setColor(color100perc, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(pts);
        percentage = percentage - 100;
      }

      pts =
          getPercentageTrianglePts(topInner, leftInner, rightInner, percentage);
      dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);

      if (!leftAndRightCircleFillWholeScreen()) {
        var maxwidth = (right.x - left.x);
        var x = left.x + maxwidth / 2.0;
        var fontValue = getFontAdditionalInfo(maxwidth, value);
        var y = (left.y - top.y) / 2;
        var ha = dc.getFontHeight(fontValue);

        // label
        var yLabel = y - dc.getFontHeight(mFontBottomLabel) - 3;
        // y - dc.getFontHeight(mFontBottomLabel) - ha / 2 + margin;
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, yLabel, mFontBottomLabel, label,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        // value
        dc.drawText(
            x, y, fontValue, value,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // units
        var yUnits = y + ha / 2;
        dc.drawText(
            x, yUnits, mFontUnits, units,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
    }

    function leftAndRightCircleFillWholeScreen() {
      return dc.getWidth() - 40 <
             (4 * _widthAdditionalInfo) + (marginLeft + marginRight);
    }

    hidden function getHeigthInfoBottom() {
      // @@
    }
    function drawBottomInfo(color, label, value, units, backColor, percentage,
                            color100perc) {
      var hv = dc.getFontHeight(mFontBottomValue);
      var widthLabel = dc.getTextWidthInPixels(label, mFontBottomLabel);
      var widthValue = dc.getTextWidthInPixels(value, mFontBottomValue);
      var widthUnits = dc.getTextWidthInPixels(units, mFontUnits);

      var wBottomBar;
      var marginleft1 = 2;
      var marginleft2 = 2;
      var wAllText =
          widthLabel + marginleft1 + widthValue + marginleft2 + widthUnits;
      if (leftAndRightCircleFillWholeScreen()) {
        wBottomBar = dc.getWidth() - marginLeft - marginRight;
      } else {
        wBottomBar = wAllText;
      }

      var xv = dc.getWidth() / 2 - wAllText / 2;
      var y = dc.getHeight() - (hv / 2);

      if (backColor != null) {
        dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
      }
      var xb = dc.getWidth() / 2 - wBottomBar / 2;
      var yb = dc.getHeight() - hv + 2;
      var yPercentage = dc.getHeight() - heightPercentageLineBottomBar;
      var wPercentage = wBottomBar / 100.0 * percentage;

      if (leftAndRightCircleFillWholeScreen()) {
        yb = dc.getHeight() - 5;
        dc.fillRoundedRectangle(xb, yb, wBottomBar, hv / 2, 3);
      } else {
        dc.fillRoundedRectangle(xb, yb, wBottomBar, hv, 3);
      }
      var colorPercentageLine = Graphics.COLOR_BLACK;
      if (percentage > 100) {
        drawPercentageLine(xb, yPercentage, wBottomBar, 100, 2,
                           colorPercentageLine);
        percentage = percentage - 100;
        colorPercentageLine = Graphics.COLOR_RED;
      }
      drawPercentageLine(xb, yPercentage, wBottomBar, percentage, 2,
                         colorPercentageLine);

      if (leftAndRightCircleFillWholeScreen()) {
        return;
      }

      if (color != null) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      }

      dc.drawText(xv, y, mFontBottomLabel, label,
                  Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

      dc.drawText(xv + widthLabel + marginleft1, y, mFontBottomValue, value,
                  Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

      dc.drawText(xv + widthLabel + marginleft1 + widthValue + marginleft2, y,
                  mFontUnits, units,
                  Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawTopInfo(label, color, value, backColor, units, outlineColor,
                         percentage, color100perc) {
      if (middleLayout == LayoutMiddleTriangle) {
        drawTopInfoTriangle(label, color, value, backColor, units, outlineColor,
                            percentage, color100perc);
        return;
      }
      var barX = dc.getWidth() / 2;

      // circle back color
      drawAdditonalInfoBG(barX, _widthAdditionalInfo, backColor, percentage,
                          color100perc);
      if (!leftAndRightCircleFillWholeScreen()) {
        var fontValue = getFontAdditionalInfo(_widthAdditionalInfo * 2, value);
        drawAdditonalInfoFG(barX, _widthAdditionalInfo, color, value, fontValue,
                            units, mFontLabelAdditional, label,
                            mFontLabelAdditional);

        // @@ label not needed here?
        var yLabel = dc.getFontHeight(mFontBottomLabel) / 2;
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            barX, yLabel, mFontBottomLabel, label,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
      // outline
      drawAdditonalInfoOutline(barX, _widthAdditionalInfo, outlineColor);
    }

    function drawTopInfoTriangle(label, color, value, backColor, units,
                                 outlineColor, percentage, color100perc) {
      var heightBottomBar = 0;
      if (showBottomInfo) {
        if (leftAndRightCircleFillWholeScreen()) {
          heightBottomBar = heightPercentageLineBottomBar;
        } else {
          heightBottomBar = dc.getFontHeight(mFontBottomValue);
        }
      }
      var wBottomBar = 2 * _widthAdditionalInfo;
      var top = new Point(dc.getWidth() / 2, margin);
      var left = new Point(dc.getWidth() / 2 - wBottomBar / 2,
                           dc.getHeight() - margin - heightBottomBar);
      var right = new Point(dc.getWidth() / 2 + wBottomBar / 2,
                            dc.getHeight() - margin - heightBottomBar);
      var topInner = top.move(0, 2);
      var leftInner = left.move(2, -2);
      var rightInner = right.move(-2, -2);

      var pts = getPercentageTrianglePts(top, left, right, 100);
      dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
      if (!isSmallField()) {
        // @@ Draw outline, there is no drawPolygon, so fill inner with
        // white/background
        pts = getPercentageTrianglePts(topInner, leftInner, rightInner, 100);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(pts);
      }
      if (percentage > 100 && color100perc != null) {
        pts = getPercentageTrianglePts(topInner, leftInner, rightInner, 100);
        dc.setColor(color100perc, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(pts);
        percentage = percentage - 100;
      }

      pts =
          getPercentageTrianglePts(topInner, leftInner, rightInner, percentage);
      dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);

      if (!leftAndRightCircleFillWholeScreen()) {
        var maxwidth = (right.x - left.x);
        var x = left.x + maxwidth / 2.0;
        var fontValue = getFontAdditionalInfo(maxwidth, value);
        // var y = (left.y - top.y) / 2;
        var y = getCenterYcoordCircleAdditionalInfo(maxwidth);
        var ha = dc.getFontHeight(fontValue);

        // label
        var yLabel = y - dc.getFontHeight(mFontBottomLabel) - 3;
        // y - dc.getFontHeight(mFontBottomLabel) - ha / 2 + margin;
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, yLabel, mFontBottomLabel, label,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        // value
        dc.drawText(
            x, y, fontValue, value,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // units
        var yUnits = y + ha / 2;
        dc.drawText(
            x, yUnits, mFontUnits, units,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
    }

    function drawLeftInfo(color, value, backColor, units, outlineColor,
                          percentage, color100perc, label) {
      var barX = _widthAdditionalInfo + marginLeft;

      // circle back color
      drawAdditonalInfoBG(barX, _widthAdditionalInfo, backColor, percentage,
                          color100perc);

      var fontValue = getFontAdditionalInfo(_widthAdditionalInfo * 2, value);
      // @@ determine labelFont??//
      drawAdditonalInfoFG(barX, _widthAdditionalInfo, color, value, fontValue,
                          units, mFontLabelAdditional, label,
                          mFontLabelAdditional);

      // outline
      drawAdditonalInfoOutline(barX, _widthAdditionalInfo, outlineColor);
    }

    function drawRightInfo(color, value, backColor, units, outlineColor,
                           percentage, color100perc, label) {
      var barX = dc.getWidth() - _widthAdditionalInfo - marginRight;
      // circle
      drawAdditonalInfoBG(barX, _widthAdditionalInfo, backColor, percentage,
                          color100perc);

      // outline
      drawAdditonalInfoOutline(barX, _widthAdditionalInfo, outlineColor);

      // units + value
      var fontValue = getFontAdditionalInfo(_widthAdditionalInfo * 2, value);

      drawAdditonalInfoFG(barX, _widthAdditionalInfo, color, value, fontValue,
                          units, mFontLabelAdditional, label,
                          mFontLabelAdditional);
    }

    hidden function getCenterYcoordCircleAdditionalInfo(width) {
      return dc.getHeight() / 2;
    }
    hidden function drawAdditonalInfoBG(x, width, color, percentage,
                                        color100perc) {
      var y = getCenterYcoordCircleAdditionalInfo(width);

      if (percentage < 100 || color100perc == null) {
        dc.setColor(WhatColor.COLOR_WHITE_GRAY_1, Graphics.COLOR_TRANSPARENT);
      } else {
        dc.setColor(color100perc, Graphics.COLOR_TRANSPARENT);
        percentage = percentage - 100;
      }

      dc.fillCircle(x, y, width);

      if (color == backgroundColor) {
        color = WhatColor.COLOR_WHITE_GRAY_1;
      }
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      drawPercentageCircle(x, y, width, percentage);
    }

    hidden function getFontAdditionalInfo(maxwidth, value) {
      var index = mFontValueAdditionalIndex;
      var fontList = mFontValueAdditional as Lang.Array<Lang.Number>;
      var font = fontList[index];
      var widthValue = dc.getTextWidthInPixels(value, font);

      while (widthValue > maxwidth && index > 0) {
        index = index - 1;
        font = fontList[index];
        widthValue = dc.getTextWidthInPixels(value, font);
      }      
      // System.println("font index: " + index);
      return font;
    }

    hidden function drawAdditonalInfoFG(x, width, color, value, fontValue,
                                        units, fontUnits, label, fontLabel) {
      var y = getCenterYcoordCircleAdditionalInfo(width);

      // label
      if (!isSmallField() &&  label != null && label.length() > 0) {
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        var yLabel = y - (dc.getFontHeight(fontValue) / 2) - (dc.getFontHeight(fontLabel) / 2) + marginTop;
        dc.drawText(
            x, yLabel, fontLabel, label,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);        
      }

      // value
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      dc.drawText(x, y, fontValue, value,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      // units
      var ha = dc.getFontHeight(fontValue);
      if (units != null && units.length() != 0) {
        y = y + ha / 2;
        dc.drawText(
            x, y, fontUnits, units,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
    }

    hidden function drawAdditonalInfoOutline(x, width, color) {
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      var y = getCenterYcoordCircleAdditionalInfo(width);
      dc.drawCircle(x, y, width);
    }

    //! Get correct y position based on a percentage
    hidden function percentageToYpostion(percentage, marginTop, columnHeight) {
      return marginTop + columnHeight - (columnHeight * (percentage / 100.0));
    }
  }

  
  enum {
    LayoutMiddleCircle = 0,
    LayoutMiddleTriangle = 1,
  }
}