import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
// using WhatAppBase.Utils;
module WhatAppBase {
  class WhatDisplay {
    hidden var mDc as Dc?;
    // bug for edge 830, no transparent text if background has multiple colors
    hidden var mTransparentTextNotPossible as Boolean = true;
    hidden var margin as Number = 1;  // y @@ -> convert to marginTop/marginBottom
    hidden var marginTop as Number = 1;
    hidden var marginLeft as Number = 1;
    hidden var marginRight as Number = 1;
    hidden var heightPercentageLineBottomBar as Number = 2;
    hidden var backgroundColor as ColorType = Graphics.COLOR_WHITE;
    hidden var nightMode as Boolean = false;
    hidden var showTopInfo as Boolean = true;
    hidden var showLeftInfo as Boolean = true;
    hidden var showRightInfo as Boolean = true;
    hidden var showBottomInfo as Boolean = true;
    hidden var middleLayout as LayoutMiddle = LayoutMiddleTriangle;

    hidden var mFontBottomLabel as FontType = Graphics.FONT_TINY;
    hidden var mFontBottomValue as FontType = Graphics.FONT_TINY;
    hidden var mFontBottomValueStartIndex as Number = 1;
    //hidden var mFontsBottomValue as Array<FontType> = [4];
    hidden var mFontsBottomValue as Array = [
      Graphics.FONT_TINY, Graphics.FONT_SYSTEM_SMALL,
      Graphics.FONT_SYSTEM_MEDIUM, Graphics.FONT_SYSTEM_LARGE
    ];
    hidden var mFontUnits as FontType = Graphics.FONT_XTINY;

    // @@ rename mFontsValue to --mFontValue
    hidden var mFontLabelAdditional as FontType = Graphics.FONT_XTINY;
    hidden var mFontValueStartIndex as Number = 1;
    hidden var mFontsValue as Array = [
      Graphics.FONT_SYSTEM_SMALL, Graphics.FONT_SYSTEM_MEDIUM,
      Graphics.FONT_SYSTEM_LARGE, Graphics.FONT_NUMBER_MILD,
      Graphics.FONT_NUMBER_HOT
    ];
    hidden var mRadiusInfoField as Number = 15;

    hidden var COLOR_MAX_PERCENTAGE as ColorType = Colors.COLOR_WHITE_DK_PURPLE_4;

    var fieldWidth as Number = 0;
    var fieldHeight as Number = 0;
    var fieldCenterY as Number = 0;
    var fieldCenterX as Number = 0;
    var fieldType as Types.FieldType = Types.SmallField;

    function initialize() {
      // mFontsBottomValue[0] = Graphics.FONT_TINY;
      // mFontsBottomValue[1] = Graphics.FONT_SYSTEM_SMALL;
      // mFontsBottomValue[2] = Graphics.FONT_SYSTEM_MEDIUM;
      // mFontsBottomValue[3] = Graphics.FONT_SYSTEM_LARGE;
    }

    function isSmallField() as Boolean { return fieldType == Types.SmallField; }
    function isWideField() as Boolean { return fieldType == Types.WideField; }
    function isLargeField() as Boolean { return fieldType == Types.LargeField; }
    function isOneField() as Boolean { return fieldType == Types.OneField; }
    function isNightMode() as Boolean { return nightMode; }
    function setNightMode(nightMode as Boolean) as Void { self.nightMode = nightMode; }
    function setMiddleLayout(middleLayout as LayoutMiddle) as Void { self.middleLayout = middleLayout; }
    function setShowTopInfo(showTopInfo as Boolean) as Void { self.showTopInfo = showTopInfo; }
    function setShowLeftInfo(showLeftInfo as Boolean) as Void { self.showLeftInfo = showLeftInfo; }    
    function setShowRightInfo(showRightInfo as Boolean) as Void { self.showRightInfo = showRightInfo; }
    function setShowBottomInfo(showBottomInfo as Boolean) as Void { self.showBottomInfo = showBottomInfo; }

    function onLayout(dc as Dc) as Void {
      mDc = dc;

      fieldWidth = dc.getWidth();
      fieldHeight = dc.getHeight();
      fieldCenterY = fieldHeight / 2;
      fieldCenterX = fieldWidth / 2;
      fieldType = Utils.getFieldType(dc);
          
      // @@ function to set fonts + some dimensions
      mRadiusInfoField = Utils.min(fieldWidth / 4, fieldHeight / 2 + 10).toNumber();
      mFontValueStartIndex = 4;
      mFontBottomValueStartIndex = 3;
      if (isSmallField()) {
        mRadiusInfoField = 29;
        mFontValueStartIndex = 1;
        mFontBottomValueStartIndex = 1;
      } else if (isWideField()) {
        if (!showBottomInfo && !showTopInfo) {
          mRadiusInfoField = fieldWidth / 4;
        }
        mFontValueStartIndex = 3;
        mFontLabelAdditional = Graphics.FONT_TINY;  // @@ test
      } else if (isLargeField()) {
        if (!showBottomInfo && !showTopInfo) {
          mRadiusInfoField = fieldWidth / 4;
        }
        mFontLabelAdditional = Graphics.FONT_TINY;  // @@ test
      } else {
        mFontLabelAdditional = Graphics.FONT_TINY;  // @@ test
      }
    }

    function onUpdate(dc as Dc) as Void {
      if (dc has :setAntiAlias) { // @@ Where to use..
        dc.setAntiAlias(true);
      }
      onLayout(dc);
    }

    function leftAndRightCircleFillWholeScreen() as Boolean {
      return fieldWidth - 40 < (4 * mRadiusInfoField) + (marginLeft + marginRight);
    }

    function drawTopInfo(label as String, value as String, units as String, 
              zone as ZoneInfo, altZone as ZoneInfo, maxZone as ZoneInfo) as Void {
      var color = zone.fontColor;
      var backColor = zone.color;
      var percentage = zone.perc;
      var color100perc = zone.color100perc;
      var outlinePerc = altZone.perc;
      var outlineColor = altZone.color;

      var barX = fieldCenterX;
      if (middleLayout == LayoutMiddleTriangle) {
        drawTopInfoTriangle(color, value, backColor, units, outlineColor, percentage, color100perc, label);
        return;
      }

      // circle back color
      drawAdditonalInfoBG(barX, mRadiusInfoField, backColor, percentage,
                          color100perc, outlinePerc, outlineColor, altZone.color100perc);

      var dc = mDc as Dc;
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

    function drawTopInfoTriangle(color as ColorType, value as String, backColor as ColorType, units as String, outlineColor as ColorType, 
              percentage as Numeric, color100perc as ColorType?, label as String) as Void {
      var dc = mDc as Dc;                
      var heightBottomBar = 0;
      if (showBottomInfo) {
        if (leftAndRightCircleFillWholeScreen()) {
          heightBottomBar = heightPercentageLineBottomBar;
        } else {
          heightBottomBar = dc.getFontHeight(mFontBottomValue);
        }
      }
      var wBottomBar = 2 * mRadiusInfoField;
      var top = new Utils.Point(fieldCenterX, margin);
      var left = new Utils.Point(fieldCenterX - wBottomBar / 2,
                           fieldHeight - margin - heightBottomBar);
      var right = new Utils.Point(fieldCenterX + wBottomBar / 2,
                            fieldHeight - margin - heightBottomBar);
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

      pts = Utils.getPercentageTrianglePts(topInner, leftInner, rightInner, percentage);
      dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);

      if (!leftAndRightCircleFillWholeScreen()) {
        var maxwidth = (right.x - left.x);
        var x = left.x + maxwidth / 2.0;
        var fontValue =
            Utils.getMatchingFont(dc, mFontsValue, mRadiusInfoField * 2, value,
                                  mFontValueStartIndex - 1);
        // var y = (left.y - top.y) / 2;
        var y = fieldCenterY;
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

    function drawBottomInfoBG(label as String, value as String, units as String, zone as ZoneInfo, altZone as ZoneInfo, maxZone as ZoneInfo) as Void {
      var dc = mDc as Dc;
      var backColor = zone.color;
      var percentage = zone.perc;
      var color100perc = zone.color100perc;

      if (percentage >= 0 && leftAndRightCircleFillWholeScreen()) {
        // Percentage bar around whole field
        _drawBackgroundPercRectangle(2, 2, fieldWidth - 4,
                                     fieldHeight - 4, backColor,
                                     color100perc, percentage, 4);
      }
    }

    function drawBottomInfoFG(label as String, value as String, units as String, zone as ZoneInfo, altZone as ZoneInfo, maxZone as ZoneInfo) as Void {
      var dc = mDc as Dc;
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

      var xv = fieldCenterX - wAllText / 2;
      var y = fieldHeight - (hv / 2);

      if (backColor != null) {
        dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
      }
      var xb = fieldCenterX - wAllText / 2;
      var yb = fieldHeight - hv;

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
        y = fieldHeight - (hv / 2);
        dc.drawText(
            fieldCenterX, y, fontBottomValue, value,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(fieldCenterX + widthValue / 2 + marginleft2, y,
                    mFontUnits, units,
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        return;
      }

      if (color != null) {dc.setColor(color, Graphics.COLOR_TRANSPARENT);}

      dc.drawText(xv, y, mFontBottomLabel, label, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

      dc.drawText(xv + widthLabel + marginleft1, y, mFontBottomValue, value,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

      dc.drawText(xv + widthLabel + marginleft1 + widthValue + marginleft2, y, mFontUnits, units,
          Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    hidden function _drawBackgroundPercRectangle(x as Number, y as Number, width as Number, height as Number, colorPercentageLine as ColorType,
            color100perc as ColorType?, percentage as Numeric, lineWidth as Number) as Void {
      var dc = mDc as Dc;              
      if (percentage > 100 && color100perc != null) {
        Utils.drawPercentageRectangle(dc, x, y, width, height, 100, color100perc, lineWidth);
        // percentage = percentage - 100;
        percentage = percentage.toNumber() % 100;
        // colorPercentageLine = color100perc;
      }
      Utils.drawPercentageRectangle(dc, x, y, width, height, percentage,colorPercentageLine, lineWidth);    
    }

    function drawLeftInfo(label as String, value as String, units as String, zone as ZoneInfo, altZone as ZoneInfo, maxZone as ZoneInfo) as Void {
      var dc = mDc as Dc;
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
                          color100perc, outlinePerc, outlineColor, altZone.color100perc);

      drawMaxInfo(barX, mRadiusInfoField, maxPercentage, -2);

      var fontValue = Utils.getMatchingFont(dc, mFontsValue, mRadiusInfoField * 2, value, mFontValueStartIndex);
      // @@ determine labelFont??//
      drawAdditonalInfoFG(barX, color, value, fontValue, units,
                          mFontLabelAdditional, label, mFontLabelAdditional,
                          percentage);

      drawAdditonalInfoOutline(barX, mRadiusInfoField, outlineColor);
    }

    function drawRightInfo(label as String, value as String, units as String, 
              zone as ZoneInfo, altZone as ZoneInfo, maxZone as ZoneInfo) as Void {
      var dc = mDc as Dc;                
      var color = zone.fontColor;
      var backColor = zone.color;
      var percentage = zone.perc;
      var color100perc = zone.color100perc;
      var outlinePerc = altZone.perc;
      var outlineColor = altZone.color;
      var barX = fieldWidth - mRadiusInfoField - marginRight;
      var maxPercentage = maxZone.perc;
      // circle
      drawAdditonalInfoBG(barX, mRadiusInfoField, backColor, percentage,
                          color100perc, outlinePerc, outlineColor, altZone.color100perc);
      drawMaxInfo(barX, mRadiusInfoField, maxPercentage, 2);

      // units + value
      var fontValue = Utils.getMatchingFont(dc, mFontsValue, mRadiusInfoField * 2, value, mFontValueStartIndex);

      drawAdditonalInfoFG(barX, color, value, fontValue, units,
                          mFontLabelAdditional, label, mFontLabelAdditional, percentage);

      // outline
      drawAdditonalInfoOutline(barX, mRadiusInfoField, outlineColor);
    }   

    hidden function drawAdditonalInfoBG(x as Number, width as Number, color as ColorType, percentage as Numeric, 
              color100perc as ColorType?, outlinePerc as Numeric, outlineColor as ColorType, outlineColor100perc as ColorType?) as Void {
      var dc = mDc as Dc;
      var y = fieldCenterY;

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
          Utils.drawPercentageCircle(dc, x, y, w, outlinePerc - 100, outlineWidth);
        }
      }
    }

    function drawMaxInfo(barX as Number, width as Number, maxPercentage as Numeric?, loopIndicator as Number) as Void {
      if (maxPercentage == null) { return; }
      if (maxPercentage <= 0) { return; }
      var dc = mDc as Dc;
      var outlineWidth = width;
      var w = width - outlineWidth / 2;
      var y = fieldCenterY;
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
      Utils.drawPercentagePointerOnCircle(dc, barX, y, w, maxPercentage, outlineWidth, loopIndicator);
    }

    hidden function drawAdditonalInfoFG(x as Number, color as ColorType, value as String, fontValue as FontType, units as String,
                                        fontUnits as FontType, label as String, fontLabel as FontType, percentage as Numeric) as Void {
      // Too many arguments used by a method, which are currently limited to 10  arguments
      var dc = mDc as Dc;
      var width = mRadiusInfoField;
      var y = fieldCenterY;

      // label
      if (!isSmallField() && label != null && label.length() > 0) {
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        var yLabel = y - (dc.getFontHeight(fontValue) / 2) -
                     (dc.getFontHeight(fontLabel) / 2) + marginTop;
        dc.drawText(x, yLabel, fontLabel, label,Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }

      // value
      if (percentage < 200 || mTransparentTextNotPossible) {
        if (percentage < 200) {
          dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        } else {
          dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(x, y, fontValue, value,Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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
        dc.drawText(x, y, fontUnits, units, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
    }

    hidden function drawAdditonalInfoOutline(x as Number, width as Number, color as ColorType) as Void {
      var dc = mDc as Dc;
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
      dc.drawCircle(x, fieldCenterY, width);
    }

  }

  enum LayoutMiddle {
    LayoutMiddleCircle = 0,
    LayoutMiddleTriangle = 1    
  }
}