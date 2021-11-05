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
    hidden var minimalLocationAccuracy = 0 as Lang.Number;

    hidden var previousElapsedDistance = 0.0f;
    hidden var elapsedDistance = 0.0f;
    hidden var currentElapsedDistanceInMeters = 0.0f;
    hidden var minimalElapsedDistanceInMeters = 0.0f;

    function initialize() {
      WhatInfoBase.initialize();
      mLabelHidden = true;
    }

    // Set to 0 to disable custom GPS calculation
    function setMinimalLocationAccuracy(minimalLocationAccuracy) {
      self.minimalLocationAccuracy = minimalLocationAccuracy;
    }
    // Set to 0 to disable custom GPS calculation
    function setMinimalElapsedDistanceInMeters(minimalElapsedDistanceInMeters) {
      self.minimalElapsedDistanceInMeters = minimalElapsedDistanceInMeters;
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

      if (info has : elapsedDistance) {
        previousElapsedDistance = elapsedDistance;
        if (info.elapsedDistance != null) {
          elapsedDistance = info.elapsedDistance;
        } else {
          elapsedDistance = 0.0f;
        }
        // Distance between the two gps locations
        currentElapsedDistanceInMeters =
            elapsedDistance - previousElapsedDistance;
      }
    }

    function getZoneInfo() as ZoneInfo {
      return _getZoneInfo(getCurrentHeadingInDegrees());
    }
    function getValue() { return getCurrentHeadingInDegrees(); }
    function getFormattedValue() as Lang.String {
      var degrees = getCurrentHeadingInDegrees();
      if (degrees == null) {
        return "";
      }
      return Utils.getCompassDirection(degrees);
    }
    function getUnits() as String { return ""; }
    function getLabel() as Lang.String { return "Heading"; }

    // --
    // function getUnits() as String {
    //   var info = "";
    //   if (mDebug) {
    //     if (currentLocationAccuracy != null) {
    //       info = info + "gps[" + currentLocationAccuracy.format("%0.0f") +
    //       "]";
    //     }
    //     if (currentElapsedDistanceInMeters > 0) {
    //       info = info + "m[" + currentElapsedDistanceInMeters.format("%0.1f")
    //       +
    //              "]";
    //     }
    //     if (track != null) {
    //       // ?? always 0 on simulator?
    //       info = info + "\ntrk[" + Utils.rad2deg(track).format("%0.0f") +
    //       "]";
    //     }

    //     if (currentHeading != null) {
    //       info = info + " hdg[" +
    //              Utils.rad2deg(currentHeading).format("%0.0f") + "]";
    //     }
    //   }
    //   return info;
    // }

    hidden function validGPS() as Lang.Boolean {
      return (minimalLocationAccuracy > 0 &&
              minimalElapsedDistanceInMeters > 0 &&
              currentLocationAccuracy >= minimalLocationAccuracy &&
              currentElapsedDistanceInMeters > minimalElapsedDistanceInMeters);
    }

    hidden function getCurrentHeadingInDegrees() as Lang.Number {
      var degrees = null;
      if (validGPS()) {
        degrees = getCalculatedHeading();
      } else if (track != null && track != 0.0f) {
        degrees = Utils.rad2deg(track);
      } else if (currentHeading != null && currentHeading != 0.0f) {
        degrees = Utils.rad2deg(currentHeading);
      }
      if (degrees == null) {
        degrees = previousDegrees;
      }
      previousDegrees = degrees;
      return degrees;
    }

    hidden function convertToDisplayFormat(value, fieldType) as Lang.String {
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

    // @@ TODO
    function _getZoneInfo(degrees) as ZoneInfo {
      return new ZoneInfo(0, "Heading", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
  }
}