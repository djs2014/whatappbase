import Toybox.Activity;
import Toybox.Lang;
import Toybox.System;
using Toybox.Time.Gregorian as Calendar;
module WhatAppBase {
  class WhatTime extends WhatInfoBase {
    hidden var now;
    hidden var elapsedTime = 0.0f;  // msec
    hidden var timerTime = 0.0f;    // msec
    hidden var targetTimeMinutes = 0.0f;

    function initialize() {
      WhatInfoBase.initialize();
      now = Calendar.info(Time.now(), Time.FORMAT_SHORT);
    }

    function setTargetTime(targetTimeMinutes) {
      self.targetTimeMinutes = targetTimeMinutes;
    }

    function updateInfo(info as Activity.Info) {
      if (info has : elapsedTime) {
        if (info.elapsedTime != null) {
          elapsedTime = info.elapsedTime;
        } else {
          elapsedTime = 0.0f;
        }
      }
      if (info has : timerTime) {
        if (info.timerTime != null) {
          timerTime = info.timerTime;
        } else {
          timerTime = 0.0f;
        }
      }
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

    // Timer
    function getTimerZoneInfo() as ZoneInfo {
      var label = "Timer";
      var percentage = 0;
      return new ZoneInfo(0, label, Graphics.COLOR_WHITE, Graphics.COLOR_BLACK,
                          percentage, null);
    }
    function getTimerFormattedValue() as Lang.String {
      if (timerTime == null) {
        return "";
      }
      var hours = ((timerTime / (1000.0 * 60 * 60)).toNumber() % 24);
      var minutes = ((timerTime / (1000.0 * 60.0)).toNumber() % 60);
      return hours.format("%02d") + ":" + minutes.format("%02d");
    }
    function getTimerUnits() as String {
      if (timerTime == null) {
        return "";
      }
      var seconds = (timerTime / 1000.0).toNumber() % 60;
      return seconds.format("%02d");
    }

    function getTimerLabel() as String { return "Timer"; }

    function getElapsedZoneInfo() as ZoneInfo {
      var label = "Elapsed";
      var percentage = 0;
      return new ZoneInfo(0, label, Graphics.COLOR_WHITE, Graphics.COLOR_BLACK,
                          percentage, null);
    }
    function getElapsedFormattedValue() as Lang.String {
      if (elapsedTime == null) {
        return "";
      }
      var hours = ((elapsedTime / (1000.0 * 60 * 60)).toNumber() % 24);
      var minutes = ((elapsedTime / (1000.0 * 60.0)).toNumber() % 60);
      return hours.format("%02d") + ":" + minutes.format("%02d");
    }
    function getElapsedUnits() as String {
      if (elapsedTime == null) {
        return "";
      }
      var seconds = (elapsedTime / 1000.0).toNumber() % 60;
      return seconds.format("%02d");
    }

    function getElapsedLabel() as String { return "Elapsed"; }
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