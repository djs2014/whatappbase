module WhatAppBase {
  class ZoneInfo {
    var zone;
    var name;
    var color;
    var fontColor;
    var perc;
    var color100perc;

    function initialize(zone, name, color, fontColor, perc, color100perc) {
      self.zone = zone;
      self.name = name;
      self.color = color;
      self.fontColor = fontColor;
      self.perc = perc;
      self.color100perc = color100perc;
    }
  }
}