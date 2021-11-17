import Toybox.System;
import Toybox.Lang;
module WhatAppBase {
  (:Utils)
  module Utils {
    const MILE = 1.609344;
    const FEET = 3.281;
    const POUND = 2.20462262;

    function windSpeedToBeaufort(metersPerSecond as Numeric?) as Number {
      if (metersPerSecond == null) { return 0; }
      if (metersPerSecond <= 0.2) { return 0; }
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

    function mpsToKmPerHour(metersPerSecond as Numeric?) as Float {
      if (metersPerSecond == null) {
        return 0.0f;
      }
      return (metersPerSecond * 60 * 60) / 1000.0;
    }

    function celciusToFarenheit(celcius as Numeric?) as Float {
      if (celcius == null) {
        return 0.0f;
      }
      return ((celcius * 9 / 5) + 32);
    }

    // pascal -> mbar (hPa)
    function pascalToMilliBar(pascal as Numeric?) as Float {
      if (pascal == null) {
        return 0.0f;
      }
      return pascal / 100.0;
    }

    function meterToFeet(meter as Numeric?) as Float {
      if (meter == null) {
        return 0.0f;
      }
      return meter * FEET;
    }

    function kilometerToMile(km as Numeric?) as Float {
      if (km == null) {
        return 0.0f;
      }
      return km / MILE;
    }

    // kilogram to pounds
    function kilogramToLbs(kg as Numeric?) as Float {
      if (kg == null) {
        return 0.0f;
      }
      return kg * POUND;
    }

    function removeLeadingZero(value as String) as String{
      if (value.substring(0, 1) == "0.") {
        return value.substring(2, value.length());
      }
      return value;
    }

    function startsWith(value as String, part as String) as Boolean {
      if (value == null || part == null) {
        return false;
      }
      return (value.substring(0, value.length() - 1) == part);
    }
  }
}