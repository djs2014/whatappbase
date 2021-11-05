import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
using Toybox.Time.Gregorian as Calendar;
module WhatAppBase {
  class WhatTime extends WhatInfoBase {
    hidden var now;
    function initialize() {
      WhatInfoBase.initialize();
      now = Calendar.info(Time.now(), Time.FORMAT_SHORT);
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(now); }
    function getValue() { return now; }
    function getFormattedValue() as Lang.String {
      now = Calendar.info(Time.now(), Time.FORMAT_SHORT);
      var nowMin = now.min;
      var nowHour = now.hour;
      if (!mDevSettings.is24Hour) {
        nowHour = (nowHour + 11).toNumber() % 12 + 1;
      }
      return nowHour.format("%02d") + ":" + nowMin.format("%02d");
    }
    function getUnits() as String {
      if (!mDevSettings.is24Hour) {
        var nowHour = now.hour;
        if (nowHour > 12) {
          return "pm";
        } else {
          return "am";
        }
      }

      return "";
    }
    function getLabel() as Lang.String { return "Time of day"; }

    // --
    hidden function getTime() { return Time.now(); }

    hidden function _getZoneInfo(value) as ZoneInfo {
      var label = now.day + "-" + now.month;
      var percentage = 0;
      return new ZoneInfo(0, label, Graphics.COLOR_WHITE, Graphics.COLOR_BLACK,
                          percentage, null);
    }

    // @@ TODO
    // https://gist.github.com/adam-carter-fms/a44a14c0a8cdacbbc38276f6d553e024
    // calc sunset perc .. sunrise .. close to sunset // grayscale color ->
    // white to dark gray?
    // perc to sunset/ sunrise
  }
}