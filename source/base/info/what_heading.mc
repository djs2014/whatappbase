import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
import Toybox.Position;
module WhatAppBase {
  class WhatHeading extends WhatInfoBase {
    hidden var calculatedHeadingGPS = null as Lang.Float;
    hidden var currentHeading = 0.0f as Lang.Float;
    hidden var track = 0.0f as Lang.Float;

    hidden var previousDegrees = 0 as Lang.Number;

    hidden var previousLocation = null as Position.Location;
    hidden var currentLocation = null as Position.Location;
    hidden var currentLocationAccuracy = 0 as Lang.Number;
    hidden var minimalLocationAccuracy = 1 as Lang.Number;

    function initialize() {
      WhatInfoBase.initialize();
      labelHidden = true;
    }

    function setMinimalLocationAccuracy(minimalLocationAccuracy) {
      self.minimalLocationAccuracy = minimalLocationAccuracy;
    }

    function updateInfo(info as Activity.Info) as Void {
      if (info has : currentHeading) {
        // currentHeading is Compass
        if (info.currentHeading != null && info.currentHeading != 0.0f) {
          currentHeading = info.currentHeading;
        }
        System.println("currentHeading Compass: " + currentHeading);
      }

      if (info has : track) {
        // track is GPS or Compass
        if (info.track != null && info.track != 0.0f) {
          track = info.track;
        }
        System.println("track GPS/Compass: " + track);
      }

      if (info has : currentLocation) {
        if (info.currentLocation != null) {
          // @@ TODO: only when distance is large enough?
          previousLocation = currentLocation;
          currentLocation = info.currentLocation;
          System.println("currentLocation: " + currentLocation.toDegrees());
        }
      }

      if (info has : currentLocationAccuracy) {
        currentLocationAccuracy = 0;
        if (info.currentLocationAccuracy != null) {
          currentLocationAccuracy = info.currentLocationAccuracy;
        }
        // System.println("currentLocationAccuracy: " +
        // currentLocationAccuracy);
      }
    }

    function getUnitsLong() as Lang.String { return ""; }

    function getUnits() as String {
      if (!currentLocationAccuracy) {
        return currentLocationAccuracy.format(
            "%0.0f");  // @@ TEST show GPS bars ..
      }
      return "";
    }

    function getFormatString(fieldType) as Lang.String {
      switch (fieldType) {
        case Types.OneField:
        case Types.WideField:
          return "%.2f";
        case Types.SmallField:
        default:
          return "%.1f";
      }
    }

    function validGPS() as Lang.Boolean {
      return (currentLocationAccuracy >= minimalLocationAccuracy);
    }

    function getCurrentHeadingInDegrees() as Lang.Number {
      var degrees = null;
      if (track != null && track != 0.0f) {
        degrees = Utils.rad2deg(track);
      } else if (validGPS()) {
        degrees = getCalculatedHeading();
      } else if (currentHeading != null && currentHeading != 0.0f) {
        degrees = Utils.rad2deg(currentHeading);
      }
      if (degrees == null) {
        degrees = previousDegrees;
      }
      previousDegrees = degrees;
      return degrees;
    }

    function convertToDisplayFormat(value, fieldType) as Lang.String {
      var degrees = value;

      if (degrees == null) {
        return "";
      }

      return Utils.getCompassDirection(degrees);
    }

    // Heading in degrees
    function getCalculatedHeading() {
      if (previousLocation == null || currentLocation == null) {
        return null;
      }

      var llFrom = previousLocation.toDegrees() as Lang.Array<Lang.Double>;
      var lat1 = llFrom[0];
      var lon1 = llFrom[1];
      var llTo = currentLocation.toDegrees() as Lang.Array<Lang.Double>;
      var lat2 = llTo[0];
      var lon2 = llTo[1];
      return Utils.getRhumbLineBearing(lat1, lon1, lat2, lon2);
    }

    function getZoneInfo(rpm) as ZoneInfo {
      return new ZoneInfo(0, "Heading", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
  }
}