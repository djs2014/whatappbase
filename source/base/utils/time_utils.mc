import Toybox.Time;
import Toybox.Application;
import Toybox.System;
import Toybox.Lang;

using Toybox.Time.Gregorian as Calendar;
module WhatAppBase {
  (:Utils) 
  module Utils {
    function isDelayedFor(timevalue, minutesDelayed) {
      //! True if timevalue is later than now + minutesDelayed
      if (timevalue == null || minutesDelayed <= 0) {
        return false;
      }

      if (timevalue instanceof Lang.Number) {
        return (Time.now().value() - timevalue) > (minutesDelayed * 60);
      } else if (timevalue instanceof Time.Moment) {
        return Time.now().compare(timevalue) > (minutesDelayed * 60);
      }

      return false;
    }

    function ensureXSecondsPassed(previousMomentInSeconds as Lang.Number,
                                  seconds as Lang.Number) as Lang.Boolean {
      if (previousMomentInSeconds == null || previousMomentInSeconds <= 0) {
        return true;
      }
      var diff = Time.now().value() - previousMomentInSeconds;
      System.println("ensureXSecondsPassed difference: " + diff);
      return diff >= seconds;
    }

    function getDateTimeString(moment) {
      if (moment != null && moment instanceof Time.Moment) {
        var date = Calendar.info(moment, Time.FORMAT_SHORT);
        return date.day.format("%02d") + "-" + date.month.format("%02d") + "-" +
               date.year.format("%d") + " " + date.hour.format("%02d") + ":" +
               date.min.format("%02d") + ":" + date.sec.format("%02d");
      }
      return "";
    }

    function getTimeString(moment) {
      if (moment != null && moment instanceof Time.Moment) {
        var date = Calendar.info(moment, Time.FORMAT_SHORT);
        return date.hour.format("%02d") + ":" + date.min.format("%02d") + ":" +
               date.sec.format("%02d");
      }
       return "";
    }

    function getShortTimeString(moment) {
      if (moment != null && moment instanceof Time.Moment) {
        var date = Calendar.info(moment, Time.FORMAT_SHORT);
        return date.hour.format("%02d") + ":" + date.min.format("%02d");
      }
       return "";
    }
  }
}