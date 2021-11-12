import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
// using WhatAppBase.Utils;
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

    hidden var mFontBottomLabel = Graphics.FONT_TINY;
    hidden var mFontBottomValue = Graphics.FONT_TINY;
    hidden var mFontBottomValueStartIndex = 1;
    hidden var mFontsBottomValue = [
      Graphics.FONT_TINY, Graphics.FONT_SYSTEM_SMALL,
      Graphics.FONT_SYSTEM_MEDIUM, Graphics.FONT_SYSTEM_LARGE
    ] as Lang.Array<Lang.Number>;
    hidden var mFontUnits = Graphics.FONT_XTINY;

    // @@ rename mFontsValue to --mFontValue
    hidden var mFontLabelAdditional = Graphics.FONT_XTINY;
    hidden var mFontValueStartIndex = 1;
    hidden var mFontsValue = [
      Graphics.FONT_SYSTEM_SMALL, Graphics.FONT_SYSTEM_MEDIUM,
      Graphics.FONT_SYSTEM_LARGE, Graphics.FONT_NUMBER_MILD,
      Graphics.FONT_NUMBER_HOT
    ] as Lang.Array<Lang.Number>;
    hidden var mRadiusInfoField = 15;

    hidden var COLOR_MAX_PERCENTAGE = Colors.COLOR_WHITE_DK_PURPLE_4;

    var width = 0;
    var height = 0;
    var fieldType = Types.SmallField;

    function initialize() {}

    function isSmallField() { return fieldType == Types.SmallField; }
    function isWideField() { return fieldType == Types.WideField; }
    function isLargeField() { return fieldType == Types.LargeField; }
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
      self.fieldType = Utils.getFieldType(dc);

      // if (self.width >= 246) {
      //   self.fieldType = Types.WideField;
      //   if (self.height >= 100) {
      //     self.fieldType = Types.LargeField;
      //   } else if (self.height >= 322) {
      //     self.fieldType = Types.OneField;
      //   }
      // }

      // System.println("w[" + self.width + "] h[" + self.height + "] type[" +
      //                self.fieldType + "]");
      // if (self.height < 80) {
      //   self.fieldType= SmallField;
      // }

      // 1 large field: w[246] h[322]
      // 2 fields: w[246] h[160]
      // 3 fields: w[246] h[106]

      // @@ function to set fonts + some dimensions
      mRadiusInfoField = Utils.min(dc.getWidth() / 4, dc.getHeight() / 2 + 10);
      mFontValueStartIndex = 4;
      mFontBottomValueStartIndex = 3;
      if (isSmallField()) {
        mRadiusInfoField = 29.0f;
        mFontValueStartIndex = 1;
        mFontBottomValueStartIndex = 1;
      } else if (isWideField()) {
        if (!showBottomInfo && !showTopInfo) {
          mRadiusInfoField = dc.getWidth() / 4;
        }
        mFontValueStartIndex = 3;
        mFontLabelAdditional = Graphics.FONT_TINY;  // @@ test
      } else if (isLargeField()) {
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

    function leftAndRightCircleFillWholeScreen() {
      return dc.getWidth() - 40 <
             (4 * mRadiusInfoField) + (marginLeft + marginRight);
    }

    function drawTopInfo(label, value, units, zone, altZone, maxZone) {
      var color = zone.fontColor;
      var backColor = zone.color;
      var percentage = zone.perc;
      var color100perc = zone.color100perc;
      var outlinePerc = altZone.perc;
      var outlineColor = altZone.color;

      var barX = dc.getWidth() / 2;
      if (middleLayout == LayoutMiddleTriangle) {
        drawTopInfoTriangle(color, value, backColor, units, outlineColor,
                            percentage, color100perc, label);
        return;
      }

      // circle back color
      drawAdditonalInfoBG(barX, mRadiusInfoField, backColor, percentage,
                          color100perc, outlinePerc, outlineColor,
                          altZone.color100perc);

      if (!isSmallField() && leftAndRightCircleFillWholeScreen()) {
        var ha = dc.getFontHeight(Graphics.FONT_SMALL);
        var y = ha / 2;  // mRadiusInfoField / 6;
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            barX, y, Graphics.FONT_SMALL, value,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        if (units != null && units.length() != 0) {
          y = ha + 1;
          dc.drawText(
              barX, y, mFontLabelAdditional, units,
              Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
      } else if (!isSmallField()) {
        var fontValue = Utils.getMatchingFont(
            dc, mFontsValue, mRadiusInfoField * 2, value, mFontValueStartIndex);

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
      var top = new Utils.Point(dc.getWidth() / 2, margin);
      var left = new Utils.Point(dc.getWidth() / 2 - wBottomBar / 2,
                           dc.getHeight() - margin - heightBottomBar);
      var right = new Utils.Point(dc.getWidth() / 2 + wBottomBar / 2,
                            dc.getHeight() - margin - heightBottomBar);
      var topInner = top.move(0, 2);
      var leftInner = left.move(2, -2);
      var rightInner = right.move(-2, -2);

      var pts = Utils.getPercentageTrianglePts(top, left, right, 100);
      dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
      if (!isSmallField()) {
        // @@ Draw outline, there is no drawPolygon, so fill inner with
        // white/background
        pts = Utils.getPercentageTrianglePts(topInner, leftInner, rightInner,
                                             100);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(pts);
      }
      if (percentage > 100 && color100perc != null) {
        pts = Utils.getPercentageTrianglePts(topInner, leftInner, rightInner,
                                             100);
        dc.setColor(color100perc, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(pts);
        //percentage = percentage - 100;
        percentage = percentage.toNumber() % 100;
      }

      pts = Utils.getPercentageTrianglePts(topInner, leftInner, rightInner,
                                           percentage);
      dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);

      if (!leftAndRightCircleFillWholeScreen()) {
        var maxwidth = (right.x - left.x);
        var x = left.x + maxwidth / 2.0;
        var fontValue =
            Utils.getMatchingFont(dc, mFontsValue, mRadiusInfoField * 2, value,
                                  mFontValueStartIndex - 1);
        // var y = (left.y - top.y) / 2;
        var y = getCenterYcoordCircleAdditionalInfo();
        var ha = dc.getFontHeight(fontValue);

        // label
        var yLabel = y - dc.getFontHeight(mFontBottomLabel) - 3;
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

    function drawBottomInfoBG(label, value, units, zone, altZone, maxZone) {
      var backColor = zone.color;
      var percentage = zone.perc;
      var color100perc = zone.color100perc;

      if (percentage >= 0 && leftAndRightCircleFillWholeScreen()) {
        // Percentage bar around whole field
        _drawBackgroundPercRectangle(2, 2, dc.getWidth() - 4,
                                     dc.getHeight() - 4, backColor,
                                     color100perc, percentage, 4);
      }
    }

    function drawBottomInfoFG(label, value, units, zone, altZone, maxZone) {
      var color = zone.fontColor;
      var backColor = zone.color;
      var percentage = zone.perc;
      var color100perc = zone.color100perc;
      var outlinePerc = altZone.perc;
      var outlineColor = altZone.color;
      var outlineColor100perc = altZone.color100perc;

      var hv = dc.getFontHeight(mFontBottomValue);
      var widthLabel = dc.getTextWidthInPixels(label, mFontBottomLabel);
      var widthValue = dc.getTextWidthInPixels(value, mFontBottomValue);
      var widthUnits = dc.getTextWidthInPixels(units, mFontUnits);

      var wBottomBar;
      var marginleft1 = 2;
      var marginleft2 = 2;
      var wAllText =
          widthLabel + marginleft1 + widthValue + marginleft2 + widthUnits;

      var xv = dc.getWidth() / 2 - wAllText / 2;
      var y = dc.getHeight() - (hv / 2);

      if (backColor != null) {
        dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
      }
      var xb = dc.getWidth() / 2 - wAllText / 2;
      var yb = dc.getHeight() - hv;

      if (!leftAndRightCircleFillWholeScreen()) {
        dc.fillRectangle(xb, yb, wAllText, hv);
        if (percentage >= 0) {
          // Percentage bar around text only, text in FG
          var percColor = Graphics.COLOR_DK_GRAY;
          var percColor100 = null;
          if (percentage > 100) {
            percColor = Graphics.COLOR_ORANGE;
            percColor100 = Graphics.COLOR_DK_GRAY;
          }
          _drawBackgroundPercRectangle(xb, yb, wAllText, hv - 1, percColor,
                                       percColor100, percentage, 1);
        }
      }

      if (isSmallField()) {
        return;
      }

      if (leftAndRightCircleFillWholeScreen()) {
        // @@ Only display value, ex heading
        if (color != null) {
          dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        }
        var fontBottomValue =
            Utils.getMatchingFont(dc, mFontsBottomValue, mRadiusInfoField,
                                  value, mFontBottomValueStartIndex);
        widthValue = dc.getTextWidthInPixels(value, fontBottomValue);
        hv = dc.getFontHeight(fontBottomValue);
        y = dc.getHeight() - (hv / 2);
        dc.drawText(
            dc.getWidth() / 2, y, fontBottomValue, value,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth() / 2 + widthValue / 2 + marginleft2, y,
                    mFontUnits, units,
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

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

    hidden function _drawBackgroundPercRectangle(x, y, width, height,
                                                 colorPercentageLine,
                                                 color100perc, percentage,
                                                 lineWidth) {
      if (percentage > 100 && color100perc != null) {
        Utils.drawPercentageRectangle(dc, x, y, width, height, 100,
                                      color100perc, lineWidth);
        // percentage = percentage - 100;
        percentage = percentage.toNumber() % 100;
        // colorPercentageLine = color100perc;
      }
      Utils.drawPercentageRectangle(dc, x, y, width, height, percentage,
                                    colorPercentageLine, lineWidth);
    }
    function drawLeftInfo(label, value, units, zone, altZone, maxZone) {
      var color = zone.fontColor;
      var backColor = zone.color;
      var percentage = zone.perc;
      var color100perc = zone.color100perc;
      var outlinePerc = altZone.perc;
      var outlineColor = altZone.color;
      var barX = mRadiusInfoField + marginLeft;
      var maxPercentage = maxZone.perc;
      // circle back color
      drawAdditonalInfoBG(barX, mRadiusInfoField, backColor, percentage,
                          color100perc, outlinePerc, outlineColor,
                          altZone.color100perc);

      drawMaxInfo(barX, mRadiusInfoField, maxPercentage);

      var fontValue = Utils.getMatchingFont(
          dc, mFontsValue, mRadiusInfoField * 2, value, mFontValueStartIndex);
      // @@ determine labelFont??//
      drawAdditonalInfoFG(barX, color, value, fontValue, units,
                          mFontLabelAdditional, label, mFontLabelAdditional,
                          percentage);

      drawAdditonalInfoOutline(barX, mRadiusInfoField, outlineColor);
    }

    function drawRightInfo(label, value, units, zone, altZone, maxZone) {
      var color = zone.fontColor;
      var backColor = zone.color;
      var percentage = zone.perc;
      var color100perc = zone.color100perc;
      var outlinePerc = altZone.perc;
      var outlineColor = altZone.color;
      var barX = dc.getWidth() - mRadiusInfoField - marginRight;
      var maxPercentage = maxZone.perc;
      // circle
      drawAdditonalInfoBG(barX, mRadiusInfoField, backColor, percentage,
                          color100perc, outlinePerc, outlineColor,
                          altZone.color100perc);
      drawMaxInfo(barX, mRadiusInfoField, maxPercentage);

      // units + value
      var fontValue = Utils.getMatchingFont(
          dc, mFontsValue, mRadiusInfoField * 2, value, mFontValueStartIndex);

      drawAdditonalInfoFG(barX, color, value, fontValue, units,
                          mFontLabelAdditional, label, mFontLabelAdditional,
                          percentage);

      // outline
      drawAdditonalInfoOutline(barX, mRadiusInfoField, outlineColor);
    }

    hidden function getCenterYcoordCircleAdditionalInfo() {
      return dc.getHeight() / 2;
    }
    hidden function drawAdditonalInfoBG(x, width, color, percentage,
                                        color100perc, outlinePerc, outlineColor,
                                        outlineColor100perc) {
      var y = getCenterYcoordCircleAdditionalInfo();

      if (percentage < 100 || color100perc == null) {
        dc.setColor(Colors.COLOR_WHITE_GRAY_1, Graphics.COLOR_TRANSPARENT);
      } else {
        dc.setColor(color100perc, Graphics.COLOR_TRANSPARENT);
        percentage = percentage - 100;
      }
      dc.fillCircle(x, y, width);

      if (color == backgroundColor) {
        color = Colors.COLOR_WHITE_GRAY_1;
      }
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      Utils.fillPercentageCircle(dc, x, y, width, percentage);

      if (outlineColor != null && outlineColor > 0 && outlinePerc > 0) {
        var outlineWidth = width / 8;
        var w = width - outlineWidth / 2;
        if (outlinePerc <= 100 || outlineColor100perc == null) {
          dc.setColor(outlineColor, Graphics.COLOR_TRANSPARENT);
          Utils.drawPercentageCircle(dc, x, y, w, outlinePerc, outlineWidth);
        } else {
          dc.setColor(outlineColor100perc, Graphics.COLOR_TRANSPARENT);
          Utils.drawPercentageCircle(dc, x, y, w, 100, outlineWidth);
          dc.setColor(outlineColor, Graphics.COLOR_TRANSPARENT);
          Utils.drawPercentageCircle(dc, x, y, w, outlinePerc - 100,
                                     outlineWidth);
        }
      }
    }

    function drawMaxInfo(barX, width, maxPercentage) {
      if (maxPercentage == null || maxPercentage <= 0) {
        return;
      }

      var outlineWidth = width;
      var w = width - outlineWidth / 2;
      var y = getCenterYcoordCircleAdditionalInfo();
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
      Utils.drawPercentagePointerOnCircle(dc, barX, y, w, maxPercentage,
                                          outlineWidth);
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
        Utils.drawPercentageText(dc, x, y, fontValue, value, percentage - 200,
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

  }

  enum {
    LayoutMiddleCircle = 0,
    LayoutMiddleTriangle = 1,
    // LayoutMiddleSmart = 2,
  }
}