import Toybox.Lang;
import Toybox.System;
import Toybox.Graphics;

module WhatAppBase {
  class ZoneInfo {
    var zone as Number = 0;
    var name as String = "";
    var color as ColorType = Graphics.COLOR_WHITE;
    var fontColor as ColorType = Graphics.COLOR_BLACK;
    var perc as Numeric = 0.0;
    var color100perc as ColorType?;

    function initialize(zone as Number, name  as String, color as ColorType, 
      fontColor as ColorType, perc as Numeric, color100perc as ColorType?) {
      self.zone = zone;
      self.name = name;
      self.color = color;
      self.fontColor = fontColor;
      self.perc = perc;
      if (self.perc == null) { self.perc = 0; }      
      self.color100perc = color100perc;
    }
  }
}