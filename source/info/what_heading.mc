module WhatAppBase {import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;

class WhatHeading extends WhatBase {
  hidden var calculatedHeading = null;
  hidden var currentHeading = 0;

  hidden var previousLocation = null;
  hidden var currentLocation = null;
  hidden var currentLocationAccuracy = 0;
  hidden var minimalLocationAccuracy = 1;

  function initialize() { WhatBase.initialize(); }
  function setMinimalLocationAccuracy(minimalLocationAccuracy) {
    self.minimalLocationAccuracy = minimalLocationAccuracy;
  }
  function updateInfo(info as Activity.Info) {
    if (info has : currentHeading) {
      // skip 0 and null values
      if (info.currentHeading) {
        currentHeading = info.currentHeading;
      }
      // System.println(currentHeading);
    }

    if (info has : currentLocation) {
      if (info.currentLocation) {
        previousLocation = currentLocation;
        currentLocation = info.currentLocation;
        // System.println("loc: " +  currentLocation.toDegrees());
      }
    }

    if (info has : currentLocationAccuracy) {
      currentLocationAccuracy = 0;
      if (info.currentLocationAccuracy) {
        currentLocationAccuracy = info.currentLocationAccuracy;
      }
      // System.println("currentLocationAccuracy: " +  currentLocationAccuracy);
    }
  }

  function getCurrentHeading() {
    if (currentLocationAccuracy >= minimalLocationAccuracy) {
      return self.calculatedHeading;
    } else {
      return self.currentHeading;
    }
  }

  function getUnitsLong() as String { return ""; }

  function getUnits() as String { 
    if (!currentLocationAccuracy) {
      return currentLocationAccuracy.format("%0.0f");  // @@ TEST
    } 
    return "";
  }

  function getFormatString(fieldType) as String {
    switch (fieldType) {
      case OneField:
      case WideField:
        return "%.2f";
      case SmallField:
      default:
        return "%.1f";
    }
  }

  function convertToDisplayFormat(value, fieldType) as string {
    var degrees = null;
    if (currentLocationAccuracy >= minimalLocationAccuracy) {
      degrees = getCalculatedHeading();
    } else {
      if (currentHeading != null) {
        degrees = rad2deg(currentHeading);
      }
    }
    if (degrees == null) {
      return "";
    }

    return getCompassDirection(degrees);
  }

  function getCalculatedHeading() {
    if (previousLocation == null || currentLocation == null) {
      return null;
    }

    var llFrom = previousLocation.toDegrees();
    var lat1 = llFrom[0];
    var lon1 = llFrom[1];
    var llTo = currentLocation.toDegrees();
    var lat2 = llTo[0];
    var lon2 = llTo[1];
    return getRhumbLineBearing(lat1, lon1, lat2, lon2);
  }

  function getZoneInfo(rpm) {
    return new ZoneInfo(0, "Heading", Graphics.COLOR_WHITE,
                        Graphics.COLOR_BLACK, 0, null);
  }
}}