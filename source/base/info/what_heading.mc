import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
import Toybox.Position;
module WhatAppBase {
  class WhatHeading extends WhatInfoBase {
    hidden var calculatedHeadingGPS as Float?;
    hidden var currentHeading as Float = 0.0f;
    hidden var track as Float = 0.0f;

    hidden var previousDegrees as Number = 0;

    hidden var previousLocation as Position.Location?;
    hidden var currentLocation as Position.Location?;
    hidden var currentLocationAccuracy as Number = Position.QUALITY_NOT_AVAILABLE;
    hidden var minimalLocationAccuracy as Number = Position.QUALITY_NOT_AVAILABLE;

    hidden var previousElapsedDistance as Float = 0.0f;
    hidden var elapsedDistance as Float = 0.0f;
    hidden var currentElapsedDistanceInMeters as Float = 0.0f;
    hidden var minimalElapsedDistanceInMeters as Number = 0;

    function initialize() {
      WhatInfoBase.initialize();
      mLabelHidden = true;
    }

    // Set to 0 to disable custom GPS calculation
    function setMinimalLocationAccuracy(minimalLocationAccuracy as Number) as Void {
      self.minimalLocationAccuracy = minimalLocationAccuracy;
    }
    // Set to 0 to disable custom GPS calculation
    function setMinimalElapsedDistanceInMeters(minimalElapsedDistanceInMeters as Number) as Void {
      self.minimalElapsedDistanceInMeters = minimalElapsedDistanceInMeters;
    }

    function updateInfo(info as Activity.Info) as Void {
      if (info has :currentHeading) {
        // currentHeading is Compass
        if (info.currentHeading != null && info.currentHeading != 0.0f) {
          currentHeading = info.currentHeading as Float;
        }
        System.println("currentHeading Compass: " + currentHeading);
      }

      if (info has :track) {
        // track is GPS or Compass
        if (info.track != null && info.track != 0.0f) {
          track = info.track as Float;
        }
        System.println("track GPS/Compass: " + track);
      }

      if (info has :currentLocation) {
        if (info.currentLocation != null) {
          previousLocation = currentLocation;
          currentLocation = info.currentLocation as Location;
          System.println("currentLocation: " + currentLocation.toDegrees());
        }
      }

      if (info has :currentLocationAccuracy) {
        currentLocationAccuracy = 0;
        if (info.currentLocationAccuracy != null) {
          currentLocationAccuracy = info.currentLocationAccuracy as Number;
        }        
      }

      if (info has :elapsedDistance) {
        previousElapsedDistance = elapsedDistance;
        if (info.elapsedDistance != null) {
          elapsedDistance = info.elapsedDistance as Float;
        } else {
          elapsedDistance = 0.0f;
        }
        // Distance between the two gps locations
        currentElapsedDistanceInMeters = elapsedDistance - previousElapsedDistance;
      }
    }

    function getZoneInfo() as ZoneInfo { return _getZoneInfo(getCurrentHeadingInDegrees()); }
    
    function getFormattedValue() as String {
      var degrees = getCurrentHeadingInDegrees();
      if (degrees == null) { return ""; }      
      return Utils.getCompassDirection(degrees as Number);
    }
    function getUnits() as String { return ""; }
    function getLabel() as String { return "Heading"; }

    hidden function validGPS() as Boolean {
      return (minimalLocationAccuracy > 0 &&
              minimalElapsedDistanceInMeters > 0 &&
              currentLocationAccuracy >= minimalLocationAccuracy &&
              currentElapsedDistanceInMeters > minimalElapsedDistanceInMeters);
    }

    hidden function getCurrentHeadingInDegrees() as Number? {
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
      previousDegrees = degrees as Number;
      return degrees as Number?;
    }

    // Heading in degrees
    function getCalculatedHeading() as Number? {
      if (previousLocation == null || currentLocation == null) {
        return null;
      }
      var prevLocation = previousLocation as Location;
      var llFrom = prevLocation.toDegrees() as Array<Double>;
      var lat1 = llFrom[0];
      var lon1 = llFrom[1];
      var curLocation = currentLocation as Location;
      var llTo = curLocation.toDegrees() as Array<Double>;
      var lat2 = llTo[0];
      var lon2 = llTo[1];
      return Utils.getRhumbLineBearing(lat1, lon1, lat2, lon2);
    }

    // @@ TODO
    function _getZoneInfo(degrees as Number?) as ZoneInfo {
      return new ZoneInfo(0, "Heading", Graphics.COLOR_WHITE,
                          Graphics.COLOR_BLACK, 0, null);
    }
  }
}