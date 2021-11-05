module WhatAppBase {
  class ZoneInfo {
    var zone;
    var name;
    var color;
    var fontColor;
    var perc = 0;
    var color100perc;

    function initialize(zone, name, color, fontColor, perc, color100perc) {
      self.zone = zone;
      self.name = name;
      self.color = color;
      self.fontColor = fontColor;
      if (perc != null) {
        self.perc = perc;
      }
      self.color100perc = color100perc;
    }
  }
}