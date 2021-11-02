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
    hidden var mFontValueAdditionalStartIndex = 1;
    hidden var mFontValueAdditional = [
      Graphics.FONT_SYSTEM_SMALL, Graphics.FONT_SYSTEM_MEDIUM,
      Graphics.FONT_SYSTEM_LARGE, Graphics.FONT_NUMBER_MILD,
      Graphics.FONT_NUMBER_HOT
    ] as Lang.Array<Lang.Number>;
    hidden var mRadiusInfoField = 15;

    hidden var COLOR_MAX_PERCENTAGE = WhatColor.COLOR_WHITE_DK_PURPLE_4;

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
      System.println("onLayout");
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
      mRadiusInfoField = Utils.min(dc.getWidth() / 4, dc.getHeight() / 2 + 10);
      mFontValueAdditionalStartIndex = 4;
      if (isSmallField()) {
        mRadiusInfoField = 29.0f;
        mFontValueAdditionalStartIndex = 1;
      } else if (isWideField()) { 
        if (!showBottomInfo && !showTopInfo) {
          mRadiusInfoField = dc.getWidth() / 4;
        }
        mFontLabelAdditional = Graphics.FONT_TINY;  // @@ test
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

    // x, y center of text
    function drawPercentageText(x, y, font, text, percentage, initialTextColor,
                                percentageColor, backColor) {
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
      drawPercentageLine(xRect, yRect + height, width, percentage, 2,
                         initialTextColor);
    }

    function leftAndRightCircleFillWholeScreen() {
      return dc.getWidth() - 40 <
             (4 * mRadiusInfoField) + (marginLeft + marginRight);
    }

    function drawBottomInfo(color, value, backColor, units, outlineColor,
                            percentage, color100perc, label) {
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

    function drawTopInfo(color, value, backColor, units, outlineColor,
                         percentage, color100perc, label) {
      if (middleLayout == LayoutMiddleTriangle) {
        drawTopInfoTriangle(color, value, backColor, units, outlineColor,
                            percentage, color100perc, label);
        return;
      }
      var barX = dc.getWidth() / 2;

      // circle back color
      drawAdditonalInfoBG(barX, mRadiusInfoField, backColor, percentage,
                          color100perc);
      if (!leftAndRightCircleFillWholeScreen()) {
        var fontValue = getFontAdditionalInfo(
            mRadiusInfoField * 2, value, mFontValueAdditionalStartIndex - 1);
        drawAdditonalInfoFG(barX, color, value, fontValue, units,
                            mFontLabelAdditional, label, mFontLabelAdditional,
                            percentage);        
      }
      // outline
      drawAdditonalInfoOutline(barX, mRadiusInfoField, outlineColor);
    }

    function drawTopInfoTriangle(color, value, backColor, units, outlineColor,
                                 percentage, color100perc, label) {
      var heightBottomBar = 0;
      if (showBottomInfo) {
        if (leftAndRightCircleFillWholeScreen()) {
          heightBottomBar = heightPercentageLineBottomBar;
        } else {
          heightBottomBar = dc.getFontHeight(mFontBottomValue);
        }
      }
      var wBottomBar = 2 * mRadiusInfoField;
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
        var fontValue = getFontAdditionalInfo(
            mRadiusInfoField * 2, value, mFontValueAdditionalStartIndex - 1);
        // var y = (left.y - top.y) / 2;
        var y = getCenterYcoordCircleAdditionalInfo();
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
      var barX = mRadiusInfoField + marginLeft;

      // circle back color
      drawAdditonalInfoBG(barX, mRadiusInfoField, backColor, percentage,
                          color100perc);

      var fontValue = getFontAdditionalInfo(mRadiusInfoField * 2, value,
                                            mFontValueAdditionalStartIndex);
      // @@ determine labelFont??//
      drawAdditonalInfoFG(barX, color, value, fontValue, units,
                          mFontLabelAdditional, label, mFontLabelAdditional,
                          percentage);

      // outline
      drawAdditonalInfoOutline(barX, mRadiusInfoField, outlineColor);
    }

    function drawRightInfo(color, value, backColor, units, outlineColor,
                           percentage, color100perc, label) {
      var barX = dc.getWidth() - mRadiusInfoField - marginRight;
      // circle
      drawAdditonalInfoBG(barX, mRadiusInfoField, backColor, percentage,
                          color100perc);

      // outline
      drawAdditonalInfoOutline(barX, mRadiusInfoField, outlineColor);

      // units + value
      var fontValue = getFontAdditionalInfo(mRadiusInfoField * 2, value,
                                            mFontValueAdditionalStartIndex);

      drawAdditonalInfoFG(barX, color, value, fontValue, units,
                          mFontLabelAdditional, label, mFontLabelAdditional,
                          percentage);
    }

    hidden function getCenterYcoordCircleAdditionalInfo() {
      return dc.getHeight() / 2;
    }
    hidden function drawAdditonalInfoBG(x, width, color, percentage,
                                        color100perc) {
      var y = getCenterYcoordCircleAdditionalInfo();

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

    hidden function getFontAdditionalInfo(maxwidth, value, startIndex) {
      var index = startIndex;
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

    hidden function drawAdditonalInfoFG(x, color, value, fontValue, units,
                                        fontUnits, label, fontLabel,
                                        percentage) {
      // Too many arguments used by a method, which are currently limited to 10
      // arguments
      var width = mRadiusInfoField;
      var y = getCenterYcoordCircleAdditionalInfo();

      // label
      if (!isSmallField() && label != null && label.length() > 0) {
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        var yLabel = y - (dc.getFontHeight(fontValue) / 2) -
                     (dc.getFontHeight(fontLabel) / 2) + marginTop;
        dc.drawText(
            x, yLabel, fontLabel, label,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }

      // value
      if (percentage < 200) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x, y, fontValue, value,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      } else {
        drawPercentageText(x, y, fontValue, value, percentage - 200,
                           Graphics.COLOR_WHITE, Graphics.COLOR_RED,
                           COLOR_MAX_PERCENTAGE);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      }

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
      var y = getCenterYcoordCircleAdditionalInfo();
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