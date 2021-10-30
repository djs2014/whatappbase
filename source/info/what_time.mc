module WhatAppBase {import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
using Toybox.Time.Gregorian as Calendar;

class WhatTime extends WhatBase {
  hidden var now;
  function initialize() {
    WhatBase.initialize();  
    now = Calendar.info(Time.now(), Time.FORMAT_SHORT);
  }

  function getTime() { return Time.now(); }

  function getUnits() as String {
    if (!devSettings.is24Hour) {
      var nowHour = now.hour;
      if (nowHour > 12) {
        return "pm";
      } else {
        return "am";
      }
    }

    return "";
  }

  function convertToDisplayFormat(value, fieldType) as Lang.String {
    if (value == null) {
      return "";
    }

    now = Calendar.info(Time.now(), Time.FORMAT_SHORT);
    var nowMin = now.min;
    var nowHour = now.hour;
    if (!devSettings.is24Hour) {
      nowHour = (nowHour + 11).toNumber() % 12 + 1;
    }
    return nowHour.format("%02d") + ":" + nowMin.format("%02d");
  }

  function getZoneInfo(value) as ZoneInfo {
    var label = now.day + "-" + now.month;
    var percentage = 0;
    return new ZoneInfo(0, label, Graphics.COLOR_WHITE, Graphics.COLOR_BLACK, percentage, null);
  }

  
  // https://gist.github.com/adam-carter-fms/a44a14c0a8cdacbbc38276f6d553e024 calc sunset
  // perc .. sunrise .. close to sunset // grayscale color -> white to dark gray?
}}