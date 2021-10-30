import Toybox.System;
import Toybox.Lang;
module WhatAppBase {
  ( : Utils) module Utils {
    const MILE = 1.609344;
    const FEET = 3.281;

    function windSpeedToBeaufort(metersPerSecond) {
      if (metersPerSecond == null || metersPerSecond <= 0.2) {
        return 0;
      }
      if (metersPerSecond <= 1.5) {
        return 1;
      }
      if (metersPerSecond <= 3.3) {
        return 2;
      }
      if (metersPerSecond <= 5.4) {
        return 3;
      }
      if (metersPerSecond <= 7.9) {
        return 4;
      }
      if (metersPerSecond <= 10.7) {
        return 5;
      }
      if (metersPerSecond <= 13.8) {
        return 6;
      }
      if (metersPerSecond <= 17.1) {
        return 7;
      }
      if (metersPerSecond <= 20.7) {
        return 8;
      }
      if (metersPerSecond <= 24.4) {
        return 9;
      }
      if (metersPerSecond <= 28.4) {
        return 10;
      }
      if (metersPerSecond <= 32.6) {
        return 11;
      }
      return 12;
    }

    function mpsToKmPerHour(metersPerSecond) {
      if (metersPerSecond == null) {
        return 0;
      }
      return (metersPerSecond * 60 * 60) / 1000.0;
    }

    function celciusToFarenheit(celcius) {
      if (celcius == null) {
        return 0;
      }
      return ((celcius * 9 / 5) + 32);
    }

    // pascal -> mbar (hPa)
    function pascalToMilliBar(pascal) {
      if (pascal == null) {
        return 0;
      }
      return pascal / 100.0;
    }

    function meterToFeet(meter) {
      if (meter == null) {
        return 0;
      }
      return meter * FEET;
    }

    function kilometerToMile(km) {
      if (km == null) {
        return 0;
      }
      return km / MILE;
    }

    function removeLeadingZero(value as Lang.String) {
      if (value.substring(0, 1) == "0.") {
        return value.substring(2, value.length());
      }
      return value;
    }

    function startsWith(value, part) {
      if (!value || !part) {
        return value;
      }
      return (value.substring(0, value.length() - 1) == part);
    }
  }
}